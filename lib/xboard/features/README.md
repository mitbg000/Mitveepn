# XBoard Features - 业务功能模块

## 📖 概述

`features` 目录包含 XBoard 的所有业务功能模块，每个模块负责一个独立的业务领域。

## 📂 功能模块

### 🔐 [auth](auth/) - 认证模块

**职责**: 用户认证和账户管理

**功能**:
- ✅ 用户登录
- ✅ 用户注册
- ✅ 忘记密码
- ✅ 验证码发送

**主要页面**:
- `LoginPage` - 登录页面
- `RegisterPage` - 注册页面
- `ForgotPasswordPage` - 忘记密码页面

**使用示例**:
```dart
import 'package:mitveepn/xboard/features/auth/auth.dart';

// 导航到登录页面
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const LoginPage(),
));
```

---

### 📦 [subscription](subscription/) - 订阅模块

**职责**: 订阅管理和使用情况展示

**功能**:
- ✅ 订阅信息展示
- ✅ 使用量统计
- ✅ 到期时间提醒
- ✅ 订阅链接管理
- ✅ 一键连接

**主要页面**:
- `SubscriptionPage` - 订阅管理页面
- `XBoardHomePage` - XBoard 主页

**主要组件**:
- `SubscriptionUsageCard` - 使用量卡片
- `XBoardConnectButton` - 连接按钮
- `SubscriptionStatusDialog` - 状态对话框

**使用示例**:
```dart
import 'package:mitveepn/xboard/features/subscription/subscription.dart';

// 显示订阅页面
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const SubscriptionPage(),
));
```

---

### 💳 [payment](payment/) - 支付模块

**职责**: 套餐购买和支付流程

**功能**:
- ✅ 套餐列表展示
- ✅ 套餐详情查看
- ✅ 订单创建
- ✅ 多种支付方式
- ✅ 支付状态查询
- ✅ 优惠券支持

**主要页面**:
- `PlansPage` - 套餐列表页面
- `PlanPurchasePage` - 套餐购买页面
- `PaymentGatewayPage` - 支付网关页面

**主要组件**:
- `PaymentWaitingOverlay` - 支付等待遮罩
- `PlanDescriptionWidget` - 套餐描述组件

**使用示例**:
```dart
import 'package:mitveepn/xboard/features/payment/payment.dart';

// 显示套餐列表
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const PlansPage(),
));

// 购买套餐
Navigator.push(context, MaterialPageRoute(
  builder: (_) => PlanPurchasePage(plan: selectedPlan),
));
```

---

### 🎁 [invite](invite/) - 邀请佣金模块

**职责**: 邀请码管理和佣金系统

**功能**:
- ✅ 邀请码生成
- ✅ 邀请链接分享
- ✅ 邀请统计展示
- ✅ 佣金余额查看
- ✅ 佣金历史记录
- ✅ 佣金提现
- ✅ 佣金划转

**主要页面**:
- `InvitePage` - 邀请管理页面

**主要组件**:
- `InviteQRCard` - 邀请二维码卡片
- `InviteStatsCard` - 邀请统计卡片
- `WalletDetailsCard` - 钱包详情卡片
- `CommissionHistoryCard` - 佣金历史卡片
- `InviteRulesCard` - 邀请规则卡片

**主要对话框**:
- `WithdrawDialog` - 提现对话框
- `TransferDialog` - 划转对话框
- `CommissionHistoryDialog` - 佣金历史对话框
- `ThemeDialog` - 主题设置对话框

**使用示例**:
```dart
import 'package:mitveepn/xboard/features/invite/invite.dart';

// 显示邀请页面
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const InvitePage(),
));
```

---

### 👤 [profile](profile/) - 个人资料模块

**职责**: 用户资料和配置管理

**功能**:
- ✅ 个人资料查看
- ✅ 配置导入
- ✅ 配置管理

**主要组件**:
- `ProfileImportProgress` - 导入进度组件

---

### 🌐 [domain_status](domain_status/) - 域名状态模块

**职责**: 域名可用性检测和状态展示

**功能**:
- ✅ 域名可用性检测
- ✅ 域名状态指示器

**主要组件**:
- `DomainStatusIndicator` - 域名状态指示器

---

### ⚡ [latency](latency/) - 延迟检测模块

**职责**: 网络延迟检测和展示

**功能**:
- ✅ 网络延迟检测
- ✅ 延迟展示
- ✅ 自动延迟检测

**主要组件**:
- `LatencyIndicator` - 延迟指示器

---

### 💬 [online_support](online_support/) - 在线支持模块

**职责**: 在线客服和工单系统

**功能**:
- ✅ 在线客服
- ✅ 工单系统
- ✅ 帮助文档

---

### 🔄 [remote_task](remote_task/) - 远程任务模块

**职责**: 远程任务执行和管理

**功能**:
- ✅ 远程任务执行
- ✅ 任务状态管理

---

### 🔔 [update_check](update_check/) - 更新检查模块

**职责**: 版本更新检查和提醒

**功能**:
- ✅ 版本检查
- ✅ 更新提醒
- ✅ 更新下载

---

## 🏗️ 模块结构规范

每个 feature 模块遵循统一的结构：

