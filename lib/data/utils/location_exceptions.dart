/// Exception khi dịch vụ vị trí bị tắt
class AppLocationServiceDisabledException implements Exception {
  final String message;
  AppLocationServiceDisabledException([this.message = 'Location services are disabled']);
  
  @override
  String toString() => message;
}

/// Exception khi quyền truy cập vị trí bị từ chối (có thể request lại)
class AppLocationPermissionDeniedException implements Exception {
  final String message;
  AppLocationPermissionDeniedException([this.message = 'Location permissions are denied']);
  
  @override
  String toString() => message;
}

/// Exception khi quyền truy cập vị trí bị từ chối vĩnh viễn (cần mở settings)
class AppLocationPermissionDeniedForeverException implements Exception {
  final String message;
  AppLocationPermissionDeniedForeverException([
    this.message = 'Location permissions are permanently denied. Please enable it in settings.'
  ]);
  
  @override
  String toString() => message;
}

