import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';

/// Widget hiển thị header với gradient background
class WeatherHeaderSection extends StatefulWidget {
  final WeatherEntity weather;
  final VoidCallback? onLocationTap;

  const WeatherHeaderSection({
    super.key,
    required this.weather,
    this.onLocationTap,
  });

  @override
  State<WeatherHeaderSection> createState() => _WeatherHeaderSectionState();
}

class _WeatherHeaderSectionState extends State<WeatherHeaderSection> {
  @override
  void initState() {
    super.initState();
  }

  /// Получить градиент на основе типа погоды
  LinearGradient _getBackgroundGradient(String conditionType) {
    switch (conditionType.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD54F), Color(0xFFFFB74D), Color(0xFFFF9800)],
          stops: [0.0, 0.5, 1.0],
        );
      case 'cloudy':
      case 'partly_cloudy':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00B2FF), Color(0xFF00CDA3)],
        );
      case 'rainy':
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF536DFE), Color(0xFF448AFF)],
        );
      case 'stormy':
      case 'storm':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5E35B1), Color(0xFF512DA8)],
        );
      case 'foggy':
      case 'fog':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF78909C), Color(0xFF90A4AE)],
        );
      case 'snowy':
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
        );
      default:
        return AppTheme.skyGradient;
    }
  }

  /// Построить белую иконку погоды для градиентного фона
  Widget _buildWeatherIconWhite(String iconName, double size) {
    IconData iconData;

    switch (iconName.toLowerCase()) {
      case 'sunny':
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'partly_cloudy':
        iconData = Icons.wb_cloudy;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        break;
      case 'rainy':
      case 'rain':
        iconData = Icons.grain;
        break;
      case 'stormy':
      case 'storm':
        iconData = Icons.flash_on;
        break;
      case 'foggy':
      case 'fog':
        iconData = Icons.filter_drama;
        break;
      case 'snowy':
      case 'snow':
        iconData = Icons.ac_unit;
        break;
      default:
        iconData = Icons.wb_sunny;
    }

    return Icon(iconData, size: size, color: Colors.white);
  }

  /// Helper widget để tạo slide animation từ trái
  Widget _buildSlideFromLeft({
    required Widget child,
    required Duration delay,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: delay + duration,
      curve: curve,
      builder: (context, value, child) {
        // Tính toán animation value với delay
        final animationValue =
            (value * (delay.inMilliseconds + duration.inMilliseconds) -
                delay.inMilliseconds) /
            duration.inMilliseconds;
        final clampedValue = animationValue.clamp(0.0, 1.0);
        final curvedValue = curve.transform(clampedValue);

        return Transform.translate(
          offset: Offset((1 - curvedValue) * 50, 0),
          child: Opacity(opacity: curvedValue, child: child),
        );
      },
      child: child,
    );
  }

  /// Helper widget để tạo slide animation từ dưới lên
  Widget _buildSlideFromBottom({
    required Widget child,
    required Duration delay,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: delay + duration,
      curve: curve,
      builder: (context, value, child) {
        // Tính toán animation value với delay
        final animationValue =
            (value * (delay.inMilliseconds + duration.inMilliseconds) -
                delay.inMilliseconds) /
            duration.inMilliseconds;
        final clampedValue = animationValue.clamp(0.0, 1.0);
        final curvedValue = curve.transform(clampedValue);

        return Transform.translate(
          offset: Offset(0, (1 - curvedValue) * 30),
          child: Opacity(opacity: curvedValue, child: child),
        );
      },
      child: child,
    );
  }

  /// Helper widget để tạo fade + scale animation
  Widget _buildFadeScale({
    required Widget child,
    required Duration delay,
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOutCubic,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: delay + duration,
      curve: curve,
      builder: (context, value, child) {
        // Tính toán animation value với delay
        final animationValue =
            (value * (delay.inMilliseconds + duration.inMilliseconds) -
                delay.inMilliseconds) /
            duration.inMilliseconds;
        final clampedValue = animationValue.clamp(0.0, 1.0);
        final curvedValue = curve.transform(clampedValue);

        return Transform.scale(
          scale: 0.8 + (curvedValue * 0.2),
          child: Opacity(opacity: curvedValue, child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getBackgroundGradient(widget.weather.icon);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusHeaderGradient,
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Animated Background Elements
          Positioned(
            top: 32.h,
            right: -40.w,
            child: _AnimatedBackgroundIcon(
              iconName: widget.weather.icon,
              size: 180.w,
              duration: const Duration(seconds: 8),
              offsetX: 20,
              offsetY: 10,
            ),
          ),
          Positioned(
            bottom: 0,
            left: -40.w,
            child: _AnimatedBackgroundIcon(
              iconName: widget.weather.icon,
              size: 140.w,
              duration: const Duration(seconds: 10),
              offsetX: -20,
              offsetY: -10,
            ),
          ),

          // Header Content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar with Location Selector
                _buildSlideFromLeft(
                  delay: const Duration(milliseconds: 0),
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusXl,
                    child: InkWell(
                      onTap: widget.onLocationTap,
                      borderRadius: AppTheme.radiusXl,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppTheme.radiusXl,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                size: 18.w,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.weather.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 16.w,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.weather.country,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Main Weather Display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Temperature and Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Temperature - Fade + Scale
                          _buildFadeScale(
                            delay: const Duration(milliseconds: 200),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.weather.temperature.toInt()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 88.sp,
                                    fontWeight: FontWeight.w200,
                                    height: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    '°C',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Condition - Slide from left
                          _buildSlideFromLeft(
                            delay: const Duration(milliseconds: 400),
                            child: Row(
                              children: [
                                _buildWeatherIconWhite(
                                  widget.weather.icon,
                                  24.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  widget.weather.description,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // High/Low - Slide from left
                          _buildSlideFromLeft(
                            delay: const Duration(milliseconds: 500),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 16.w,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${l10n.high}: ${widget.weather.tempHigh.toInt()}°',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  '${l10n.low}: ${widget.weather.tempLow.toInt()}°',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Feels Like & UV - Slide from left
                          _buildSlideFromLeft(
                            delay: const Duration(milliseconds: 600),
                            child: Row(
                              children: [
                                Text(
                                  '${l10n.feelsLike}: ${widget.weather.feelsLike.toInt()}°',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Text(
                                //   '•',
                                //   style: TextStyle(
                                //     color: Colors.white.withValues(alpha: 0.6),
                                //   ),
                                // ),
                                // SizedBox(width: 12.w),
                                // Text(
                                //     'UV: ${widget.weather.uvIndex}/11',
                                //   style: TextStyle(
                                //     color: Colors.white.withValues(alpha: 0.6),
                                //     fontSize: 14.sp,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weather Icon - Fade + Scale
                    _buildFadeScale(
                      delay: const Duration(milliseconds: 300),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 4),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              math.sin(value * 2 * math.pi) * 8,
                            ),
                            child: _buildWeatherIconWhite(
                              widget.weather.icon,
                              100.w,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Quick Stats Bar - Slide from bottom với delay khác nhau
                Row(
                  children: [
                    Expanded(
                      child: _buildSlideFromBottom(
                        delay: const Duration(milliseconds: 700),
                        child: QuickStatCard(
                          icon: Icons.water_drop,
                          label: l10n.humidity,
                          value: '${widget.weather.humidity}%',
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSlideFromBottom(
                        delay: const Duration(milliseconds: 800),
                        child: QuickStatCard(
                          icon: Icons.air,
                          label: l10n.wind,
                          value: '${widget.weather.windSpeed.toInt()}km/h',
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildSlideFromBottom(
                        delay: const Duration(milliseconds: 900),
                        child: QuickStatCard(
                          icon: Icons.wb_sunny,
                          label: "UV",
                          value: '${widget.weather.uvIndex}/11',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // // Curved Bottom Border
          // Positioned(
          //   bottom: -1,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 32.h,
          //     decoration: BoxDecoration(
          //       color: AppTheme.backgroundColor,
          //       borderRadius: AppTheme.curvedBottom,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/// Widget cho quick stat card
class QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const QuickStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: AppTheme.radiusXl,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.w,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget cho animated background icon chạy liên tục
class _AnimatedBackgroundIcon extends StatefulWidget {
  final String iconName;
  final double size;
  final Duration duration;
  final double offsetX;
  final double offsetY;

  const _AnimatedBackgroundIcon({
    required this.iconName,
    required this.size,
    required this.duration,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  State<_AnimatedBackgroundIcon> createState() => _AnimatedBackgroundIconState();
}

class _AnimatedBackgroundIconState extends State<_AnimatedBackgroundIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(); // Chạy liên tục
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWeatherIconWhite(String iconName, double size) {
    IconData iconData;

    switch (iconName.toLowerCase()) {
      case 'sunny':
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'partly_cloudy':
        iconData = Icons.wb_cloudy;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        break;
      case 'rainy':
      case 'rain':
        iconData = Icons.grain;
        break;
      case 'stormy':
      case 'storm':
      case 'thunderstorm':
        iconData = Icons.flash_on;
        break;
      case 'foggy':
      case 'fog':
        iconData = Icons.filter_drama;
        break;
      case 'snowy':
      case 'snow':
        iconData = Icons.ac_unit;
        break;
      default:
        iconData = Icons.wb_sunny;
    }

    return Icon(
      iconData,
      size: size,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            math.sin(_animation.value * 2 * math.pi) * widget.offsetX,
            math.cos(_animation.value * 2 * math.pi) * widget.offsetY,
          ),
          child: Opacity(
            opacity: 0.1,
            child: _buildWeatherIconWhite(widget.iconName, widget.size),
          ),
        );
      },
    );
  }
}
