import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/aqi_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/locale_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../data/utils/aqi_helper.dart';
import '../widgets/skeleton_loading.dart';

/// Màn hình chất lượng không khí
class AQIScreen extends ConsumerStatefulWidget {
  const AQIScreen({super.key});

  @override
  ConsumerState<AQIScreen> createState() => _AQIScreenState();
}

class _AQIScreenState extends ConsumerState<AQIScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aqiAsync = ref.watch(currentAQIProvider);
    final notificationState = ref.watch(notificationEnabledProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: aqiAsync.when(
        data: (aqi) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentAQIProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header với gradient
              SliverToBoxAdapter(child: _buildHeader(context, aqi, l10n)),
              // Content sections
              SliverPadding(
                padding: AppTheme.paddingScreen,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 16.h),
                    _buildRecommendations(context, aqi, l10n),
                    SizedBox(height: 24.h),
                    _buildPollutants(context, aqi, l10n),
                    SizedBox(height: 24.h),
                    _buildAlertSwitch(context, notificationState, ref, l10n),
                    SizedBox(height: 24.h),
                    _buildAQIScale(context, l10n),
                    SizedBox(height: 24.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
        loading: () => const AQIScreenSkeleton(),
        error: (err, stack) => Center(child: Text('Lỗi: ${err.toString()}')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, aqi, l10n) {
    final aqiColor = AppTheme.getAQIColor(aqi.aqi);
    final progress = (aqi.aqi / 500).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusHeaderGradient,
        gradient: AppTheme.skyGradient,
      ),
      child: Stack(
        children: [
          // Animated particles
          ...List.generate(5, (index) {
            return Positioned(
              left:
                  ((20 + index * 15) / 100 * MediaQuery.of(context).size.width),
              top:
                  ((30 + index * 10) /
                  100 *
                  MediaQuery.of(context).size.height),
              child: _AnimatedParticle(
                duration: Duration(seconds: 3 + index),
                delay: Duration(milliseconds: index * 200),
              ),
            );
          }),

          // Header content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
            child: Column(
              children: [
                // Title
                Row(
                  children: [
                    Text(l10n.airQuality, style: AppTheme.headerTitle),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      l10n.aqiAndPollutantsIndex,
                      style: AppTheme.headerSubtitle,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Large AQI Circle
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: SizedBox(
                    width: 192.w,
                    height: 192.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        Container(
                          width: 192.w,
                          height: 192.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: aqiColor.withValues(alpha: 0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Background circle
                        Container(
                          width: 192.w,
                          height: 192.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: 192.w,
                          height: 192.w,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: progress),
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.easeOut,
                            builder: (context, progressValue, child) {
                              return CircularProgressIndicator(
                                value: progressValue,
                                strokeWidth: 14.w,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeCap: StrokeCap.round,
                              );
                            },
                          ),
                        ),
                        // Center content
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Text(
                                '${aqi.aqi}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 72.sp,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'AQI Index',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Status badge
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 10),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppTheme.radius2xl,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      aqi.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Location and update time
                Text(
                  aqi.location,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, aqi, l10n) {
    final aqiColor = AppTheme.getAQIColor(aqi.aqi);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        border: Border(left: BorderSide(color: aqiColor, width: 4)),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: aqiColor.withValues(alpha: 0.2),
                  borderRadius: AppTheme.radiusLg,
                ),
                child: Icon(Icons.info_outline, color: aqiColor, size: 20.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.healthRecommendations,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.basedOnCurrentAQI,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...aqi.recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final recommendation = entry.value;
            final delay = 400 + (index * 100);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: delay.toInt()),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset((1 - value) * -10, 0),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      margin: EdgeInsets.only(top: 8.h, right: 12.w),
                      decoration: BoxDecoration(
                        color: aqiColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPollutants(BuildContext context, aqi, l10n) {
    return Container(
      padding: AppTheme.paddingScreen,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pollutantIndex,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ...aqi.pollutants.asMap().entries.map((entry) {
            final index = entry.key;
            final pollutant = entry.value;
            final pollutantColor = _getPollutantColor(pollutant.status);
            final icon = _getPollutantIcon(pollutant.name);

            final delay = 500 + (index * 50);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: delay.toInt()),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset((1 - value) * -10, 0),
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: AppTheme.radius2xl,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: pollutantColor.withValues(alpha: 0.2),
                        borderRadius: AppTheme.radiusLg,
                      ),
                      child: Icon(icon, color: pollutantColor, size: 24.w),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  pollutant.name,
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pollutantColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    pollutant.status,
                                    style: TextStyle(
                                      color: pollutantColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            pollutant.unit,
                            style: TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      pollutant.value.toStringAsFixed(
                        pollutant.value.truncateToDouble() == pollutant.value
                            ? 0
                            : 1,
                      ),
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAlertSwitch(
    BuildContext context,
    AsyncValue<bool> notificationState,
    WidgetRef ref,
    l10n,
  ) {
    return notificationState.when(
      data: (enabled) => _buildAlertSwitchContent(context, enabled, ref, l10n),
      loading: () => _buildAlertSwitchContent(context, false, ref, l10n),
      error: (_, __) => _buildAlertSwitchContent(context, false, ref, l10n),
    );
  }

  Widget _buildAlertSwitchContent(
    BuildContext context,
    bool enabled,
    WidgetRef ref,
    l10n,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        boxShadow: AppTheme.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: enabled ? AppTheme.primary100 : AppTheme.border,
              borderRadius: AppTheme.radiusLg,
            ),
            child: Icon(
              enabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: enabled ? AppTheme.primary700 : AppTheme.textTertiary,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.highAQIAlert,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  l10n.receiveNotificationWhenAQI,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () {
              ref.read(notificationEnabledProvider.notifier).toggle();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: enabled ? AppTheme.primaryColor : AppTheme.border,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    left: enabled ? 28.w : 4.w,
                    top: 4.h,
                    child: Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.shadowSm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAQIScale(BuildContext context, l10n) {
    final locale = ref.watch(localeProvider);
    final scaleItems = [
      {
        'range': '0-50',
        'status': AQIHelper.getAQIStatus(25, locale: locale),
        'color': AppTheme.aqiGood,
      },
      {
        'range': '51-100',
        'status': AQIHelper.getAQIStatus(75, locale: locale),
        'color': AppTheme.aqiModerate,
      },
      {
        'range': '101-150',
        'status': AQIHelper.getAQIStatus(125, locale: locale),
        'color': AppTheme.aqiUnhealthySensitive,
      },
      {
        'range': '151-200',
        'status': AQIHelper.getAQIStatus(175, locale: locale),
        'color': AppTheme.aqiUnhealthy,
      },
      {
        'range': '201-300',
        'status': AQIHelper.getAQIStatus(250, locale: locale),
        'color': AppTheme.aqiVeryUnhealthy,
      },
      {
        'range': '301+',
        'status': AQIHelper.getAQIStatus(350, locale: locale),
        'color': AppTheme.aqiHazardous,
      },
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.aqiScale,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ...scaleItems.map((item) {
            final color = item['color'] as Color;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      item['range'] as String,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['status'] as String,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getPollutantIcon(String name) {
    switch (name) {
      case 'PM2.5':
        return Icons.grain; // Bụi mịn PM2.5
      case 'PM10':
        return Icons.cloud; // Bụi thô PM10
      case 'CO':
        return Icons.local_fire_department; // Carbon monoxide từ đốt cháy
      case 'SO₂':
        return Icons.warning; // Sulfur dioxide - khí độc
      case 'NO₂':
        return Icons.directions_car; // Nitrogen dioxide từ xe cộ
      case 'O₃':
        return Icons.wb_sunny; // Ozone liên quan đến ánh sáng mặt trời
      default:
        return Icons.air;
    }
  }

  Color _getPollutantColor(String status) {
    switch (status) {
      case 'Tốt':
      case 'Good':
        return AppTheme.aqiGood;
      case 'Trung bình':
      case 'Moderate':
        return AppTheme.aqiModerate;
      case 'Không tốt':
      case 'Unhealthy for Sensitive':
      case 'Unhealthy for Sensitive Groups':
        return AppTheme.aqiUnhealthySensitive;
      case 'Xấu':
      case 'Unhealthy':
        return AppTheme.aqiUnhealthy;
      case 'Rất xấu':
      case 'Very Unhealthy':
        return AppTheme.aqiVeryUnhealthy;
      case 'Nguy hại':
      case 'Hazardous':
        return AppTheme.aqiHazardous;
      default:
        return AppTheme.aqiGood;
    }
  }
}

/// Widget cho animated particle chạy liên tục
class _AnimatedParticle extends StatefulWidget {
  final Duration duration;
  final Duration delay;

  const _AnimatedParticle({
    required this.duration,
    this.delay = Duration.zero,
  });

  @override
  State<_AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<_AnimatedParticle>
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

    // Delay trước khi bắt đầu animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(); // Chạy liên tục
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_animation.value * 2 * math.pi) * 20),
          child: Opacity(
            opacity: (0.2 + (math.sin(_animation.value * 2 * math.pi) * 0.3))
                .clamp(0.0, 1.0),
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
