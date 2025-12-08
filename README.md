# AirCare - Ứng dụng Thời tiết & Chất lượng Không khí

Ứng dụng Flutter hiện đại để theo dõi thời tiết và chất lượng không khí, được xây dựng với Clean Architecture.

## 🚀 Tính năng

- **Trang chủ**: Hiển thị thông tin thời tiết hiện tại, thông số chi tiết, AQI tóm tắt và dự báo 24 giờ
- **Dự báo**: Xem dự báo 24 giờ hoặc 7 ngày với toggle dễ dàng
- **AQI**: Hiển thị chỉ số chất lượng không khí chi tiết với biểu đồ tròn, khuyến nghị sức khỏe và danh sách chất ô nhiễm
- **Cài đặt**: Màn hình cài đặt (sẽ được mở rộng)

## 📋 Yêu cầu

- Flutter SDK (stable mới nhất)
- Dart SDK ^3.9.0
- iOS Simulator hoặc Android Emulator / Thiết bị thật

## 🛠️ Cài đặt

1. **Clone repository** (nếu có) hoặc mở project trong thư mục hiện tại

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

   Hoặc chạy trên platform cụ thể:
   ```bash
   flutter run -d ios
   flutter run -d android
   ```

## 📁 Cấu trúc Project

```
lib/
├── domain/                    # Domain layer (business logic)
│   ├── entities/             # Domain entities
│   │   ├── weather_entity.dart
│   │   ├── hourly_forecast_entity.dart
│   │   ├── daily_forecast_entity.dart
│   │   └── aqi_entity.dart
│   └── repositories/         # Repository interfaces
│       └── weather_repository.dart
│
├── data/                      # Data layer
│   ├── models/               # Data models (JSON serialization)
│   │   ├── weather_model.dart
│   │   ├── hourly_forecast_model.dart
│   │   ├── daily_forecast_model.dart
│   │   └── aqi_model.dart
│   └── repositories/         # Repository implementations
│       ├── weather_repository_impl.dart
│       └── aqi_repository_impl.dart
│
└── presentation/             # Presentation layer (UI)
    ├── core/                 # Core configurations
    │   ├── theme.dart
    │   └── router.dart
    ├── providers/            # Riverpod providers
    │   ├── weather_provider.dart
    │   └── aqi_provider.dart
    ├── screens/              # App screens
    │   ├── home_screen.dart
    │   ├── forecast_screen.dart
    │   ├── aqi_screen.dart
    │   └── settings_screen.dart
    └── widgets/              # Reusable widgets
        ├── weather_icon.dart
        └── aqi_color_bar.dart

assets/
└── data/                     # Mock JSON data
    ├── current_weather.json
    ├── hourly_forecast.json
    ├── daily_forecast.json
    └── aqi.json
```

## 🏗️ Kiến trúc

Ứng dụng sử dụng **Clean Architecture** với 3 layers:

1. **Domain Layer**: Chứa business logic và entities, không phụ thuộc vào framework
2. **Data Layer**: Xử lý data từ API/JSON, implement repositories
3. **Presentation Layer**: UI, state management (Riverpod), routing (GoRouter)

### State Management

- **Riverpod**: Quản lý state toàn cục và providers
- **FutureProvider**: Cho async data (weather, AQI)
- **StateNotifierProvider**: Cho state có thể thay đổi (AQI alert)

### Routing

- **GoRouter**: Navigation và routing
- **ShellRoute**: Wrapper cho bottom navigation

## 🔄 Chuyển từ Mock Data sang API thật

### Bước 1: Cập nhật Repository Implementation

Thay vì đọc từ JSON local, cập nhật `WeatherRepositoryImpl` và `AQIRepositoryImpl` để gọi API:

**Ví dụ với Dio:**

```dart
// lib/data/repositories/weather_repository_impl.dart
import 'package:dio/dio.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;
  final String _baseUrl = 'https://api.weather.com/v1';

  WeatherRepositoryImpl(this._dio);

  @override
  Future<WeatherEntity> getCurrentWeather() async {
    try {
      final response = await _dio.get('$_baseUrl/current', queryParameters: {
        'location': 'Hanoi',
        'units': 'metric',
      });
      
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load current weather: $e');
    }
  }

  // Tương tự cho các methods khác...
}
```

