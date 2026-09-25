/// 域名竞速服务
///
/// 实现多个域名并发测试，选择响应最快的域名
library;

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mitveepn/xboard/core/core.dart';
import 'package:mitveepn/xboard/infrastructure/http/user_agent_config.dart';

/// 域名竞速服务
class DomainRacingService {
  static const Duration _connectionTimeout = Duration(seconds: 5);
  static const Duration _responseTimeout = Duration(seconds: 8);
  
  /// 设置证书路径（由配置加载器调用）
  static void setCertificatePath(String path) {
    _configuredCertPath = path;
    // 清除缓存的 SecurityContext，下次使用时会重新加载
    _securityContext = null;
  }

  // 缓存加载的证书
  static SecurityContext? _securityContext;
  static String? _configuredCertPath;

  /// Cache kết quả竞速 theo danh sách domain, tránh đua lại nhiều lần khi
  /// khởi động (SDK init và quick auth trước đây đua độc lập 2 lần).
  static const Duration _cacheTtl = Duration(minutes: 5);
  static final Map<String, _RaceCacheEntry> _raceCache = {};

  /// Xoá cache竞速 (dùng khi đổi mạng hoặc cần chọn lại domain).
  static void clearCache() {
    _raceCache.clear();
  }

  /// 获取配置了CA证书的SecurityContext
  static Future<SecurityContext> _getSecurityContext() async {
    if (_securityContext != null) {
      return _securityContext!;
    }

    try {
      XBoardLogger.info('[域名竞速] 加载自定义CA证书');

      // 获取证书路径（优先使用配置文件中的路径）
      String certPath = _configuredCertPath ?? 
          'packages/flutter_xboard_sdk/assets/cer/client-cert.crt';

      // 加载证书文件
      final ByteData certData = await rootBundle.load(certPath);
      final Uint8List certBytes = certData.buffer.asUint8List();

      // 创建SecurityContext并添加证书
      final context = SecurityContext();
      context.setTrustedCertificatesBytes(certBytes);

      _securityContext = context;
      XBoardLogger.info('[域名竞速] CA证书加载成功');

      return _securityContext!;
    } catch (e) {
      XBoardLogger.error('[域名竞速] CA证书加载失败', e);
      // 回退到默认SecurityContext
      _securityContext = SecurityContext.defaultContext;
      return _securityContext!;
    }
  }

  /// 并发竞速选择最快域名
  ///
  /// [domains] 要测试的域名列表
  /// [testPath] 用于测试的路径，默认为空（只测试连通性）
  /// [forceHttpsResult] 是否强制返回HTTPS格式的结果（用于SDK初始化）
  ///
  /// 返回最快响应的域名，如果所有域名都失败则返回null
  static Future<String?> raceSelectFastestDomain(
    List<String> domains, {
    String testPath = '',
    bool forceHttpsResult = false,
  }) async {
    if (domains.isEmpty) return null;
    if (domains.length == 1) return domains.first;

    final cacheKey = '$testPath|$forceHttpsResult|${domains.join(',')}';
    final cached = _raceCache[cacheKey];
    if (cached != null) {
      if (DateTime.now().difference(cached.time) < _cacheTtl) {
        XBoardLogger.info('[域名竞速] dùng kết quả cache: ${cached.winner}');
        return cached.winner;
      }
      _raceCache.remove(cacheKey);
    }

    XBoardLogger.info('[域名竞速] 开始竞速测试 ${domains.length} 个域名');

    // 创建并发测试任务
    final List<Future<DomainTestResult>> futures = [];
    final List<CancelToken> cancelTokens = [];

    for (int i = 0; i < domains.length; i++) {
      final domain = domains[i];
      final cancelToken = CancelToken();
      cancelTokens.add(cancelToken);

      futures.add(_testSingleDomain(domain, testPath, cancelToken, i));
    }

    try {
      // 创建竞速逻辑
      final completer = Completer<String?>();
      int completedCount = 0;
      final errors = <String>[];

      for (int i = 0; i < futures.length; i++) {
        futures[i].then((result) {
          if (!completer.isCompleted && result.success) {
            // 第一个成功的获胜
            XBoardLogger.info(
                '[域名竞速] 🏆 域名 #$i (${result.domain}) 获胜！响应时间: ${result.responseTime}ms');
            completer.complete(result.domain);

            // 取消其他测试
            for (int j = 0; j < cancelTokens.length; j++) {
              if (j != i) cancelTokens[j].cancel();
            }
          } else {
            completedCount++;
            if (result.error != null) {
              XBoardLogger.info(
                  '[域名竞速] ❌ 域名 #$i (${result.domain}) 失败: ${result.error}, 用时: ${result.responseTime}ms');
              errors.add('域名#$i (${result.domain}): ${result.error}');
            }

            // 如果所有测试都完成且都失败了
            if (completedCount == futures.length && !completer.isCompleted) {
              XBoardLogger.warning('[域名竞速] 所有域名测试都失败: ${errors.join('; ')}');
              completer.complete(null);
            }
          }
        }).catchError((e) {
          completedCount++;
          errors.add('域名#$i异常: $e');

          if (completedCount == futures.length && !completer.isCompleted) {
            XBoardLogger.warning('[域名竞速] 所有域名测试都失败: ${errors.join('; ')}');
            completer.complete(null);
          }
        });
      }

      final winner = await completer.future;

      // 如果需要强制HTTPS结果，转换获胜域名
      final result =
          winner != null && forceHttpsResult ? _convertToHttpsUrl(winner) : winner;

      if (result != null) {
        _raceCache[cacheKey] = _RaceCacheEntry(result, DateTime.now());
      }

      return result;
    } catch (e) {
      XBoardLogger.error('[域名竞速] 竞速测试异常', e);
      return null;
    }
  }

