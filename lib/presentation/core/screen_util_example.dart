// File này chứa ví dụ cách sử dụng ScreenUtil trong ứng dụng
// 
// CÁCH SỬ DỤNG:
// 
// 1. Import extension:
//    import '../core/screen_util_helper.dart';
// 
// 2. Sử dụng extension:
//    - 16.w  -> width responsive (16 pixels)
//    - 24.h  -> height responsive (24 pixels)
//    - 14.sp -> font size responsive (14 pixels)
//    - 8.r   -> radius responsive (8 pixels)
// 
// VÍ DỤ:
// 
// // Thay vì:
// padding: const EdgeInsets.all(16),
// 
// // Dùng:
// padding: EdgeInsets.all(16.w),
// 
// // Thay vì:
// SizedBox(height: 24),
// 
// // Dùng:
// SizedBox(height: 24.h),
// 
// // Thay vì:
// fontSize: 16,
// 
// // Dùng:
// fontSize: 16.sp,
// 
// // Thay vì:
// borderRadius: BorderRadius.circular(8),
// 
// // Dùng:
// borderRadius: BorderRadius.circular(8.r),
// 
// // Screen dimensions:
// width: 100.swp,  // 100% screen width
// height: 50.shp,  // 50% screen height
// 
// // Hoặc:
// width: ScreenUtil().screenWidth,
// height: ScreenUtil().screenHeight * 0.5,
// 
// LƯU Ý:
// - Design size mặc định: 375x812 (iPhone X)
// - Tất cả các giá trị sẽ tự động scale theo kích thước màn hình thật
// - Text sẽ tự động scale nếu minTextAdapt = true (đã set trong main.dart)
