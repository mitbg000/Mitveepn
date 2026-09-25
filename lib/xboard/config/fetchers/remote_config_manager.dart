import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import '../core/config_settings.dart';
import '../../core/core.dart';

/// 远程配置状态枚举
enum RemoteConfigStatus {
  uninitialized,
  loading,
  success,
  error,
}

/// 配置获取结果
class ConfigResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;
  final String source;
  final RemoteConfigStatus status;
  final DateTime fetchTime;

  const ConfigResult({
    required this.isSuccess,
    this.data,
    this.error,
    required this.source,
    required this.status,
    required this.fetchTime,
  });

  factory ConfigResult.success(T data, String source) {
    return ConfigResult(
      isSuccess: true,
      data: data,
      source: source,
      status: RemoteConfigStatus.success,
      fetchTime: DateTime.now(),
    );
  }

  factory ConfigResult.failure(String error, String source) {
    return ConfigResult(
      isSuccess: false,
      error: error,
      source: source,
      status: RemoteConfigStatus.error,
      fetchTime: DateTime.now(),
    );
  }
}

/// 多配置源结果
class MultiConfigResult {
  /// 重定向配置源结果
  final ConfigResult<Map<String, dynamic>> redirectResult;
  
  /// Gitee配置源结果
  final ConfigResult<Map<String, dynamic>> giteeResult;
  
  const MultiConfigResult({
    required this.redirectResult,
    required this.giteeResult,
  });
  
  /// 是否有任何一个配置源成功
  bool get hasSuccess => redirectResult.isSuccess || giteeResult.isSuccess;
  
  /// 获取第一个成功的配置数据
  Map<String, dynamic>? get firstSuccessfulData {
    if (redirectResult.isSuccess && redirectResult.data != null) {
      return redirectResult.data;
    }
    if (giteeResult.isSuccess && giteeResult.data != null) {
      return giteeResult.data;
    }
    return null;
  }
  
  /// 获取第一个成功的配置源名称
  String? get firstSuccessfulSource {
    if (redirectResult.isSuccess) return redirectResult.source;
    if (giteeResult.isSuccess) return giteeResult.source;
    return null;
  }

  /// 获取第一个成功的结果
  ConfigResult<Map<String, dynamic>>? get firstSuccessful {
    if (redirectResult.isSuccess) return redirectResult;
    if (giteeResult.isSuccess) return giteeResult;
    return null;
  }
  
  @override
  String toString() {
    return 'MultiConfigResult{redirect: ${redirectResult.status}, gitee: ${giteeResult.status}}';
  }
}

/// HTTP客户端抽象接口
abstract class IHttpClient {
  Future<String?> getString(String url, {Duration? timeout});
}

/// 简单的HTTP客户端实现
class SimpleHttpClient implements IHttpClient {
  @override
  Future<String?> getString(String url, {Duration? timeout}) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      client.connectionTimeout = timeout ?? const Duration(seconds: 10);

      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      }

      return null;
    } catch (e) {
      return null;
    } finally {
      client?.close();
    }
  }
}

/// 配置源抽象接口
abstract class ConfigSource {
  String get sourceName;
  int get priority;
  Future<ConfigResult<Map<String, dynamic>>> fetchConfig();
}

/// 重定向配置源实现
class RedirectConfigSource implements ConfigSource {
  final IHttpClient _httpClient;
  final String redirectUrl;
  final Duration timeout;
  @override
  final int priority;

  RedirectConfigSource({
    IHttpClient? httpClient,
    required this.redirectUrl,
    Duration? timeout,
    this.priority = 1,
  }) : _httpClient = httpClient ?? SimpleHttpClient(),
       timeout = timeout ?? const Duration(seconds: 10);

  @override
  String get sourceName => 'redirect';

  @override
  Future<ConfigResult<Map<String, dynamic>>> fetchConfig() async {
    try {
      NetworkLogger.info('开始获取重定向配置源: $redirectUrl');
      final rawData = await _httpClient.getString(redirectUrl, timeout: timeout);

      if (rawData == null || rawData.trim().isEmpty) {
        NetworkLogger.error('重定向配置源获取失败: 数据为空');
        return ConfigResult.failure("重定向配置源获取失败", sourceName);
      }

      final jsonData = json.decode(rawData.trim()) as Map<String, dynamic>;
      NetworkLogger.info('重定向配置源获取成功');
      return ConfigResult.success(jsonData, sourceName);

    } catch (e) {
      NetworkLogger.error('重定向配置源异常', e);
      return ConfigResult.failure("重定向配置源异常: ${e.toString()}", sourceName);
    }
  }
}

/// Gitee配置源实现
class GiteeConfigSource implements ConfigSource {
  final IHttpClient _httpClient;
  final String giteeUrl;
  final String encryptionKeyBase64;
  final Duration timeout;
  @override
  final int priority;