  /// 测试单个域名
  static Future<DomainTestResult> _testSingleDomain(
    String domain,
    String testPath,
    CancelToken cancelToken,
    int index,
  ) async {
    final stopwatch = Stopwatch()..start();
    HttpClient? client;

    try {
      XBoardLogger.info('[域名竞速] 开始测试域名 #$index: $domain');

      // 构建测试URL
      final testUrl = _buildTestUrl(domain, testPath);
      XBoardLogger.info('[域名竞速] 域名 #$index 测试URL: $testUrl');

      // 根据域名类型选择HttpClient配置
      final withoutProtocol = domain.replaceFirst(RegExp(r'^https?://'), '');

      if (_isIpWithPort(withoutProtocol)) {
        // IP+端口：使用自定义证书 + 忽略主机名验证
        final securityContext = await _getSecurityContext();
        client = HttpClient(context: securityContext);

        // 忽略主机名验证，只验证证书有效性
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          XBoardLogger.info('[域名竞速] 忽略主机名验证，只检查证书有效性: $host:$port');
          return true; // 接受证书，忽略主机名不匹配
        };

        XBoardLogger.info('[域名竞速] 域名 #$index 使用自定义CA证书(忽略主机名验证)');
      } else {
        // 域名：使用默认证书验证
        client = HttpClient();
        XBoardLogger.info('[域名竞速] 域名 #$index 使用默认证书验证');
      }

      client.connectionTimeout = _connectionTimeout;

      // Khi có domain khác thắng, đóng client ngay để socket không chạy tiếp
      // tới hết timeout.
      final clientRef = client;
      cancelToken.onCancel = () => clientRef.close(force: true);
      if (cancelToken.isCancelled) {
        stopwatch.stop();
        return DomainTestResult.failure(
            domain, '测试被取消', stopwatch.elapsedMilliseconds);
      }

      final uri = Uri.parse(testUrl);
      final request = await client.getUrl(uri);

      // 设置请求头
      if (_isIpWithPort(withoutProtocol)) {
        // IP+端口：使用加密User-Agent（Caddy认证）
        final apiUserAgent = await UserAgentConfig.get(UserAgentScenario.apiEncrypted);
        request.headers.set(HttpHeaders.userAgentHeader, apiUserAgent);
        XBoardLogger.info('[域名竞速] 域名 #$index 使用加密User-Agent（Caddy认证）');
      } else {
        // 域名：使用域名竞速测试User-Agent
        final domainUserAgent = await UserAgentConfig.get(UserAgentScenario.domainRacingTest);
        request.headers.set(HttpHeaders.userAgentHeader, domainUserAgent);
        XBoardLogger.info('[域名竞速] 域名 #$index 使用域名竞速测试User-Agent');
      }
      request.headers.set(HttpHeaders.acceptHeader, '*/*');

      final response = await request.close().timeout(_responseTimeout);

      stopwatch.stop();

      if (cancelToken.isCancelled) {
        XBoardLogger.info('[域名竞速] 域名 #$index 测试完成但已被取消');
        return DomainTestResult.failure(
            domain, '测试被取消', stopwatch.elapsedMilliseconds);
      }

      if (response.statusCode >= 200 && response.statusCode < 400) {
        XBoardLogger.info(
            '[域名竞速] 域名 #$index ($domain) 测试成功，响应时间: ${stopwatch.elapsedMilliseconds}ms');
        return DomainTestResult.success(domain, stopwatch.elapsedMilliseconds);
      } else {
        XBoardLogger.info('[域名竞速] 域名 #$index ($domain) 返回状态码: ${response.statusCode}');
        return DomainTestResult.failure(
            domain, 'HTTP ${response.statusCode}', stopwatch.elapsedMilliseconds);
      }
    } on TimeoutException {
      stopwatch.stop();
      XBoardLogger.info('[域名竞速] 域名 #$index ($domain) 超时');
      return DomainTestResult.failure(
          domain, '连接超时', stopwatch.elapsedMilliseconds);
    } catch (e) {
      stopwatch.stop();
      if (cancelToken.isCancelled) {
        XBoardLogger.info('[域名竞速] 域名 #$index ($domain) 被正常取消');
        return DomainTestResult.failure(
            domain, '测试被取消', stopwatch.elapsedMilliseconds);
      }

      XBoardLogger.info('[域名竞速] 域名 #$index ($domain) 测试失败: $e');
      return DomainTestResult.failure(
          domain, '连接失败: $e', stopwatch.elapsedMilliseconds);
    } finally {
      // Đóng ở finally: nhánh timeout/exception trước đây rò HttpClient.
      client?.close(force: true);
    }
  }

  /// 构建测试URL
  static String _buildTestUrl(String domain, String testPath) {
    String baseUrl;

    if (domain.startsWith('http')) {
      // 已有协议前缀，强制转换为HTTPS
      final withoutProtocol = domain.replaceFirst(RegExp(r'^https?://'), '');
      baseUrl = 'https://$withoutProtocol';
    } else {
      // 无协议前缀，统一使用HTTPS
      baseUrl = 'https://$domain';
    }

    final withoutProtocol = baseUrl.replaceFirst('https://', '');
    if (_isIpWithPort(withoutProtocol)) {
      XBoardLogger.info('[域名竞速] IP+端口使用HTTPS+CA证书测试: $baseUrl');
    } else {
      XBoardLogger.info('[域名竞速] 域名使用HTTPS测试: $baseUrl');
    }

    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    if (testPath.isEmpty) {
      // 使用健康检查端点
      return '$baseUrl/api/v1/guest/comm/config';
    } else {
      String path = testPath.startsWith('/') ? testPath : '/$testPath';
      return '$baseUrl$path';
    }
  }

  /// 判断是否为IP+端口格式
  static bool _isIpWithPort(String domain) {
    // 匹配 IP:PORT 格式
    final ipPortPattern = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d+$');
    return ipPortPattern.hasMatch(domain);
  }

  /// 转换域名为HTTPS格式（用于SDK初始化）
  static String _convertToHttpsUrl(String domain) {
    if (domain.startsWith('https://')) {
      return domain;
    } else if (domain.startsWith('http://')) {
      // 如果是HTTP的IP+端口，转换为HTTPS
      final withoutHttp = domain.substring(7); // 移除 "http://"
      return 'https://$withoutHttp';
    } else {
      // 纯域名，添加HTTPS前缀
      return 'https://$domain';
    }
  }

  /// 批量测试所有域名的延迟（不竞速）
  ///
  /// [domains] 要测试的域名列表
  /// [testPath] 用于测试的路径
  ///
  /// 返回所有域名的测试结果
  static Future<List<DomainTestResult>> testAllDomains(
    List<String> domains, {
    String testPath = '',
  }) async {
    if (domains.isEmpty) return [];

    XBoardLogger.info('[域名测试] 开始测试 ${domains.length} 个域名的延迟');

    final List<Future<DomainTestResult>> futures =
        domains.asMap().entries.map((entry) {
      final index = entry.key;
      final domain = entry.value;
      return _testSingleDomain(domain, testPath, CancelToken(), index);
    }).toList();

    final results = await Future.wait(futures);

    // 按响应时间排序
    results.sort((a, b) {
      if (a.success && !b.success) return -1;
      if (!a.success && b.success) return 1;
      if (a.success && b.success) {
        return a.responseTime.compareTo(b.responseTime);
      }
      return 0;
    });

    XBoardLogger.info(
        '[域名测试] 测试完成，成功: ${results.where((r) => r.success).length}/${results.length}');
    return results;
  }
}