### Bước 2: Setup Dio trong Provider

Cập nhật provider để inject Dio:

```dart
// lib/presentation/providers/weather_provider.dart
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.weather.com/v1',
    headers: {
      'Content-Type': 'application/json',
      // Thêm API key nếu cần
      'Authorization': 'Bearer YOUR_API_KEY',
    },
  ));
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(ref.watch(dioProvider));
});
```

### Bước 3: Xử lý Error Handling

Thêm error handling tốt hơn:

```dart
@override
Future<WeatherEntity> getCurrentWeather() async {
  try {
    final response = await _dio.get('$_baseUrl/current');
    return WeatherModel.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response != null) {
      throw Exception('API Error: ${e.response?.statusCode}');
    } else {
      throw Exception('Network Error: ${e.message}');
    }
  }
}
```

### Bước 4: Cập nhật Models

Đảm bảo models có thể parse từ API response. Có thể cần thêm `fromJson` factory methods hoặc sử dụng `json_serializable`.

### Bước 5: Testing

Test với API thật và xử lý các edge cases:
- Network errors
- API rate limits
- Invalid responses
- Timeout

## 📝 API Providers gợi ý

### Thời tiết:
- **OpenWeatherMap**: https://openweathermap.org/api
- **WeatherAPI**: https://www.weatherapi.com/
- **AccuWeather**: https://developer.accuweather.com/

### Chất lượng không khí:
- **OpenAQ**: https://openaq.org/
- **AirVisual API**: https://www.iqair.com/air-pollution-data-api
- **WAQI**: https://aqicn.org/api/

## 🎨 Customization

### Responsive Design với ScreenUtil

Ứng dụng sử dụng `flutter_screenutil` để tự động scale UI theo kích thước màn hình.

**Design size mặc định**: 375x812 (iPhone X)

**Cách sử dụng:**

```dart
// Import extension
import '../core/screen_util_helper.dart';

// Sử dụng extension
padding: EdgeInsets.all(16.w),      // Width responsive
SizedBox(height: 24.h),              // Height responsive
fontSize: 18.sp,                     // Font size responsive
borderRadius: BorderRadius.circular(8.r), // Radius responsive

// Screen dimensions
width: 100.swp,  // 100% screen width
height: 50.shp,  // 50% screen height
```

**Thay đổi design size:**

Chỉnh sửa trong `lib/main.dart`:

```dart
ScreenUtilInit(
  designSize: const Size(375, 812), // Thay đổi theo design của bạn
  // ...
)
```

Xem thêm ví dụ trong `lib/presentation/core/screen_util_example.dart`

### Thay đổi Theme

Chỉnh sửa `lib/presentation/core/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF00BCD4); // Màu chủ đạo
```

### Thay đổi Mock Data

Chỉnh sửa các file JSON trong `assets/data/`:
- `current_weather.json`
- `hourly_forecast.json`
- `daily_forecast.json`
- `aqi.json`

## 🧪 Testing

```bash
# Chạy tests
flutter test

# Chạy với coverage
flutter test --coverage
```

## 📦 Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🔧 Troubleshooting

### Lỗi "Target of URI doesn't exist"
Chạy lại:
```bash
flutter pub get
flutter clean
flutter pub get
```

### Lỗi assets không load
Đảm bảo `pubspec.yaml` có:
```yaml
flutter:
  assets:
    - assets/data/
```

Sau đó chạy:
```bash
flutter pub get
```

## 📄 License

MIT License

## 👨‍💻 Tác giả

Senior Flutter Developer - AirCare Team

---

**Lưu ý**: Đây là phiên bản nền tảng với mock data. Để sử dụng trong production, cần:
1. Tích hợp API thật
2. Thêm error handling đầy đủ
3. Thêm loading states
4. Thêm caching
5. Thêm offline support
6. Thêm unit tests và integration tests