  GiteeConfigSource({
    IHttpClient? httpClient,
    required this.giteeUrl,
    required this.encryptionKeyBase64,
    Duration? timeout,
    this.priority = 2,
  }) : _httpClient = httpClient ?? SimpleHttpClient(),
       timeout = timeout ?? const Duration(seconds: 10);

  @override
  String get sourceName => 'gitee';

  @override
  Future<ConfigResult<Map<String, dynamic>>> fetchConfig() async {
    try {
      final encryptedData = await _httpClient.getString(giteeUrl, timeout: timeout);

      if (encryptedData == null) {
        return ConfigResult.failure("Gitee配置源获取失败", sourceName);
      }

      final decryptedConfig = await _decryptConfigData(encryptedData.trim());

      if (decryptedConfig == null) {
        return ConfigResult.failure("Gitee配置源解密失败", sourceName);
      }

      return ConfigResult.success(decryptedConfig, sourceName);

    } catch (e) {
      return ConfigResult.failure("Gitee配置源异常: ${e.toString()}", sourceName);
    }
  }

  /// 解密配置数据（AES-GCM解密）
  Future<Map<String, dynamic>?> _decryptConfigData(String encryptedBase64) async {
    try {
      final encryptedBytes = base64.decode(encryptedBase64);
      final keyBytes = base64.decode(encryptionKeyBase64);

      const nonceLength = 16;
      const tagLength = 16;

      if (encryptedBytes.length < nonceLength + tagLength) {
        throw Exception('加密数据长度不足: ${encryptedBytes.length}');
      }

      final nonce = encryptedBytes.sublist(0, nonceLength);
      final ciphertext = encryptedBytes.sublist(
          nonceLength, encryptedBytes.length - tagLength);
      final tag = encryptedBytes.sublist(encryptedBytes.length - tagLength);

      final key = Key(keyBytes);
      final iv = IV(nonce);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      final encrypted = Encrypted(Uint8List.fromList(ciphertext + tag));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      final jsonData = json.decode(decrypted) as Map<String, dynamic>;
      return jsonData;
    } catch (e) {
      return null;
    }
  }
}

/// 远程配置源（兼容旧接口）
class RemoteConfigSource {
  final String name;
  final String url;
  final Map<String, String>? headers;
  final Duration timeout;

  const RemoteConfigSource({
    required this.name,
    required this.url,
    this.headers,
    this.timeout = const Duration(seconds: 10),
  });

  /// 从配置源获取数据
  Future<ConfigResult<Map<String, dynamic>>> fetch() async {
    try {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      client.connectionTimeout = timeout;

      final uri = Uri.parse(url);
      final request = await client.getUrl(uri);
      
      // 添加请求头
      if (headers != null) {
        headers!.forEach((key, value) {
          request.headers.add(key, value);
        });
      }

      final response = await request.close();
      
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody) as Map<String, dynamic>;
        
        client.close();
        return ConfigResult.success(data, name);
      } else {
        client.close();
        return ConfigResult.failure(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          name,
        );
      }
    } catch (e) {
      return ConfigResult.failure('Network error: $e', name);
    }
  }
}

/// 远程配置管理器
class RemoteConfigManager {
  final List<ConfigSource> _configSources;
  final int _maxRetries;
  final Duration _retryDelay;
  final bool _enableConcurrentFetch;

  RemoteConfigManager({
    List<ConfigSource>? sources,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    bool enableConcurrentFetch = true,
  }) : _configSources = sources ?? _createDefaultSources(),
       _maxRetries = maxRetries,
       _retryDelay = retryDelay,
       _enableConcurrentFetch = enableConcurrentFetch;

  /// 从配置设置创建RemoteConfigManager
  factory RemoteConfigManager.fromSettings(RemoteConfigSettings settings) {
    final sources = <ConfigSource>[];

    for (final sourceConfig in settings.sources) {
      // 如果提供了 encryptionKey，则作为 Gitee 配置源
      if (sourceConfig.encryptionKey != null && sourceConfig.encryptionKey!.isNotEmpty) {
        sources.add(GiteeConfigSource(
          giteeUrl: sourceConfig.url,
          encryptionKeyBase64: sourceConfig.encryptionKey!,
          timeout: sourceConfig.timeout ?? settings.timeout,
          priority: sourceConfig.priority,
        ));
      } else {
        // 否则作为普通 redirect 配置源
        sources.add(RedirectConfigSource(
          redirectUrl: sourceConfig.url,
          timeout: sourceConfig.timeout ?? settings.timeout,
          priority: sourceConfig.priority,
        ));
      }
    }

    return RemoteConfigManager(
      sources: sources,
      maxRetries: settings.maxRetries,
      retryDelay: settings.retryDelay,
    );
  }