/// 域名测试结果
class DomainTestResult {
  final String domain;
  final bool success;
  final int responseTime;
  final String? error;

  const DomainTestResult._({
    required this.domain,
    required this.success,
    required this.responseTime,
    this.error,
  });

  factory DomainTestResult.success(String domain, int responseTime) {
    return DomainTestResult._(
      domain: domain,
      success: true,
      responseTime: responseTime,
    );
  }

  factory DomainTestResult.failure(
      String domain, String error, int responseTime) {
    return DomainTestResult._(
      domain: domain,
      success: false,
      responseTime: responseTime,
      error: error,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'DomainTestResult(domain: $domain, success: $success, responseTime: ${responseTime}ms)';
    } else {
      return 'DomainTestResult(domain: $domain, success: $success, error: $error, responseTime: ${responseTime}ms)';
    }
  }
}

/// Một dòng cache kết quả竞速
class _RaceCacheEntry {
  final String winner;
  final DateTime time;

  const _RaceCacheEntry(this.winner, this.time);
}

/// 取消令牌
class CancelToken {
  bool _isCancelled = false;
  void Function()? _onCancel;

  bool get isCancelled => _isCancelled;

  /// Đăng ký hành động abort (đóng socket) để cancel() dừng request ngay,
  /// thay vì chỉ đánh dấu cờ rồi chờ request chạy hết timeout.
  set onCancel(void Function() callback) {
    if (_isCancelled) {
      callback();
      return;
    }
    _onCancel = callback;
  }

  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    final callback = _onCancel;
    _onCancel = null;
    callback?.call();
  }
}