```
feature_name/
├── feature_name.dart      # 模块导出文件（必需）
├── README.md              # 模块文档（推荐）
│
├── pages/                 # UI 页面（必需）
│   ├── page1.dart
│   └── page2.dart
│
├── providers/             # 状态管理（必需）
│   └── feature_provider.dart
│
├── widgets/               # 专用组件（可选）
│   ├── widget1.dart
│   └── widget2.dart
│
├── services/              # 业务逻辑（可选）
│   └── feature_service.dart
│
├── models/                # 数据模型（可选）
│   └── feature_model.dart
│
├── dialogs/               # 对话框（可选）
│   └── feature_dialog.dart
│
└── interfaces/            # 接口定义（可选）
    └── feature_interface.dart
```

## 📝 开发规范

### 1. 导出文件

每个 feature 必须有一个同名的导出文件：

```dart
// auth/auth.dart
export 'pages/login_page.dart';
export 'pages/register_page.dart';
export 'providers/xboard_user_provider.dart';
```

### 2. 命名规范

- **文件名**: 小写下划线 `login_page.dart`
- **类名**: 大驼峰 `LoginPage`
- **Provider**: `FeatureNameProvider` 或 `FeatureNameNotifier`
- **Widget**: `FeatureNameWidget`

### 3. Provider 使用

使用 Riverpod 进行状态管理：

```dart
@riverpod
class UserInfoNotifier extends _$UserInfoNotifier {
  @override
  Future<UserInfo?> build() async {
    return await XBoardDomainService.getUserInfo();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await XBoardDomainService.getUserInfo();
    });
  }
}
```

### 4. 依赖注入

通过 XBoardDomainService 访问 API：

```dart
// ✅ 推荐
final userInfo = await XBoardDomainService.getUserInfo();

// ❌ 避免直接访问 SDK
final sdk = XBoardClient.instance.sdk; // 不要这样
```

## 🎯 功能矩阵

| 功能模块 | 页面 | Provider | Widget | Service | 文档 | 状态 |
|---------|------|----------|--------|---------|------|------|
| auth | ✅ | ✅ | ❌ | ❌ | ⏳ | 稳定 |
| subscription | ✅ | ✅ | ✅ | ✅ | ⏳ | 稳定 |
| payment | ✅ | ✅ | ✅ | ❌ | ⏳ | 稳定 |
| invite | ✅ | ✅ | ✅ | ❌ | ⏳ | 稳定 |
| profile | ❌ | ✅ | ✅ | ✅ | ⏳ | 开发中 |
| system | ✅ | ✅ | ✅ | ✅ | ⏳ | 稳定 |

## 💡 使用建议

### 1. 功能导入

```dart
// 导入整个模块
import 'package:mitveepn/xboard/features/auth/auth.dart';

// 或通过主入口导入
import 'package:mitveepn/xboard/xboard.dart';
```

### 2. 页面导航

```dart
// 使用页面导出
import 'package:mitveepn/xboard/pages/pages.dart';

Navigator.push(context, MaterialPageRoute(
  builder: (_) => const LoginPage(),
));
```

### 3. Provider 使用

```dart
// 使用 Provider 导出
import 'package:mitveepn/xboard/providers/providers.dart';

// 在 Widget 中使用
final userInfo = ref.watch(userInfoNotifierProvider);
```

## 🔄 模块间通信

### 1. 通过 Provider

```dart
// subscription 模块使用 auth 模块的用户信息
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<SubscriptionInfo?> build() async {
    // 依赖用户登录状态
    final isLoggedIn = await ref.watch(authStatusProvider.future);
    if (!isLoggedIn) return null;
    
    return await XBoardDomainService.getSubscription();
  }
}
```

### 2. 通过共享服务

```dart
// 使用 shared 层的服务
import 'package:mitveepn/xboard/shared/shared.dart';

final storageService = StorageService.instance;
await storageService.saveUserToken(token);
```

## 🧪 测试

每个 feature 应包含相应的测试：

```
test/features/
├── auth/
│   ├── login_test.dart
│   └── register_test.dart
├── payment/
│   └── payment_test.dart
└── ...
```

## 📊 开发进度

- ✅ **auth**: 完成
- ✅ **subscription**: 完成
- ✅ **payment**: 完成
- ✅ **invite**: 完成
- 🔄 **profile**: 开发中
- ✅ **system**: 完成

## 🤝 贡献指南

### 添加新 Feature

1. **创建目录结构**
```bash
mkdir -p features/new_feature/{pages,providers,widgets}
```

2. **创建导出文件**
```dart
// features/new_feature/new_feature.dart
export 'pages/new_feature_page.dart';
export 'providers/new_feature_provider.dart';
```

3. **更新主导出**
```dart
// xboard.dart
export 'features/new_feature/new_feature.dart';
```

4. **添加文档**
```markdown
// features/new_feature/README.md
# New Feature
...
```

## 📞 相关文档

- [XBoard 主文档](../README.md)
- [架构设计](../ARCHITECTURE.md)
- [Domain Service](../domain_service/README.md)
- [Config V2](../config_v2/README.md)

---

**维护者**: FlClash Team  
**最后更新**: 2025-10-12

