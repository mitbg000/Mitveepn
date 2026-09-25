// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static String m0(url) => "Không thể mở liên kết: ${url}";

  static String m1(rate) => "Tỷ lệ hoa hồng hiện tại: ${rate}%";

  static String m2(label) =>
      "Bạn có chắc chắn muốn xóa ${label} đã chọn không?";

  static String m3(label) =>
      "Bạn có chắc chắn muốn xóa ${label} hiện tại không?";

  static String m4(label) => "${label} không được để trống";

  static String m5(label) => "${label} hiện tại đã tồn tại";

  static String m6(error) => "Đăng xuất không thành công: ${error}";

  static String m7(amount) => "Có thể chuyển nhượng tối đa: ¥${amount}";

  static String m8(label) => "Hiện tại không có ${label}";

  static String m9(label) => "${label} phải là một số";

  static String m10(statusCode) => "Không nhận được tin nhắn: ${statusCode}";

  static String m11(error) => "Không chọn được hình ảnh: ${error}";

  static String m12(method) => "Phương pháp HTTP không được hỗ trợ: ${method}";

  static String m13(error) => "Tải lên không thành công: ${error}";

  static String m14(amount) => "Số tiền đặt hàng: ${amount}";

  static String m15(orderNo) => "Đặt hàng: ${orderNo}";

  static String m16(page) => "Trang ${page}";

  static String m17(label) =>
      "${label} phải nằm trong khoảng từ 1024 đến 49151";

  static String m18(e) => "Đăng ký không thành công: ${e}";

  static String m19(count) => "Các mục ${count} đã được chọn";

  static String m20(e) => "Không gửi được mã xác minh: ${e}";

  static String m21(date) =>
      "Gói ${date} đã hết hạn, vui lòng gia hạn để tiếp tục sử dụng";

  static String m22(days) =>
      "Gói sẽ hết hạn sau ${days} ngày, vui lòng gia hạn kịp thời";

  static String m23(days) => "Đăng ký sẽ hết hạn sau ${days} ngày";

  static String m24(count) => "Tổng số bản ghi ${count}";

  static String m25(amount) => "Số tiền chuyển không được vượt quá ¥${amount}";

  static String m26(error) => "Chuyển không thành công: ${error}";

  static String m27(amount) =>
      "Chuyển giao thành công! Đã chuyển ¥${amount} vào ví";

  static String m28(version) => "Phiên bản hiện tại: ${version}";

  static String m29(version) => "Buộc cập nhật: ${version}";

  static String m30(version) => "Đã tìm thấy phiên bản mới: ${version}";

  static String m31(statusCode) =>
      "Máy chủ trả về mã trạng thái lỗi ${statusCode}";

  static String m32(label) => "${label} phải là url";

  static String m33(email) =>
      "Mã xác minh đã được gửi tới ${email}, vui lòng kiểm tra và nhập mã xác minh và mật khẩu mới";

  static String m34(amount) => "Số tiền có thể rút: ${amount}";

  static String m35(error) => "Không tải được cấu hình: ${error}";

  static String m36(error) => "Không mở được trang thanh toán: ${error}";

  static String m37(time) => "Thời gian chạy: ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Giới thiệu"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Kiểm soát truy cập"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉ cho phép app đã chọn nhập VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Cấu hình ứng dụng đi qua Proxy",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Ứng dụng đã chọn sẽ bị loại khỏi VPN",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Tài khoản"),
    "action": MessageLookupByLibrary.simpleMessage("Hoạt động"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Chuyển đổi chế độ"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("Hệ thống proxy"),
    "action_start": MessageLookupByLibrary.simpleMessage("Bắt đầu/Dừng"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Hiển thị/Ẩn"),
    "add": MessageLookupByLibrary.simpleMessage("Thêm"),
    "addRule": MessageLookupByLibrary.simpleMessage("Thêm quy tắc"),
    "addSubscription": MessageLookupByLibrary.simpleMessage(
      "Thêm subscription",
    ),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Đính kèm theo quy định ban đầu",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "Địa chỉ máy chủ WebDAV",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ WebDAV hợp lệ",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Quản trị viên tự động khởi chạy",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Khởi động bằng cách sử dụng chế độ quản trị viên",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" trước"),
    "agree": MessageLookupByLibrary.simpleMessage("Đồng ý"),
    "allApps": MessageLookupByLibrary.simpleMessage("Tất cả ứng dụng"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Cho phép ứng dụng bỏ qua VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Một số ứng dụng có thể bỏ qua VPN khi được bật",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Cho phép LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Cho phép truy cập proxy thông qua LAN",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Đã có tài khoản?",
    ),
    "app": MessageLookupByLibrary.simpleMessage("Ứng dụng"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Kiểm soát truy cập App",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉnh các cài đặt liên quan đến ứng dụng",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Ứng dụng"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi cài đặt liên quan đến ứng dụng",
    ),
    "auto": MessageLookupByLibrary.simpleMessage("Tự động"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Tự động kiểm tra cập nhật",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Tự động kiểm tra các bản cập nhật khi app khởi động",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Tự động đóng kết nối",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Tự động đóng kết nối sau khi thay đổi nút",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Tự động khởi chạy"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Khởi động cùng hệ thống",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("Tự động chạy"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Tự động chạy khi mở ứng dụng",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Hệ thống cài đặt tự động DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Tự động cập nhật"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Khoảng thời gian tự động cập nhật (phút)",
    ),
    "availableCommission": MessageLookupByLibrary.simpleMessage(
      "Hoa hồng có sẵn",
    ),
    "availableDomains": MessageLookupByLibrary.simpleMessage(
      "Tên miền khả dụng",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Quay lại Đăng nhập"),
    "backup": MessageLookupByLibrary.simpleMessage("Sao lưu"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage(
      "Sao lưu và phục hồi",
    ),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Đồng bộ hóa dữ liệu qua WebDAV hoặc tệp",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Sao lưu thành công"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Cấu hình cơ bản"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi cấu hình cơ bản trên toàn cầu",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Liên kết"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage(
      "Chế độ danh sách đen",
    ),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bỏ qua tên miền"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉ có hiệu lực khi hệ thống proxy được kích hoạt",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Bộ đệm bị hỏng. Bạn có muốn xóa nó không?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Hủy"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Hủy bỏ hệ thống lọc app",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("Hủy chọn tất cả"),
    "cannotGetWebUrl": MessageLookupByLibrary.simpleMessage(
      "Không thể lấy web URL, vui lòng liên hệ bộ phận hỗ trợ",
    ),
    "cannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "Không thể mở trình duyệt, vui lòng truy cập web theo cách thủ công",
    ),
    "cannotOpenLink": m0,
    "checkError": MessageLookupByLibrary.simpleMessage("Kiểm tra lỗi"),
    "checkNetwork": MessageLookupByLibrary.simpleMessage(
      "Vui lòng kiểm tra mạng và thử lại",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage(
      "Kiểm tra các bản cập nhật",
    ),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "Ứng dụng hiện tại đã là phiên bản mới nhất",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Đang kiểm tra..."),
    "clearData": MessageLookupByLibrary.simpleMessage("Xóa dữ liệu"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Xuất bảng nhớ tạm",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Nhập bảng nhớ tạm",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Đóng"),
    "color": MessageLookupByLibrary.simpleMessage("Màu sắc"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Phối màu"),
    "columns": MessageLookupByLibrary.simpleMessage("Cột"),
    "commissionHistory": MessageLookupByLibrary.simpleMessage(
      "Lịch sử hoa hồng",
    ),
    "commissionRate": MessageLookupByLibrary.simpleMessage("Tỷ lệ hoa hồng"),
    "commissionSettled": MessageLookupByLibrary.simpleMessage(
      "Hoa hồng được giải quyết sau khi đăng ký kết bạn",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("Chế độ tương thích"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Việc mở nó sẽ mất một phần khả năng ứng dụng và nhận được sự hỗ trợ của toàn bộ số lượng Clash.",
    ),
    "complete": MessageLookupByLibrary.simpleMessage("Hoàn thành"),
    "completeWithdrawal": MessageLookupByLibrary.simpleMessage(
      "Phiên bản Web cung cấp đầy đủ tính năng rút tiền",
    ),
    "configurationError": MessageLookupByLibrary.simpleMessage(
      "Lỗi cấu hình ứng dụng, vui lòng liên hệ hỗ trợ",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Xác nhận"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Xác nhận đăng xuất"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Xác nhận mật khẩu mới",
    ),
    "confirmTransfer": MessageLookupByLibrary.simpleMessage(
      "Xác nhận chuyển khoản",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Kết nối"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Xem dữ liệu kết nối hiện tại",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Kết nối:"),
    "contactMe": MessageLookupByLibrary.simpleMessage("Liên hệ với tôi"),
    "contactSupport": MessageLookupByLibrary.simpleMessage("Liên hệ hỗ trợ"),
    "content": MessageLookupByLibrary.simpleMessage("Nội dung"),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Nội dung"),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Đã sao chép vào bảng nhớ tạm",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Sao chép"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Sao chép các biến môi trường",
    ),
    "copyInviteLink": MessageLookupByLibrary.simpleMessage("Sao chép liên kết"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Sao chép liên kết"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Sao chép thành công"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Thông tin core"),
    "country": MessageLookupByLibrary.simpleMessage("Quốc gia"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Kiểm tra sự cố"),
    "create": MessageLookupByLibrary.simpleMessage("Tạo"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Tạo tài khoản"),
    "credentialsSaved": MessageLookupByLibrary.simpleMessage(
      "Đã lưu thông tin xác thực",
    ),
    "currentCommissionRate": m1,
    "cut": MessageLookupByLibrary.simpleMessage("Cắt"),
    "dark": MessageLookupByLibrary.simpleMessage("Tối"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Bảng điều khiển"),
    "days": MessageLookupByLibrary.simpleMessage("Ngày"),
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Máy chủ tên mặc định",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Để giải quyết máy chủ DNS",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage(
      "Sắp xếp theo mặc định",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("Mặc định"),
    "delay": MessageLookupByLibrary.simpleMessage("Trì hoãn"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Sắp xếp theo độ trễ"),
    "delete": MessageLookupByLibrary.simpleMessage("Xóa"),
    "deleteMultipTip": m2,
    "deleteTip": m3,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Ứng dụng khách proxy đa nền tảng dựa trên ClashMeta, đơn giản và dễ sử dụng, mã nguồn mở và không có quảng cáo.",
    ),
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Dựa vào api của bên thứ ba chỉ mang tính chất tham khảo",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage(
      "Chế độ nhà phát triển",
    ),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Chế độ nhà phát triển được bật.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Trực tiếp"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Thông báo quan trọng"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Phần mềm này hiện đang ở phiên bản beta công khai. Nếu bạn nhận được lời nhắc cập nhật, vui lòng cập nhật kịp thời. Các phiên bản cũ hơn có thể gây mất ổn định dịch vụ hoặc không thể sử dụng.",
    ),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Khám phá phiên bản mới",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage("Khám phá phiên bản mới"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Cập nhật cài đặt liên quan đến DNS",
    ),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Chế độ DNS"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Bạn có muốn tiếp tục",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Tên miền"),
    "domainNotReadyTryAgain": MessageLookupByLibrary.simpleMessage(
      "Tên miền chưa sẵn sàng, vui lòng thử lại",
    ),
    "domainStatusAvailable": MessageLookupByLibrary.simpleMessage(
      "Dịch vụ khả dụng",
    ),
    "domainStatusChecking": MessageLookupByLibrary.simpleMessage(
      "Đang kiểm tra...",
    ),
    "domainStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Trạng thái tên miền",
    ),
    "domainStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "Dịch vụ không khả dụng",
    ),
    "download": MessageLookupByLibrary.simpleMessage("Tải xuống"),
    "edit": MessageLookupByLibrary.simpleMessage("Sửa"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Địa chỉ email"),
    "emailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Mã xác minh email",
    ),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("Tiếng Anh"),
    "enableOverride": MessageLookupByLibrary.simpleMessage("Bật ghi đè"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email của bạn và chúng tôi sẽ gửi mã xác minh đến email của bạn",
    ),
    "enterTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Nhập số tiền chuyển",
    ),
    "enterTransferAmountError": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập số tiền chuyển",
    ),
    "entries": MessageLookupByLibrary.simpleMessage("mục"),
    "errorMessage": MessageLookupByLibrary.simpleMessage("Thông báo lỗi"),
    "exclude": MessageLookupByLibrary.simpleMessage(
      "Ẩn khỏi các nhiệm vụ gần đây",
    ),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "Khi app ở chế độ nền, app bị ẩn khỏi tác vụ gần đây",
    ),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("Thoát"),
    "expand": MessageLookupByLibrary.simpleMessage("Mở rộng"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Thời gian hết hạn"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Xuất tập tin"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Xuất nhật ký"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Xuất thành công"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("biểu cảm"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "External Controller",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Sau khi được bật, kernel Clash có thể được điều khiển trên cổng 9090",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("Liên kết ngoài"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "Tài nguyên bên ngoài",
    ),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Bộ lọc giả mạo"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Phạm vi Fakeip"),
    "fallback": MessageLookupByLibrary.simpleMessage("Dự phòng"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Nói chung sử dụng DNS ngoài khơi",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Bộ lọc dự phòng"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Độ trung thực"),
    "file": MessageLookupByLibrary.simpleMessage("Tệp"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Trực tiếp tải lên hồ sơ"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Tập tin đã được sửa đổi. Bạn có muốn lưu các thay đổi?",
    ),
    "fillInfoToRegister": MessageLookupByLibrary.simpleMessage(
      "Vui lòng điền các thông tin sau để hoàn tất đăng ký",
    ),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage("Hệ thống lọc app"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Tìm process"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "Có sự giảm hiệu suất nhất định sau khi mở",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Họ font"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Quên mật khẩu"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Bốn cột"),
    "friendInviteReward": MessageLookupByLibrary.simpleMessage(
      "Kiếm tiền hoa hồng khi bạn bè được bạn mời chi tiêu",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("Salad trái cây"),
    "general": MessageLookupByLibrary.simpleMessage("Chung"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi cài đặt chung",
    ),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage(
      "Đang tạo mã mời...",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("GeoData"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Chế độ Geo tiết kiệm bộ nhớ",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Việc kích hoạt sẽ sử dụng trình tải bộ nhớ thấp Geo",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Mã Geoip"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Nhận quy tắc ban đầu",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Toàn cục"),
    "go": MessageLookupByLibrary.simpleMessage("Đi"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Tải xuống"),
    "goToWeb": MessageLookupByLibrary.simpleMessage("Đi tới Web"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Bạn có muốn lưu vào bộ nhớ đệm những thay đổi không?",
    ),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Thêm host"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage(
      "Xung đột phím nóng",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Quản lý phím nóng",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Sử dụng bàn phím để điều khiển ứng dụng",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("Giờ"),
    "iUnderstand": MessageLookupByLibrary.simpleMessage("Tôi hiểu"),
    "icon": MessageLookupByLibrary.simpleMessage("Biểu tượng"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Cấu hình biểu tượng",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Kiểu biểu tượng"),
    "import": MessageLookupByLibrary.simpleMessage("Nhập khẩu"),
    "importFile": MessageLookupByLibrary.simpleMessage("Nhập từ tập tin"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Nhập từ URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Nhập từ URL"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Hiệu quả lâu dài"),
    "init": MessageLookupByLibrary.simpleMessage("Khởi tạo"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập đúng phím nóng",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Lựa chọn thông minh",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Khoảng thời gian"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("IP mạng nội bộ"),
    "invalidTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập số tiền chuyển hợp lệ",
    ),
    "invite": MessageLookupByLibrary.simpleMessage("Mời"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("Mã mời"),
    "inviteCodeGenFailed": MessageLookupByLibrary.simpleMessage(
      "Tạo mã mời không thành công",
    ),
    "inviteCodeOptional": MessageLookupByLibrary.simpleMessage(
      "Mã mời (tùy chọn)",
    ),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Yêu cầu mã mời",
    ),
    "inviteCodeRequiredMessage": MessageLookupByLibrary.simpleMessage(
      "Đăng ký yêu cầu mã mời. Vui lòng liên hệ với người dùng đã đăng ký để nhận mã mời trước khi đăng ký.",
    ),
    "inviteLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Đã sao chép liên kết mời, chia sẻ với bạn bè",
    ),
    "inviteRegisterReward": MessageLookupByLibrary.simpleMessage(
      "Mời bạn bè đăng ký và đăng ký để kiếm tiền hoa hồng",
    ),
    "inviteRules": MessageLookupByLibrary.simpleMessage("Quy tắc mời"),
    "inviteStats": MessageLookupByLibrary.simpleMessage("Thống kê mời"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("ipcidr"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "Khi bật nó sẽ có thể nhận được lưu lượng IPv6",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Cho phép IPv6 gửi đến",
    ),
    "just": MessageLookupByLibrary.simpleMessage("Vừa xong"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Tcp duy trì khoảng thời gian tồn tại",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Khóa"),
    "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
    "lastChecked": MessageLookupByLibrary.simpleMessage("Đã kiểm tra lần cuối"),
    "layout": MessageLookupByLibrary.simpleMessage("Cách trình bày"),
    "light": MessageLookupByLibrary.simpleMessage("Sáng"),
    "list": MessageLookupByLibrary.simpleMessage("Danh sách"),
    "listen": MessageLookupByLibrary.simpleMessage("Nghe"),
    "loadMore": MessageLookupByLibrary.simpleMessage("Tải thêm"),
    "loading": MessageLookupByLibrary.simpleMessage("Đang tải..."),
    "local": MessageLookupByLibrary.simpleMessage("Cục bộ"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Sao lưu dữ liệu cục bộ vào cục bộ",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Khôi phục dữ liệu từ tập tin",
    ),
    "logLevel": MessageLookupByLibrary.simpleMessage("Cấp độ nhật ký"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Việc tắt sẽ ẩn mục nhật ký",
    ),
    "loggedOutSuccess": MessageLookupByLibrary.simpleMessage(
      "Đăng xuất thành công",
    ),
    "loginNow": MessageLookupByLibrary.simpleMessage("Đăng nhập ngay"),
    "logout": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "logoutConfirmMsg": MessageLookupByLibrary.simpleMessage(
      "Bạn có chắc chắn đăng xuất không? Bạn cần phải đăng nhập lại.",
    ),
    "logoutFailed": m6,
    "logs": MessageLookupByLibrary.simpleMessage("Nhật ký"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Bản ghi nhật ký"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Kiểm tra nhật ký"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Công cụ mở khóa vòng lặp",
    ),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Được sử dụng để mở khóa loopback UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Lỏng lẻo"),
    "maxTransferable": m7,
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Thông tin bộ nhớ"),
    "messageTest": MessageLookupByLibrary.simpleMessage("Kiểm tra tin nhắn"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "Đây là một tin nhắn.",
    ),
    "min": MessageLookupByLibrary.simpleMessage("tối thiểu"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Thu nhỏ khi thoát"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi sự kiện thoát hệ thống mặc định",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Phút"),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Cảng hỗn hợp"),
    "mode": MessageLookupByLibrary.simpleMessage("Chế độ"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Đơn sắc"),
    "months": MessageLookupByLibrary.simpleMessage("Tháng"),
    "more": MessageLookupByLibrary.simpleMessage("Thêm"),
    "myInviteQr": MessageLookupByLibrary.simpleMessage("Lời mời QR của tôi"),
    "name": MessageLookupByLibrary.simpleMessage("Tên"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Sắp xếp theo tên"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Máy chủ tên"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage("Để phân giải miền"),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Chính sách máy chủ tên",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉ định chính sách máy chủ tên tương ứng",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Mạng"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi cài đặt liên quan đến mạng",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage("Kiểm tra mạng"),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Tốc độ mạng"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Trung lập"),
    "newMessageFromSupport": MessageLookupByLibrary.simpleMessage(
      "Tin nhắn mới từ bộ phận hỗ trợ",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("Mật khẩu mới"),
    "noCommissionRecord": MessageLookupByLibrary.simpleMessage(
      "Không có hồ sơ hoa hồng",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("Không có dữ liệu"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("Không có phím nóng"),
    "noIcon": MessageLookupByLibrary.simpleMessage("Không có"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Không có thông tin"),
    "noInvitationData": MessageLookupByLibrary.simpleMessage(
      "Không có dữ liệu lời mời",
    ),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Không có thêm thông tin",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Không có mạng"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Không có mạng APP"),
    "noProxy": MessageLookupByLibrary.simpleMessage("Chưa có Proxy"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Vui lòng tạo hoặc thêm cấu hình hợp lệ",
    ),
    "noResolve": MessageLookupByLibrary.simpleMessage(
      "Không giải quyết được IP",
    ),
    "none": MessageLookupByLibrary.simpleMessage("không có"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Không thể chọn nhóm proxy hiện tại.",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Chưa có cấu hình, vui lòng thêm cấu hình",
    ),
    "nullTip": m8,
    "numberTip": m9,
    "oneColumn": MessageLookupByLibrary.simpleMessage("Một cột"),
    "onlineSupport": MessageLookupByLibrary.simpleMessage("Hỗ trợ trực tuyến"),
    "onlineSupportAddMore": MessageLookupByLibrary.simpleMessage(
      "Thêm nhiều hơn nữa",
    ),
    "onlineSupportApiConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy cấu hình API hỗ trợ trực tuyến, vui lòng kiểm tra cấu hình",
    ),
    "onlineSupportCancel": MessageLookupByLibrary.simpleMessage("Hủy bỏ"),
    "onlineSupportClearHistory": MessageLookupByLibrary.simpleMessage(
      "Xóa lịch sử",
    ),
    "onlineSupportClearHistoryConfirm": MessageLookupByLibrary.simpleMessage(
      "Bạn có chắc chắn muốn xóa tất cả lịch sử trò chuyện không? Không thể hoàn tác hành động này.",
    ),
    "onlineSupportClickToSelect": MessageLookupByLibrary.simpleMessage(
      "Click để chọn hình ảnh",
    ),
    "onlineSupportConfirm": MessageLookupByLibrary.simpleMessage("Xác nhận"),
    "onlineSupportConnected": MessageLookupByLibrary.simpleMessage(
      "Đã kết nối thành công với hệ thống hỗ trợ",
    ),
    "onlineSupportConnecting": MessageLookupByLibrary.simpleMessage(
      "Đang kết nối...",
    ),
    "onlineSupportConnectionError": MessageLookupByLibrary.simpleMessage(
      "Lỗi kết nối",
    ),
    "onlineSupportDisconnected": MessageLookupByLibrary.simpleMessage(
      "Đã ngắt kết nối",
    ),
    "onlineSupportGetMessagesFailed": m10,
    "onlineSupportInputHint": MessageLookupByLibrary.simpleMessage(
      "Hãy nhập câu hỏi của bạn...",
    ),
    "onlineSupportNoMessages": MessageLookupByLibrary.simpleMessage(
      "Chưa có tin nhắn, gửi tin nhắn để bắt đầu tư vấn",
    ),
    "onlineSupportSelectImages": MessageLookupByLibrary.simpleMessage(
      "Chọn hình ảnh",
    ),
    "onlineSupportSelectImagesFailed": m11,
    "onlineSupportSend": MessageLookupByLibrary.simpleMessage("Gửi"),
    "onlineSupportSendImage": MessageLookupByLibrary.simpleMessage(
      "Gửi hình ảnh",
    ),
    "onlineSupportSendMessageFailed": MessageLookupByLibrary.simpleMessage(
      "Không gửi được tin nhắn: Không thể xác thực token",
    ),
    "onlineSupportSupportedFormats": MessageLookupByLibrary.simpleMessage(
      "Hỗ trợ JPG, PNG, GIF, WebP, BMP\nTối đa 10MB",
    ),
    "onlineSupportTitle": MessageLookupByLibrary.simpleMessage(
      "Hỗ trợ trực tuyến",
    ),
    "onlineSupportTokenNotFound": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy xác thực token",
    ),
    "onlineSupportUnsupportedHttpMethod": m12,
    "onlineSupportUploadFailed": m13,
    "onlineSupportWebSocketConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy cấu hình WebSocket hỗ trợ trực tuyến, vui lòng kiểm tra cấu hình",
    ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Biểu tượng"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Chỉ các ứng dụng của bên thứ ba",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Chỉ thống kê proxy",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Khi bật chỉ thống kê lưu lượng proxy",
    ),
    "openWebFailed": MessageLookupByLibrary.simpleMessage(
      "Không mở được web, vui lòng truy cập thủ công",
    ),
    "options": MessageLookupByLibrary.simpleMessage("Tùy chọn"),
    "orderAmount": m14,
    "orderNumber": m15,
    "other": MessageLookupByLibrary.simpleMessage("Khác"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Những người đóng góp khác",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Chế độ outbound"),
    "override": MessageLookupByLibrary.simpleMessage("Ghi đè"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Ghi đè cấu hình liên quan đến Proxy",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Ghi đè Dns"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Bật nó lên sẽ ghi đè các tùy chọn DNS trong hồ sơ",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Không có hiệu lực ở chế độ tập lệnh",
    ),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Ghi đè quy tắc ban đầu",
    ),
    "pageNumber": m16,
    "palette": MessageLookupByLibrary.simpleMessage("Bảng màu"),
    "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
    "passwordMin8Chars": MessageLookupByLibrary.simpleMessage(
      "Mật khẩu phải có ít nhất 8 ký tự",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Mật khẩu phải có ít nhất 6 ký tự",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "Mật khẩu không khớp",
    ),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "Đặt lại mật khẩu không thành công",
    ),
    "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
      "Đặt lại mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới của bạn",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Mật khẩu không khớp",
    ),
    "paste": MessageLookupByLibrary.simpleMessage("Dán"),
    "pendingCommission": MessageLookupByLibrary.simpleMessage(
      "Hoa hồng đang chờ xử lý",
    ),
    "plans": MessageLookupByLibrary.simpleMessage("Gói cước"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Vui lòng liên kết WebDAV",
    ),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập lại mật khẩu mới",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng xác nhận mật khẩu",
    ),
    "pleaseEnterAtLeast8CharsPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mật khẩu ít nhất 8 ký tự",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email",
    ),
    "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email",
    ),
    "pleaseEnterEmailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mã xác minh email",
    ),
    "pleaseEnterInviteCode": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mã mời",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mật khẩu mới",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mật khẩu",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập tên tập lệnh",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email hợp lệ",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email hợp lệ",
    ),
    "pleaseEnterValidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mã xác minh hợp lệ",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mã xác minh email",
    ),
    "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập địa chỉ email của bạn",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập mật khẩu quản trị viên",
    ),
    "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập lại mật khẩu",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Vui lòng tải tập tin lên",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Vui lòng tải lên mã QR hợp lệ",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Cảng"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập một cổng khác",
    ),
    "portTip": m17,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Ưu tiên sử dụng http/3 của DOH",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("Hãy nhấn bàn phím."),
    "preview": MessageLookupByLibrary.simpleMessage("Xem trước"),
    "profile": MessageLookupByLibrary.simpleMessage("Hồ sơ"),
    "profileAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Đã thêm cấu hình thành công",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Vui lòng nhập định dạng khoảng thời gian hợp lệ",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Vui lòng nhập khoảng thời gian cập nhật tự động",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Hồ sơ đã được sửa đổi. Bạn có muốn tắt tính năng tự động cập nhật không?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập tên hồ sơ",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "lỗi phân tích hồ sơ",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập URL cấu hình hợp lệ",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập URL của cấu hình",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Hồ sơ"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Sắp xếp hồ sơ"),
    "project": MessageLookupByLibrary.simpleMessage("Dự án"),
    "providers": MessageLookupByLibrary.simpleMessage("Nhà cung cấp"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxy"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Cài đặt proxy"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Nhóm Proxy"),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage(
      "Máy chủ tên Proxy",
    ),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Miền để phân giải các nút proxy",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("Cổng proxy"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Đặt cổng nghe Clash",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage(
      "Nhà cung cấp Proxy",
    ),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage(
      "Chế độ màu đen thuần túy",
    ),
    "qrcode": MessageLookupByLibrary.simpleMessage("Mã QR"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Quét mã QR để lấy hồ sơ",
    ),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("cầu vồng"),
    "recovery": MessageLookupByLibrary.simpleMessage("Khôi phục"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage(
      "Khôi phục toàn bộ dữ liệu",
    ),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage(
      "Chỉ hồ sơ khôi phục",
    ),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage(
      "Chiến lược phục hồi",
    ),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Tương thích",
    ),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage("ghi đè"),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage(
      "Khôi phục thành công",
    ),
    "redirPort": MessageLookupByLibrary.simpleMessage("Cổng Redir"),
    "redo": MessageLookupByLibrary.simpleMessage("làm lại"),
    "refresh": MessageLookupByLibrary.simpleMessage("Làm cho khỏe lại"),
    "regExp": MessageLookupByLibrary.simpleMessage("RegExp"),
    "registerAccount": MessageLookupByLibrary.simpleMessage(
      "Đăng ký tài khoản",
    ),
    "registerSuccessSaveCredentials": MessageLookupByLibrary.simpleMessage(
      "Đăng ký thành công - Lưu thông tin đăng nhập:",
    ),
    "registrationFailed": m18,
    "rememberPassword": MessageLookupByLibrary.simpleMessage(
      "Ghi nhớ mật khẩu của bạn?",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Từ xa"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Sao lưu dữ liệu cục bộ vào WebDAV",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Khôi phục dữ liệu từ WebDAV",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Xóa"),
    "rename": MessageLookupByLibrary.simpleMessage("Đổi tên"),
    "requests": MessageLookupByLibrary.simpleMessage("Yêu cầu"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "Xem hồ sơ yêu cầu gần đây",
    ),
    "resendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Gửi lại mã xác minh",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Đặt lại"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Đặt lại mật khẩu"),
    "resetTip": MessageLookupByLibrary.simpleMessage("Đảm bảo thiết lập lại"),
    "resources": MessageLookupByLibrary.simpleMessage("Tài nguyên"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "Thông tin liên quan đến nguồn lực bên ngoài",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Tôn trọng quy tắc"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Kết nối DNS tuân theo các quy tắc, cần định cấu hình proxy-server-nameserver",
    ),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Địa chỉ tuyến đường"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Cấu hình địa chỉ tuyến nghe",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Chế độ định tuyến"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bỏ qua địa chỉ tuyến đường riêng",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage(
      "Sử dụng cấu hình",
    ),
    "rule": MessageLookupByLibrary.simpleMessage("Quy tắc"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Tên quy tắc"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage(
      "Nhà cung cấp quy tắc",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Mục tiêu quy tắc"),
    "save": MessageLookupByLibrary.simpleMessage("Lưu"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "Bạn có muốn lưu các thay đổi?",
    ),
    "saveQr": MessageLookupByLibrary.simpleMessage("Lưu QR"),
    "saveQrCodeFeature": MessageLookupByLibrary.simpleMessage(
      "Lưu tính năng QR sắp ra mắt",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Bạn có chắc chắn muốn lưu không?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Kịch bản"),
    "search": MessageLookupByLibrary.simpleMessage("Tìm kiếm"),
    "seconds": MessageLookupByLibrary.simpleMessage("Giây"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Chọn tất cả"),
    "selectTheme": MessageLookupByLibrary.simpleMessage("Chọn chủ đề"),
    "selected": MessageLookupByLibrary.simpleMessage("Đã chọn"),
    "selectedCountTitle": m19,
    "sendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Không gửi được mã xác minh",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Gửi mã xác minh",
    ),
    "sendVerificationCodeFailed": m20,
    "setNewPassword": MessageLookupByLibrary.simpleMessage("Đặt mật khẩu mới"),
    "settings": MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "show": MessageLookupByLibrary.simpleMessage("Hiển thị"),
    "shrink": MessageLookupByLibrary.simpleMessage("Thu nhỏ"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Khởi động ẩn"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Khởi động chạy nền",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Kích cỡ"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Cổng Socks"),
    "sort": MessageLookupByLibrary.simpleMessage("Sắp xếp"),
    "source": MessageLookupByLibrary.simpleMessage("Nguồn"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Nguồn IP"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Chế độ xếp chồng"),
    "standard": MessageLookupByLibrary.simpleMessage("Tiêu chuẩn"),
    "start": MessageLookupByLibrary.simpleMessage("Bắt đầu"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Đang khởi động VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Trạng thái"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "Hệ thống DNS sẽ được sử dụng khi tắt",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Dừng lại"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Đang dừng VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("Phong cách"),
    "subRule": MessageLookupByLibrary.simpleMessage("Quy tắc phụ"),
    "submit": MessageLookupByLibrary.simpleMessage("Gửi"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Subscription đã hết hạn",
    ),
    "subscriptionExpiredDetail": m21,
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "Đăng ký hết hạn vào ngày hôm nay",
    ),
    "subscriptionExpiresTodayDetail": MessageLookupByLibrary.simpleMessage(
      "Gói cước sẽ hết hạn trong ngày hôm nay, vui lòng gia hạn ngay để tránh gián đoạn dịch vụ",
    ),
    "subscriptionExpiringInDays": MessageLookupByLibrary.simpleMessage(
      "Đăng ký sắp hết hạn",
    ),
    "subscriptionExpiringInDaysDetail": m22,
    "subscriptionNoSubscription": MessageLookupByLibrary.simpleMessage(
      "Chưa có subscription",
    ),
    "subscriptionNoSubscriptionDetail": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy gói đăng ký nào, vui lòng mua gói để sử dụng",
    ),
    "subscriptionNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Chưa đăng nhập",
    ),
    "subscriptionNotLoggedInDetail": MessageLookupByLibrary.simpleMessage(
      "Vui lòng đăng nhập trước",
    ),
    "subscriptionTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Đã hết lưu lượng",
    ),
    "subscriptionTrafficExhaustedDetail": MessageLookupByLibrary.simpleMessage(
      "Lưu lượng kế hoạch đã được sử dụng hết, vui lòng mua thêm lưu lượng hoặc nâng cấp gói",
    ),
    "subscriptionValid": MessageLookupByLibrary.simpleMessage(
      "Subscription còn hiệu lực",
    ),
    "subscriptionValidDetail": m23,
    "switchTheme": MessageLookupByLibrary.simpleMessage("Chuyển đổi chủ đề"),
    "sync": MessageLookupByLibrary.simpleMessage("Đồng bộ hóa"),
    "system": MessageLookupByLibrary.simpleMessage("Hệ thống"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Hệ thống APP"),
    "systemFont": MessageLookupByLibrary.simpleMessage("Phông chữ hệ thống"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Proxy hệ thống"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Đính kèm HTTP proxy vào VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Thẻ"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Hoạt ảnh tab"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉ có hiệu lực ở chế độ xem trên thiết bị di động",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP đồng thời"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Kích hoạt nó sẽ cho phép đồng thời TCP",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("URL kiểm tra"),
    "textScale": MessageLookupByLibrary.simpleMessage("Chia tỷ lệ văn bản"),
    "theme": MessageLookupByLibrary.simpleMessage("Giao diện"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Màu giao diện"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Đặt chế độ tối, điều chỉnh màu sắc",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Chế độ giao diện"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Ba cột"),
    "tight": MessageLookupByLibrary.simpleMessage("Chặt"),
    "time": MessageLookupByLibrary.simpleMessage("Thời gian"),
    "tip": MessageLookupByLibrary.simpleMessage("Gợi ý"),
    "toggle": MessageLookupByLibrary.simpleMessage("Chuyển đổi"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("ÂmSpot"),
    "tools": MessageLookupByLibrary.simpleMessage("Công cụ"),
    "totalCommission": MessageLookupByLibrary.simpleMessage("Tổng hoa hồng"),
    "totalInvites": MessageLookupByLibrary.simpleMessage("Tổng số lời mời"),
    "totalRecords": m24,
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Cổng Tproxy"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage(
      "Mức sử dụng lưu lượng",
    ),
    "transfer": MessageLookupByLibrary.simpleMessage("Chuyển khoản"),
    "transferAmount": MessageLookupByLibrary.simpleMessage("Số tiền chuyển"),
    "transferAmountExceeded": m25,
    "transferFailed": m26,
    "transferNote": MessageLookupByLibrary.simpleMessage(
      "Số dư đã chuyển có thể được sử dụng để mua hàng trong app",
    ),
    "transferSuccess": MessageLookupByLibrary.simpleMessage(
      "Chuyển giao thành công!",
    ),
    "transferSuccessMsg": m27,
    "transferToWallet": MessageLookupByLibrary.simpleMessage("Chuyển vào Ví"),
    "transferring": MessageLookupByLibrary.simpleMessage("Đang chuyển..."),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "Chỉ có hiệu lực khi chạy với quyền quản trị",
    ),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Hai cột"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "không thể cập nhật hồ sơ hiện tại",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("hoàn tác"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Độ trễ thống nhất"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Loại bỏ sự chậm trễ thêm như bắt tay",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Không xác định"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Vô danh"),
    "update": MessageLookupByLibrary.simpleMessage("Cập nhật"),
    "updateCheckAllServersUnavailable": MessageLookupByLibrary.simpleMessage(
      "Tất cả các máy chủ cập nhật được định cấu hình đều không khả dụng",
    ),
    "updateCheckCurrentVersion": m28,
    "updateCheckForceUpdate": m29,
    "updateCheckMustUpdate": MessageLookupByLibrary.simpleMessage(
      "Phải cập nhật",
    ),
    "updateCheckNewVersionFound": m30,
    "updateCheckNoServerUrlsConfigured": MessageLookupByLibrary.simpleMessage(
      "Không có URL máy chủ cập nhật nào được định cấu hình, vui lòng kiểm tra cấu hình",
    ),
    "updateCheckReleaseNotes": MessageLookupByLibrary.simpleMessage(
      "Ghi chú phát hành:",
    ),
    "updateCheckServerError": m31,
    "updateCheckServerTemporarilyUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Máy chủ tạm thời không khả dụng, vui lòng thử lại sau",
        ),
    "updateCheckServerUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "Cập nhật máy chủ URL chưa được cấu hình, vui lòng kiểm tra cấu hình",
    ),
    "updateCheckUpdateLater": MessageLookupByLibrary.simpleMessage(
      "Cập nhật sau",
    ),
    "updateCheckUpdateNow": MessageLookupByLibrary.simpleMessage(
      "Cập nhật ngay",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Tải lên"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("Lấy hồ sơ thông qua URL"),
    "urlTip": m32,
    "useHosts": MessageLookupByLibrary.simpleMessage("Sử dụng máy chủ"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Sử dụng máy chủ hệ thống",
    ),
    "userCenter": MessageLookupByLibrary.simpleMessage("Trung tâm người dùng"),
    "value": MessageLookupByLibrary.simpleMessage("Giá trị"),
    "verificationCode": MessageLookupByLibrary.simpleMessage("Mã xác minh"),
    "verificationCode6Digits": MessageLookupByLibrary.simpleMessage(
      "Mã xác minh phải có 6 chữ số",
    ),
    "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
      "Mã xác minh đã được gửi tới email của bạn, vui lòng kiểm tra",
    ),
    "verificationCodeSentCheckEmail": MessageLookupByLibrary.simpleMessage(
      "Mã xác minh đã được gửi, vui lòng kiểm tra email của bạn",
    ),
    "verificationCodeSentTo": m33,
    "vi": MessageLookupByLibrary.simpleMessage("Tiếng Việt"),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Sống động"),
    "view": MessageLookupByLibrary.simpleMessage("Xem"),
    "viewHistory": MessageLookupByLibrary.simpleMessage("Xem lịch sử"),
    "visitWebVersion": MessageLookupByLibrary.simpleMessage(
      "Vui lòng truy cập phiên bản web để rút tiền",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Sửa đổi cài đặt liên quan đến VPN",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Tự động định tuyến tất cả lưu lượng truy cập hệ thống thông qua VpnService",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Đính kèm HTTP proxy vào VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Các thay đổi có hiệu lực sau khi khởi động lại VPN",
    ),
    "walletBalance": MessageLookupByLibrary.simpleMessage("Số dư trên Ví"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("Chi tiết ví"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Cấu hình WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage(
      "Chế độ danh sách trắng",
    ),
    "withdraw": MessageLookupByLibrary.simpleMessage("Rút"),
    "withdrawCommission": MessageLookupByLibrary.simpleMessage(
      "Hoa hồng rút tiền",
    ),
    "withdrawableAmount": m34,
    "withdrawalAvailable": MessageLookupByLibrary.simpleMessage(
      "Hoa hồng có sẵn có thể được rút",
    ),
    "xboard24HourCustomerService": MessageLookupByLibrary.simpleMessage(
      "Hỗ trợ dịch vụ khách hàng 24 giờ",
    ),
    "xboardAccountBalance": MessageLookupByLibrary.simpleMessage(
      "Số dư tài khoản",
    ),
    "xboardAddLinkToConfig": MessageLookupByLibrary.simpleMessage(
      "Thêm liên kết đăng ký này vào cấu hình của bạn",
    ),
    "xboardAddingToConfigList": MessageLookupByLibrary.simpleMessage(
      "Thêm vào danh sách cấu hình",
    ),
    "xboardAfterPurchasingPlan": MessageLookupByLibrary.simpleMessage(
      "Sau khi mua gói, bạn sẽ được hưởng:",
    ),
    "xboardAmountToPay": MessageLookupByLibrary.simpleMessage(
      "Số tiền thanh toán",
    ),
    "xboardApiUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "API URL chưa được định cấu hình",
    ),
    "xboardApply": MessageLookupByLibrary.simpleMessage("Áp dụng"),
    "xboardAutoCheckEvery5Seconds": MessageLookupByLibrary.simpleMessage(
      "Hệ thống kiểm tra 5 giây một lần, sẽ tự động chuyển hướng sau khi thanh toán",
    ),
    "xboardAutoDetectPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Tự động phát hiện trạng thái thanh toán",
    ),
    "xboardAutoOpeningPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Trang thanh toán tự động mở, vui lòng quay lại app sau khi thanh toán",
    ),
    "xboardAutoTesting": MessageLookupByLibrary.simpleMessage(
      "Đang tự động kiểm tra",
    ),
    "xboardBack": MessageLookupByLibrary.simpleMessage("Mặt sau"),
    "xboardBandwidthUsageHistory": MessageLookupByLibrary.simpleMessage(
      "Lịch sử sử dụng băng thông 30 ngày",
    ),
    "xboardBrowserNotOpenedTip": MessageLookupByLibrary.simpleMessage(
      "Nếu trình duyệt không tự động mở, hãy nhấp vào \\\"Mở lại\\\" hoặc sao chép liên kết theo cách thủ công",
    ),
    "xboardBuyMoreTrafficOrUpgrade": MessageLookupByLibrary.simpleMessage(
      "Vui lòng mua thêm lưu lượng hoặc nâng cấp gói",
    ),
    "xboardBuyNow": MessageLookupByLibrary.simpleMessage("Mua ngay"),
    "xboardBuyPlan": MessageLookupByLibrary.simpleMessage("Mua gói"),
    "xboardBuyoutPlan": MessageLookupByLibrary.simpleMessage(
      "kế hoạch mua lại",
    ),
    "xboardCancel": MessageLookupByLibrary.simpleMessage("Hủy bỏ"),
    "xboardCancelPayment": MessageLookupByLibrary.simpleMessage(
      "Hủy thanh toán",
    ),
    "xboardCannotLaunchBrowser": MessageLookupByLibrary.simpleMessage(
      "Không thể khởi chạy trình duyệt",
    ),
    "xboardCannotOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Không thể mở liên kết thanh toán",
    ),
    "xboardChange": MessageLookupByLibrary.simpleMessage("Thay đổi"),
    "xboardCheckPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Không thể kiểm tra trạng thái thanh toán",
    ),
    "xboardCheckStatus": MessageLookupByLibrary.simpleMessage(
      "Kiểm tra trạng thái",
    ),
    "xboardChecking": MessageLookupByLibrary.simpleMessage("Kiểm tra"),
    "xboardCleaningOldConfig": MessageLookupByLibrary.simpleMessage(
      "Làm sạch cấu hình cũ",
    ),
    "xboardClearError": MessageLookupByLibrary.simpleMessage("Xóa lỗi"),
    "xboardClickToCopy": MessageLookupByLibrary.simpleMessage(
      "Bấm để sao chép",
    ),
    "xboardClickToSetupNodes": MessageLookupByLibrary.simpleMessage(
      "Nhấn để thiết lập node",
    ),
    "xboardCompletePaymentInBrowser": MessageLookupByLibrary.simpleMessage(
      "2. Vui lòng hoàn tất thanh toán trong trình duyệt của bạn",
    ),
    "xboardConfigDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Tải xuống cấu hình không thành công, vui lòng kiểm tra liên kết đăng ký",
    ),
    "xboardConfigFormatError": MessageLookupByLibrary.simpleMessage(
      "Lỗi định dạng cấu hình, vui lòng liên hệ nhà cung cấp dịch vụ",
    ),
    "xboardConfigSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Lưu cấu hình không thành công, vui lòng kiểm tra dung lượng lưu trữ",
    ),
    "xboardConfigurationError": MessageLookupByLibrary.simpleMessage(
      "Lỗi cấu hình",
    ),
    "xboardConfirm": MessageLookupByLibrary.simpleMessage("Xác nhận"),
    "xboardConfirmAction": MessageLookupByLibrary.simpleMessage("Xác nhận"),
    "xboardConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Xác nhận mật khẩu",
    ),
    "xboardConfirmPurchase": MessageLookupByLibrary.simpleMessage(
      "Xác nhận mua hàng",
    ),
    "xboardCongratulationsSubscriptionActivated":
        MessageLookupByLibrary.simpleMessage(
          "Chúc mừng! Đăng ký của bạn đã được mua và kích hoạt thành công",
        ),
    "xboardConnect": MessageLookupByLibrary.simpleMessage("Kết nối"),
    "xboardConnectGlobalQualityNodes": MessageLookupByLibrary.simpleMessage(
      "Kết nối với các nút chất lượng toàn cầu",
    ),
    "xboardConnected": MessageLookupByLibrary.simpleMessage("Đã kết nối"),
    "xboardConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Hết thời gian kết nối, vui lòng kiểm tra kết nối mạng",
    ),
    "xboardCopyFailed": MessageLookupByLibrary.simpleMessage(
      "Sao chép không thành công",
    ),
    "xboardCopyLink": MessageLookupByLibrary.simpleMessage("Sao chép liên kết"),
    "xboardCopyPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Sao chép liên kết",
    ),
    "xboardCopySubscriptionLinkAbove": MessageLookupByLibrary.simpleMessage(
      "Sao chép liên kết đăng ký ở trên",
    ),
    "xboardCoreStatus": MessageLookupByLibrary.simpleMessage("Trạng thái Core"),
    "xboardCouponExpired": MessageLookupByLibrary.simpleMessage(
      "Phiếu giảm giá đã hết hạn",
    ),
    "xboardCouponNotYetActive": MessageLookupByLibrary.simpleMessage(
      "Phiếu giảm giá chưa hoạt động",
    ),
    "xboardCouponOptional": MessageLookupByLibrary.simpleMessage(
      "Phiếu giảm giá (tùy chọn)",
    ),
    "xboardCreateOrder": MessageLookupByLibrary.simpleMessage("Tạo đơn hàng"),
    "xboardCreatingOrder": MessageLookupByLibrary.simpleMessage("Tạo đơn hàng"),
    "xboardCreatingOrderPleaseWait": MessageLookupByLibrary.simpleMessage(
      "Chúng tôi đang tạo đơn hàng mới cho bạn, vui lòng đợi",
    ),
    "xboardCurrentNode": MessageLookupByLibrary.simpleMessage("Node hiện tại"),
    "xboardCurrentVersion": MessageLookupByLibrary.simpleMessage(
      "Phiên bản hiện tại",
    ),
    "xboardCustomerSupportNotEnabled": MessageLookupByLibrary.simpleMessage(
      "Hỗ trợ khách hàng chưa được bật",
    ),
    "xboardDataUsage": MessageLookupByLibrary.simpleMessage("Sử dụng dữ liệu"),
    "xboardDays": MessageLookupByLibrary.simpleMessage("ngày"),
    "xboardDeductibleDuringPayment": MessageLookupByLibrary.simpleMessage(
      "Được khấu trừ khi thanh toán",
    ),
    "xboardDevices": MessageLookupByLibrary.simpleMessage("thiết bị"),
    "xboardDisabled": MessageLookupByLibrary.simpleMessage("Đã tắt"),
    "xboardDisconnect": MessageLookupByLibrary.simpleMessage("Ngắt kết nối"),
    "xboardDiscount": MessageLookupByLibrary.simpleMessage("Giảm giá"),
    "xboardDiscounted": MessageLookupByLibrary.simpleMessage("Giảm giá"),
    "xboardDownloadingConfig": MessageLookupByLibrary.simpleMessage(
      "Đang tải tập tin cấu hình",
    ),
    "xboardEmail": MessageLookupByLibrary.simpleMessage("E-mail"),
    "xboardEnableTun": MessageLookupByLibrary.simpleMessage("Kích hoạt TUN"),
    "xboardEnabled": MessageLookupByLibrary.simpleMessage("Đã bật"),
    "xboardEnjoyFastNetworkExperience": MessageLookupByLibrary.simpleMessage(
      "Tận hưởng trải nghiệm mạng nhanh",
    ),
    "xboardEnterCouponCode": MessageLookupByLibrary.simpleMessage(
      "Nhập mã giảm giá",
    ),
    "xboardExcellent": MessageLookupByLibrary.simpleMessage("Xuất sắc"),
    "xboardExpiryTime": MessageLookupByLibrary.simpleMessage(
      "Thời gian hết hạn",
    ),
    "xboardFailedToCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Không thể kiểm tra trạng thái thanh toán",
    ),
    "xboardFailedToGetSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Không thể lấy thông tin đăng ký",
    ),
    "xboardFailedToOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Không mở được liên kết thanh toán",
    ),
    "xboardFailedToOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Không mở được trang thanh toán",
    ),
    "xboardFair": MessageLookupByLibrary.simpleMessage("Trung bình"),
    "xboardForceUpdate": MessageLookupByLibrary.simpleMessage("Buộc cập nhật"),
    "xboardForgotPassword": MessageLookupByLibrary.simpleMessage(
      "Quên mật khẩu",
    ),
    "xboardGettingIP": MessageLookupByLibrary.simpleMessage("Đang lấy IP..."),
    "xboardGlobalNodes": MessageLookupByLibrary.simpleMessage("Node toàn cầu"),
    "xboardGood": MessageLookupByLibrary.simpleMessage("Tốt"),
    "xboardGroup": MessageLookupByLibrary.simpleMessage("Nhóm"),
    "xboardHalfYearlyPayment": MessageLookupByLibrary.simpleMessage(
      "Nửa năm một lần",
    ),
    "xboardHandleLater": MessageLookupByLibrary.simpleMessage("Xử lý sau"),
    "xboardHighSpeedNetwork": MessageLookupByLibrary.simpleMessage(
      "Mạng tốc độ cao",
    ),
    "xboardHome": MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "xboardImportFailed": MessageLookupByLibrary.simpleMessage(
      "Import thất bại",
    ),
    "xboardImportSuccess": MessageLookupByLibrary.simpleMessage(
      "Import thành công",
    ),
    "xboardInsufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Số dư không đủ",
    ),
    "xboardInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Tên người dùng hoặc mật khẩu không hợp lệ",
    ),
    "xboardInvalidOrExpiredCoupon": MessageLookupByLibrary.simpleMessage(
      "Mã phiếu giảm giá không hợp lệ hoặc đã hết hạn",
    ),
    "xboardInvalidResponseFormat": MessageLookupByLibrary.simpleMessage(
      "Định dạng phản hồi không hợp lệ từ máy chủ",
    ),
    "xboardInviteCode": MessageLookupByLibrary.simpleMessage("Mã mời"),
    "xboardKeepSubscriptionLinkSafe": MessageLookupByLibrary.simpleMessage(
      "Hãy giữ liên kết đăng ký của bạn an toàn và không chia sẻ với người khác",
    ),
    "xboardLater": MessageLookupByLibrary.simpleMessage("Sau đó"),
    "xboardLoadConfigFailed": m35,
    "xboardLoadFailed": MessageLookupByLibrary.simpleMessage("Tải thất bại"),
    "xboardLoadingFailed": MessageLookupByLibrary.simpleMessage(
      "Tải không thành công",
    ),
    "xboardLoadingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Đang tải trang thanh toán",
    ),
    "xboardLocalIP": MessageLookupByLibrary.simpleMessage("IP cục bộ"),
    "xboardLoggedIn": MessageLookupByLibrary.simpleMessage("Đã đăng nhập"),
    "xboardLogin": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
    "xboardLoginExpired": MessageLookupByLibrary.simpleMessage(
      "Đăng nhập đã hết hạn, vui lòng đăng nhập lại",
    ),
    "xboardLoginFailed": MessageLookupByLibrary.simpleMessage(
      "Đăng nhập không thành công",
    ),
    "xboardLoginSuccess": MessageLookupByLibrary.simpleMessage(
      "Đăng nhập thành công",
    ),
    "xboardLoginToViewSubscription": MessageLookupByLibrary.simpleMessage(
      "Vui lòng đăng nhập để xem việc sử dụng đăng ký",
    ),
    "xboardLogout": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "xboardLogoutConfirmContent": MessageLookupByLibrary.simpleMessage(
      "Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ cần phải nhập lại thông tin đăng nhập của mình.",
    ),
    "xboardLogoutConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Xác nhận đăng xuất",
    ),
    "xboardLogoutFailed": MessageLookupByLibrary.simpleMessage(
      "Đăng xuất không thành công",
    ),
    "xboardLogoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Đăng xuất thành công",
    ),
    "xboardMbps": MessageLookupByLibrary.simpleMessage("Mbps"),
    "xboardMissingRequiredField": MessageLookupByLibrary.simpleMessage(
      "Thiếu trường bắt buộc",
    ),
    "xboardMonthlyPayment": MessageLookupByLibrary.simpleMessage(
      "Thanh toán theo tháng",
    ),
    "xboardMonthlyRenewal": MessageLookupByLibrary.simpleMessage(
      "Gia hạn hàng tháng",
    ),
    "xboardMustUpdate": MessageLookupByLibrary.simpleMessage("Phải cập nhật"),
    "xboardNetworkConnectionFailed": MessageLookupByLibrary.simpleMessage(
      "Kết nối mạng không thành công, vui lòng kiểm tra cài đặt mạng",
    ),
    "xboardNewVersionFound": MessageLookupByLibrary.simpleMessage(
      "Đã tìm thấy phiên bản mới",
    ),
    "xboardNext": MessageLookupByLibrary.simpleMessage("Kế tiếp"),
    "xboardNo": MessageLookupByLibrary.simpleMessage("Không"),
    "xboardNoAvailableNodes": MessageLookupByLibrary.simpleMessage(
      "Không có node khả dụng",
    ),
    "xboardNoAvailablePlan": MessageLookupByLibrary.simpleMessage(
      "Không có gói cước khả dụng",
    ),
    "xboardNoAvailableSubscription": MessageLookupByLibrary.simpleMessage(
      "Không có subscription khả dụng",
    ),
    "xboardNoInternetConnection": MessageLookupByLibrary.simpleMessage(
      "Không có kết nối internet, vui lòng kiểm tra cài đặt mạng",
    ),
    "xboardNoPaymentMethods": MessageLookupByLibrary.simpleMessage(
      "Không có phương thức thanh toán khả dụng",
    ),
    "xboardNoPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "Không có gói nào",
    ),
    "xboardNoSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Chưa có thông tin subscription",
    ),
    "xboardNoSubscriptionPlans": MessageLookupByLibrary.simpleMessage(
      "Không có gói đăng ký",
    ),
    "xboardNodeName": MessageLookupByLibrary.simpleMessage("Tên node"),
    "xboardNone": MessageLookupByLibrary.simpleMessage("Không có"),
    "xboardNotLoggedIn": MessageLookupByLibrary.simpleMessage("Chưa đăng nhập"),
    "xboardNotifications": MessageLookupByLibrary.simpleMessage("Thông báo"),
    "xboardOneTimePayment": MessageLookupByLibrary.simpleMessage(
      "Thanh toán một lần",
    ),
    "xboardOpenPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Không mở được trang thanh toán",
    ),
    "xboardOpenPaymentLinkFailed": MessageLookupByLibrary.simpleMessage(
      "Không mở được liên kết thanh toán",
    ),
    "xboardOpenPaymentPageFailed": m36,
    "xboardOperationFailed": MessageLookupByLibrary.simpleMessage(
      "Thao tác không thành công",
    ),
    "xboardOperationTips": MessageLookupByLibrary.simpleMessage("Mẹo vận hành"),
    "xboardOrderCreationFailed": MessageLookupByLibrary.simpleMessage(
      "Tạo đơn hàng không thành công",
    ),
    "xboardOrderNotFound": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy đơn hàng",
    ),
    "xboardOrderNumber": MessageLookupByLibrary.simpleMessage("Số đơn hàng"),
    "xboardOrderStatusPending": MessageLookupByLibrary.simpleMessage(
      "Trạng thái đơn hàng: Đang chờ thanh toán",
    ),
    "xboardOriginalPrice": MessageLookupByLibrary.simpleMessage("Giá gốc"),
    "xboardPassword": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
    "xboardPaymentCancelled": MessageLookupByLibrary.simpleMessage(
      "Đã hủy thanh toán",
    ),
    "xboardPaymentComplete": MessageLookupByLibrary.simpleMessage(
      "Thanh toán hoàn tất",
    ),
    "xboardPaymentCompleted": MessageLookupByLibrary.simpleMessage(
      "Thanh toán hoàn tất!",
    ),
    "xboardPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Thanh toán thất bại: Không nhận được liên kết thanh toán",
    ),
    "xboardPaymentGateway": MessageLookupByLibrary.simpleMessage(
      "Cổng thanh toán",
    ),
    "xboardPaymentInfo": MessageLookupByLibrary.simpleMessage(
      "Thông tin thanh toán",
    ),
    "xboardPaymentInstructions1": MessageLookupByLibrary.simpleMessage(
      "1. Trang thanh toán đã được mở tự động",
    ),
    "xboardPaymentInstructions2": MessageLookupByLibrary.simpleMessage(
      "2. Vui lòng hoàn tất thanh toán trong trình duyệt",
    ),
    "xboardPaymentInstructions3": MessageLookupByLibrary.simpleMessage(
      "3. Sau khi thanh toán, quay lại app để hệ thống tự động kiểm tra",
    ),
    "xboardPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Liên kết thanh toán",
    ),
    "xboardPaymentLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Đã sao chép liên kết thanh toán vào bảng nhớ tạm",
    ),
    "xboardPaymentMethodVerified": MessageLookupByLibrary.simpleMessage(
      "Phương thức thanh toán đã được xác minh",
    ),
    "xboardPaymentMethodVerifiedPreparing": MessageLookupByLibrary.simpleMessage(
      "Phương thức thanh toán đã được xác minh, chuẩn bị chuyển hướng đến trang thanh toán",
    ),
    "xboardPaymentPageAutoOpened": MessageLookupByLibrary.simpleMessage(
      "1. Trang thanh toán đã được mở tự động",
    ),
    "xboardPaymentPageOpenedCompleteAndReturn":
        MessageLookupByLibrary.simpleMessage(
          "Trang thanh toán đã mở, vui lòng hoàn tất thanh toán và quay lại app",
        ),
    "xboardPaymentPageOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "Trang thanh toán được mở trong trình duyệt, vui lòng quay lại app sau khi thanh toán",
    ),
    "xboardPaymentSuccess": MessageLookupByLibrary.simpleMessage(
      "Thanh toán thành công",
    ),
    "xboardPaymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "🎉 Thanh toán thành công!",
    ),
    "xboardPerMonth": MessageLookupByLibrary.simpleMessage("/ tháng"),
    "xboardPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Thông tin gói cước",
    ),
    "xboardPlanNotFound": MessageLookupByLibrary.simpleMessage(
      "Không tìm thấy gói",
    ),
    "xboardPlans": MessageLookupByLibrary.simpleMessage("Gói cước"),
    "xboardPleaseSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Vui lòng chọn kỳ thanh toán",
    ),
    "xboardPoor": MessageLookupByLibrary.simpleMessage("Kém"),
    "xboardPreparingImport": MessageLookupByLibrary.simpleMessage(
      "Đang chuẩn bị import",
    ),
    "xboardPreparingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Đang chuẩn bị trang thanh toán, sớm chuyển hướng",
    ),
    "xboardPrevious": MessageLookupByLibrary.simpleMessage("Trước"),
    "xboardProcessing": MessageLookupByLibrary.simpleMessage("Đang xử lý..."),
    "xboardProfessionalSupport": MessageLookupByLibrary.simpleMessage(
      "Hỗ trợ chuyên nghiệp",
    ),
    "xboardProfile": MessageLookupByLibrary.simpleMessage("Cấu hình"),
    "xboardProtectNetworkPrivacy": MessageLookupByLibrary.simpleMessage(
      "Bảo vệ quyền riêng tư mạng của bạn",
    ),
    "xboardProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "xboardProxyMode": MessageLookupByLibrary.simpleMessage("Chế độ Proxy"),
    "xboardProxyModeDirectDescription": MessageLookupByLibrary.simpleMessage(
      "Tất cả lưu lượng truy cập kết nối trực tiếp mà không cần proxy",
    ),
    "xboardProxyModeGlobalDescription": MessageLookupByLibrary.simpleMessage(
      "Tất cả lưu lượng truy cập đều đi qua máy chủ proxy",
    ),
    "xboardProxyModeRuleDescription": MessageLookupByLibrary.simpleMessage(
      "Tự động chọn trực tiếp hoặc proxy dựa trên quy tắc",
    ),
    "xboardPurchasePlan": MessageLookupByLibrary.simpleMessage("Mua gói cước"),
    "xboardPurchaseSubscription": MessageLookupByLibrary.simpleMessage(
      "Mua đăng ký",
    ),
    "xboardPurchaseSubscriptionToUse": MessageLookupByLibrary.simpleMessage(
      "Vui lòng mua subscription để sử dụng",
    ),
    "xboardPurchaseTraffic": MessageLookupByLibrary.simpleMessage(
      "Mua lưu lượng",
    ),
    "xboardQuarterlyPayment": MessageLookupByLibrary.simpleMessage(
      "Thanh toán theo quý",
    ),
    "xboardRefresh": MessageLookupByLibrary.simpleMessage("Làm cho khỏe lại"),
    "xboardRefreshStatus": MessageLookupByLibrary.simpleMessage(
      "Làm mới trạng thái",
    ),
    "xboardRefreshSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Làm mới thông tin đăng ký",
    ),
    "xboardRegister": MessageLookupByLibrary.simpleMessage("Đăng ký"),
    "xboardRegisterFailed": MessageLookupByLibrary.simpleMessage(
      "Đăng ký không thành công",
    ),
    "xboardRegisterSuccess": MessageLookupByLibrary.simpleMessage(
      "Đăng ký thành công! Đang chuyển hướng đến trang đăng nhập...",
    ),
    "xboardReload": MessageLookupByLibrary.simpleMessage("Tải lại"),
    "xboardRelogin": MessageLookupByLibrary.simpleMessage("Đăng nhập lại"),
    "xboardRememberPassword": MessageLookupByLibrary.simpleMessage(
      "Nhớ mật khẩu",
    ),
    "xboardRenewPlan": MessageLookupByLibrary.simpleMessage("Gia hạn gói cước"),
    "xboardRenewToContinue": MessageLookupByLibrary.simpleMessage(
      "Vui lòng gia hạn để tiếp tục sử dụng",
    ),
    "xboardReopen": MessageLookupByLibrary.simpleMessage("Mở lại"),
    "xboardReopenPayment": MessageLookupByLibrary.simpleMessage(
      "Mở lại thanh toán",
    ),
    "xboardReopenPaymentPageTip": MessageLookupByLibrary.simpleMessage(
      "Để mở lại, hãy nhấp vào nút \\\"Mở lại\\\" bên dưới",
    ),
    "xboardRetry": MessageLookupByLibrary.simpleMessage("Thử lại"),
    "xboardRetryGet": MessageLookupByLibrary.simpleMessage("Thử lại"),
    "xboardReturn": MessageLookupByLibrary.simpleMessage("Trở lại"),
    "xboardReturnAfterPaymentAutoDetect": MessageLookupByLibrary.simpleMessage(
      "3. Quay lại app sau khi thanh toán, hệ thống sẽ tự động phát hiện",
    ),
    "xboardRunningTime": m37,
    "xboardSecureEncryption": MessageLookupByLibrary.simpleMessage(
      "Mã hóa an toàn",
    ),
    "xboardSelectAPlan": MessageLookupByLibrary.simpleMessage("Chọn gói"),
    "xboardSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Chọn phương thức thanh toán",
    ),
    "xboardSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Chọn kỳ thanh toán",
    ),
    "xboardSelectPeriod": MessageLookupByLibrary.simpleMessage("Chọn chu kỳ"),
    "xboardSendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Gửi mã xác minh",
    ),
    "xboardServerError": MessageLookupByLibrary.simpleMessage("Lỗi máy chủ"),
    "xboardSetup": MessageLookupByLibrary.simpleMessage("Thiết lập"),
    "xboardSixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "Chu kỳ 6 tháng",
    ),
    "xboardSpeedLimit": MessageLookupByLibrary.simpleMessage("Giới hạn tốc độ"),
    "xboardStartProxy": MessageLookupByLibrary.simpleMessage("Bắt đầu Proxy"),
    "xboardStop": MessageLookupByLibrary.simpleMessage("Dừng lại"),
    "xboardStopProxy": MessageLookupByLibrary.simpleMessage("Dừng Proxy"),
    "xboardSubscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "xboardSubscriptionCopied": MessageLookupByLibrary.simpleMessage(
      "Đã sao chép liên kết đăng ký vào bảng nhớ tạm",
    ),
    "xboardSubscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Đăng ký đã hết hạn",
    ),
    "xboardSubscriptionHasExpired": MessageLookupByLibrary.simpleMessage(
      "Đăng ký đã hết hạn",
    ),
    "xboardSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Thông tin đăng ký",
    ),
    "xboardSubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Liên kết đăng ký",
    ),
    "xboardSubscriptionLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Đã sao chép liên kết đăng ký vào bảng nhớ tạm",
    ),
    "xboardSubscriptionPurchase": MessageLookupByLibrary.simpleMessage(
      "Mua subscription",
    ),
    "xboardSubscriptionStatus": MessageLookupByLibrary.simpleMessage(
      "Trạng thái subscription",
    ),
    "xboardSwitch": MessageLookupByLibrary.simpleMessage("Chuyển đổi"),
    "xboardTesting": MessageLookupByLibrary.simpleMessage("Đang kiểm tra"),
    "xboardThirtySixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "Chu kỳ 36 tháng",
    ),
    "xboardThreeMonthCycle": MessageLookupByLibrary.simpleMessage(
      "Chu kỳ 3 tháng",
    ),
    "xboardThreeYearPayment": MessageLookupByLibrary.simpleMessage("Ba năm"),
    "xboardTimeout": MessageLookupByLibrary.simpleMessage("Hết thời gian"),
    "xboardTokenExpiredContent": MessageLookupByLibrary.simpleMessage(
      "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.",
    ),
    "xboardTokenExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Đăng nhập đã hết hạn",
    ),
    "xboardTraffic": MessageLookupByLibrary.simpleMessage("Lưu lượng"),
    "xboardTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Đã hết lưu lượng",
    ),
    "xboardTrafficTrend": MessageLookupByLibrary.simpleMessage(
      "Xu hướng lưu lượng",
    ),
    "xboardTrafficUsedUp": MessageLookupByLibrary.simpleMessage(
      "Lưu lượng đã sử dụng hết",
    ),
    "xboardTunEnabled": MessageLookupByLibrary.simpleMessage("Đã bật TUN"),
    "xboardTwelveMonthCycle": MessageLookupByLibrary.simpleMessage(
      "Chu kỳ 12 tháng",
    ),
    "xboardTwentyFourMonthCycle": MessageLookupByLibrary.simpleMessage(
      "Chu kỳ 24 tháng",
    ),
    "xboardTwoYearPayment": MessageLookupByLibrary.simpleMessage("hai năm"),
    "xboardUnauthorizedAccess": MessageLookupByLibrary.simpleMessage(
      "Truy cập trái phép, vui lòng đăng nhập trước",
    ),
    "xboardUnknownErrorRetry": MessageLookupByLibrary.simpleMessage(
      "Lỗi không xác định, vui lòng thử lại",
    ),
    "xboardUnknownUser": MessageLookupByLibrary.simpleMessage(
      "Người dùng không xác định",
    ),
    "xboardUnlimited": MessageLookupByLibrary.simpleMessage("Không giới hạn"),
    "xboardUnselected": MessageLookupByLibrary.simpleMessage("Bỏ chọn"),
    "xboardUnsupportedCouponType": MessageLookupByLibrary.simpleMessage(
      "Loại phiếu giảm giá không được hỗ trợ",
    ),
    "xboardUpdateContent": MessageLookupByLibrary.simpleMessage(
      "Cập nhật nội dung:",
    ),
    "xboardUpdateLater": MessageLookupByLibrary.simpleMessage("Cập nhật sau"),
    "xboardUpdateNow": MessageLookupByLibrary.simpleMessage("Cập nhật ngay"),
    "xboardUpdateSubscriptionRegularly": MessageLookupByLibrary.simpleMessage(
      "Cập nhật đăng ký thường xuyên để nhận các nút mới nhất",
    ),
    "xboardUsageInstructions": MessageLookupByLibrary.simpleMessage(
      "Hướng dẫn sử dụng",
    ),
    "xboardUsed": MessageLookupByLibrary.simpleMessage("Đã sử dụng"),
    "xboardUsedTraffic": MessageLookupByLibrary.simpleMessage("Đã sử dụng"),
    "xboardValidatingConfigFormat": MessageLookupByLibrary.simpleMessage(
      "Xác thực định dạng cấu hình",
    ),
    "xboardValidationFailed": MessageLookupByLibrary.simpleMessage(
      "Xác thực không thành công",
    ),
    "xboardValidityPeriod": MessageLookupByLibrary.simpleMessage("Thời hạn"),
    "xboardVerify": MessageLookupByLibrary.simpleMessage("Xác minh"),
    "xboardVeryPoor": MessageLookupByLibrary.simpleMessage("Rất kém"),
    "xboardWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "Đang chờ thanh toán",
    ),
    "xboardWaitingPaymentCompletion": MessageLookupByLibrary.simpleMessage(
      "Đang chờ hoàn tất thanh toán",
    ),
    "xboardYearlyPayment": MessageLookupByLibrary.simpleMessage(
      "Thanh toán theo năm",
    ),
    "xboardYes": MessageLookupByLibrary.simpleMessage("Có"),
    "years": MessageLookupByLibrary.simpleMessage("Năm"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("Tiếng Trung (Giản thể)"),
  };
}