  /// 创建默认配置源（空列表，必须从配置文件提供）
  static List<ConfigSource> _createDefaultSources() {
    return [];
  }

  /// 从所有配置源获取配置
  Future<MultiConfigResult> fetchAllConfigs() async {
    if (_configSources.isEmpty) {
      throw Exception('没有可用的配置源');
    }

    // 按类型分组，每组按 priority 从高到低排序，同类型内支持失败后回退到下一个源
    final redirectSources = _configSources.whereType<RedirectConfigSource>().toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    final giteeSources = _configSources.whereType<GiteeConfigSource>().toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    // 并发或串行获取配置
    late ConfigResult<Map<String, dynamic>> redirectResult;
    late ConfigResult<Map<String, dynamic>> giteeResult;

    if (_enableConcurrentFetch && redirectSources.isNotEmpty && giteeSources.isNotEmpty) {
      // 并发请求
      final results = await Future.wait([
        _fetchWithFallback(redirectSources, 'redirect'),
        _fetchWithFallback(giteeSources, 'gitee'),
      ]);
      redirectResult = results[0];
      giteeResult = results[1];
    } else {
      // 串行请求
      redirectResult = redirectSources.isNotEmpty
          ? await _fetchWithFallback(redirectSources, 'redirect')
          : ConfigResult.failure('重定向配置源未注册', 'redirect');

      giteeResult = giteeSources.isNotEmpty
          ? await _fetchWithFallback(giteeSources, 'gitee')
          : ConfigResult.failure('Gitee配置源未注册', 'gitee');
    }

    return MultiConfigResult(
      redirectResult: redirectResult,
      giteeResult: giteeResult,
    );
  }

  /// 依次尝试同类型的配置源（按 priority 高到低），第一个成功即返回；
  /// 全部失败则返回最后一个源的失败结果
  Future<ConfigResult<Map<String, dynamic>>> _fetchWithFallback(
    List<ConfigSource> sources,
    String groupName,
  ) async {
    ConfigResult<Map<String, dynamic>>? lastResult;

    for (final source in sources) {
      lastResult = await _fetchWithRetry(source);
      if (lastResult.isSuccess) {
        return lastResult;
      }
    }

    return lastResult ?? ConfigResult.failure('$groupName 配置源未注册', groupName);
  }

  /// 只获取重定向配置源的结果（按 priority 从高到低依次尝试，失败则回退到下一个）
  Future<ConfigResult<Map<String, dynamic>>> getRedirectConfig() async {
    final redirectSources = _configSources.whereType<RedirectConfigSource>().toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    if (redirectSources.isEmpty) {
      throw Exception('重定向配置源未注册');
    }
    return await _fetchWithFallback(redirectSources, 'redirect');
  }

  /// 只获取Gitee配置源的结果（按 priority 从高到低依次尝试，失败则回退到下一个）
  Future<ConfigResult<Map<String, dynamic>>> getGiteeConfig() async {
    final giteeSources = _configSources.whereType<GiteeConfigSource>().toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    if (giteeSources.isEmpty) {
      throw Exception('Gitee配置源未注册');
    }
    return await _fetchWithFallback(giteeSources, 'gitee');
  }

  /// 从指定配置源获取配置
  Future<ConfigResult<Map<String, dynamic>>> fetchFromSource(String sourceName) async {
    final source = _configSources.firstWhere(
      (s) => s.sourceName == sourceName,
      orElse: () => throw ArgumentError('Unknown source: $sourceName'),
    );
    
    return await _fetchWithRetry(source);
  }

  /// 获取第一个可用的配置
  Future<ConfigResult<Map<String, dynamic>>> fetchConfig() async {
    final multiResult = await fetchAllConfigs();
    
    if (multiResult.hasSuccess) {
      return multiResult.firstSuccessful!;
    } else {
      return ConfigResult.failure(
        'All config sources failed',
        'all',
      );
    }
  }

  /// 带重试的获取
  Future<ConfigResult<Map<String, dynamic>>> _fetchWithRetry(ConfigSource source) async {
    ConfigResult<Map<String, dynamic>>? lastResult;
    
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      lastResult = await source.fetchConfig();
      
      if (lastResult.isSuccess) {
        return lastResult;
      }
      
      // 如果不是最后一次尝试，等待后重试
      if (attempt < _maxRetries) {
        await Future.delayed(_retryDelay);
      }
    }
    
    return lastResult!;
  }

  /// 添加配置源
  void addSource(ConfigSource source) {
    _configSources.add(source);
  }

  /// 移除配置源
  void removeSource(String sourceName) {
    _configSources.removeWhere((source) => source.sourceName == sourceName);
  }

  /// 获取所有配置源名称
  List<String> get sourceNames => _configSources.map((s) => s.sourceName).toList();

  /// 获取配置源数量
  int get sourceCount => _configSources.length;
}