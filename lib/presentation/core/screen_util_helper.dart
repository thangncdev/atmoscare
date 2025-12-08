import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper class để sử dụng ScreenUtil dễ dàng hơn
/// 
/// Design size mặc định: 375x812 (iPhone X)
/// Có thể thay đổi trong main.dart khi khởi tạo ScreenUtil
class ScreenUtilHelper {
  /// Khởi tạo ScreenUtil với design size
  /// 
  /// [designWidth]: Chiều rộng design (mặc định 375)
  /// [designHeight]: Chiều cao design (mặc định 812)
  /// [minTextAdapt]: Tự động scale text (mặc định true)
  /// [splitScreenMode]: Hỗ trợ split screen (mặc định false)
  static Future<void> init({
    double designWidth = 375,
    double designHeight = 812,
    bool minTextAdapt = true,
    bool splitScreenMode = false,
  }) async {
    await ScreenUtil.ensureScreenSize();
  }
}

/// Extension để sử dụng ScreenUtil dễ dàng hơn
extension ScreenUtilExtension on num {
  /// Width responsive
  double get w => ScreenUtil().setWidth(this);
  
  /// Height responsive
  double get h => ScreenUtil().setHeight(this);
  
  /// Font size responsive
  double get sp => ScreenUtil().setSp(this);
  
  /// Radius responsive
  double get r => ScreenUtil().radius(this);
  
  /// Screen width
  double get sw => ScreenUtil().screenWidth;
  
  /// Screen height
  double get sh => ScreenUtil().screenHeight;
  
  /// Screen width percentage
  double get swp => ScreenUtil().screenWidth * (this / 100);
  
  /// Screen height percentage
  double get shp => ScreenUtil().screenHeight * (this / 100);
}

