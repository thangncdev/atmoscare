import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/screen_util_helper.dart';
import '../core/theme.dart';

/// Base skeleton widget với shimmer effect
class SkeletonWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.divider,
      highlightColor: AppTheme.surface,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}

/// Skeleton cho weather header
class WeatherHeaderSkeleton extends StatelessWidget {
  const WeatherHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(gradient: AppTheme.skyGradient),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonWidget(width: 200.w, height: 24.h, borderRadius: 12),
            SizedBox(height: 8.h),
            SkeletonWidget(width: 150.w, height: 16.h, borderRadius: 8),
            SizedBox(height: 24.h),
            Row(
              children: [
                SkeletonWidget(width: 100.w, height: 60.h, borderRadius: 12),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
                      SizedBox(height: 8.h),
                      SkeletonWidget(width: 120.w, height: 16.h, borderRadius: 8),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                SkeletonWidget(width: 60.w, height: 20.h, borderRadius: 8),
                SizedBox(width: 12.w),
                SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton cho AQI summary card
class AQISummaryCardSkeleton extends StatelessWidget {
  const AQISummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonWidget(width: 32.w, height: 32.w, borderRadius: 8),
                    SizedBox(width: 8.w),
                    SkeletonWidget(width: 100.w, height: 16.h, borderRadius: 8),
                  ],
                ),
                SizedBox(height: 12.h),
                SkeletonWidget(width: 120.w, height: 24.h, borderRadius: 8),
                SizedBox(height: 8.h),
                SkeletonWidget(width: 150.w, height: 12.h, borderRadius: 6),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          SkeletonWidget(width: 100.w, height: 100.w, borderRadius: 50),
        ],
      ),
    );
  }
}

/// Skeleton cho sunrise/sunset row
class SunriseSunsetRowSkeleton extends StatelessWidget {
  const SunriseSunsetRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonWidget(width: 48.w, height: 48.w, borderRadius: 12),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(width: 60.w, height: 12.h, borderRadius: 6),
                          SizedBox(height: 4.h),
                          SkeletonWidget(width: 80.w, height: 24.h, borderRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SkeletonWidget(width: double.infinity, height: 4.h, borderRadius: 2),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonWidget(width: 48.w, height: 48.w, borderRadius: 12),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(width: 60.w, height: 12.h, borderRadius: 6),
                          SizedBox(height: 4.h),
                          SkeletonWidget(width: 80.w, height: 24.h, borderRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SkeletonWidget(width: double.infinity, height: 4.h, borderRadius: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton cho weather details grid
class WeatherDetailsGridSkeleton extends StatelessWidget {
  const WeatherDetailsGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Tính chiều cao cố định cho card (vuông, dựa trên chiều rộng màn hình)
    final cardHeight = (MediaQuery.of(context).size.width - 48.w - 16.w) / 2;

    return Column(
      children: [
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 12),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: SkeletonWidget(width: 60.w, height: 11.h, borderRadius: 6),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
                      SizedBox(height: 4.h),
                      SkeletonWidget(width: 50.w, height: 12.h, borderRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 12),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: SkeletonWidget(width: 60.w, height: 11.h, borderRadius: 6),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
                      SizedBox(height: 4.h),
                      SkeletonWidget(width: 50.w, height: 12.h, borderRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 12),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: SkeletonWidget(width: 60.w, height: 11.h, borderRadius: 6),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
                      SizedBox(height: 4.h),
                      SkeletonWidget(width: 50.w, height: 12.h, borderRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 12),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: SkeletonWidget(width: 60.w, height: 11.h, borderRadius: 6),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SkeletonWidget(width: 80.w, height: 20.h, borderRadius: 8),
                      SizedBox(height: 4.h),
                      SkeletonWidget(width: 50.w, height: 12.h, borderRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

/// Skeleton cho hourly forecast widget
class HourlyForecastSkeleton extends StatelessWidget {
  const HourlyForecastSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonWidget(width: 150.w, height: 18.h, borderRadius: 8),
              SkeletonWidget(width: 100.w, height: 18.h, borderRadius: 8),
            ],
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonWidget(width: 40.w, height: 12.h, borderRadius: 6),
                      SizedBox(height: 8.h),
                      SkeletonWidget(width: 32.w, height: 32.w, borderRadius: 16),
                      SizedBox(height: 8.h),
                      SkeletonWidget(width: 30.w, height: 16.h, borderRadius: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton cho forecast header
class ForecastHeaderSkeleton extends StatelessWidget {
  const ForecastHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusHeaderGradient,
        gradient: AppTheme.skyGradient,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonWidget(width: 200.w, height: 24.h, borderRadius: 12),
            SizedBox(height: 8.h),
            SkeletonWidget(width: 180.w, height: 16.h, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

/// Skeleton cho forecast hourly list
class ForecastHourlyListSkeleton extends StatelessWidget {
  final bool showViewDetails;

  const ForecastHourlyListSkeleton({
    super.key,
    this.showViewDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showViewDetails
          ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
          : AppTheme.paddingScreen,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: showViewDetails
            ? BorderRadius.circular(28.r)
            : AppTheme.radius2xl,
        boxShadow: showViewDetails
            ? AppTheme.shadowLg
            : AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonWidget(width: 150.w, height: 18.h, borderRadius: 8),
              if (showViewDetails)
                SkeletonWidget(width: 100.w, height: 18.h, borderRadius: 8),
            ],
          ),
          SizedBox(height: showViewDetails ? 8.h : 16.h),
          SizedBox(
            height: showViewDetails ? 150.h : 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: showViewDetails ? 12.w : 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: showViewDetails
                        ? BorderRadius.circular(28.r)
                        : BorderRadius.circular(36.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonWidget(width: 40.w, height: 12.h, borderRadius: 6),
                      SizedBox(height: 8.h),
                      SkeletonWidget(width: 32.w, height: 32.w, borderRadius: 16),
                      SizedBox(height: 8.h),
                      SkeletonWidget(width: 30.w, height: 16.h, borderRadius: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton cho forecast daily list
class ForecastDailyListSkeleton extends StatelessWidget {
  const ForecastDailyListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
          SkeletonWidget(width: 100.w, height: 18.h, borderRadius: 8),
          SizedBox(height: 16.h),
          ...List.generate(7, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index < 6 ? 0 : 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(width: 100.w, height: 16.h, borderRadius: 8),
                          SizedBox(height: 2.h),
                          SkeletonWidget(width: 80.w, height: 12.h, borderRadius: 6),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 20),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(width: 60.w, height: 12.h, borderRadius: 6),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SkeletonWidget(width: 30.w, height: 16.h, borderRadius: 8),
                    SizedBox(width: 4.w),
                    SkeletonWidget(width: 30.w, height: 14.h, borderRadius: 8),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton cho AQI header
class AQIHeaderSkeleton extends StatelessWidget {
  const AQIHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusHeaderGradient,
        gradient: AppTheme.skyGradient,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
        child: Column(
          children: [
            // Title
            Row(
              children: [
                SkeletonWidget(width: 150.w, height: 24.h, borderRadius: 12),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SkeletonWidget(width: 200.w, height: 16.h, borderRadius: 8),
              ],
            ),
            SizedBox(height: 32.h),
            // AQI Circle
            SkeletonWidget(width: 192.w, height: 192.w, borderRadius: 96),
            SizedBox(height: 24.h),
            // Status badge
            SkeletonWidget(width: 120.w, height: 40.h, borderRadius: 20),
            SizedBox(height: 16.h),
            // Location
            SkeletonWidget(width: 150.w, height: 16.h, borderRadius: 8),
          ],
        ),
      ),
    );
  }
}

/// Skeleton cho AQI recommendations
class AQIRecommendationsSkeleton extends StatelessWidget {
  const AQIRecommendationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              SkeletonWidget(width: 40.w, height: 40.w, borderRadius: 12),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonWidget(width: 180.w, height: 18.h, borderRadius: 8),
                    SizedBox(height: 4.h),
                    SkeletonWidget(width: 150.w, height: 12.h, borderRadius: 6),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonWidget(width: 6.w, height: 6.w, borderRadius: 3),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SkeletonWidget(
                      width: double.infinity,
                      height: 14.h,
                      borderRadius: 6,
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
}

/// Skeleton cho AQI pollutants
class AQIPollutantsSkeleton extends StatelessWidget {
  const AQIPollutantsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
          SkeletonWidget(width: 150.w, height: 18.h, borderRadius: 8),
          SizedBox(height: 16.h),
          ...List.generate(6, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: AppTheme.radius2xl,
              ),
              child: Row(
                children: [
                  SkeletonWidget(width: 48.w, height: 48.w, borderRadius: 12),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SkeletonWidget(width: 60.w, height: 16.h, borderRadius: 8),
                            SizedBox(width: 8.w),
                            SkeletonWidget(width: 50.w, height: 20.h, borderRadius: 10),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        SkeletonWidget(width: 80.w, height: 12.h, borderRadius: 6),
                      ],
                    ),
                  ),
                  SkeletonWidget(width: 50.w, height: 24.h, borderRadius: 8),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Skeleton cho AQI alert switch
class AQIAlertSwitchSkeleton extends StatelessWidget {
  const AQIAlertSwitchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        boxShadow: AppTheme.shadowMd,
      ),
      child: Row(
        children: [
          SkeletonWidget(width: 48.w, height: 48.w, borderRadius: 12),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(width: 150.w, height: 16.h, borderRadius: 8),
                SizedBox(height: 4.h),
                SkeletonWidget(width: 200.w, height: 12.h, borderRadius: 6),
              ],
            ),
          ),
          SkeletonWidget(width: 56.w, height: 32.h, borderRadius: 16),
        ],
      ),
    );
  }
}

/// Skeleton cho AQI scale
class AQIScaleSkeleton extends StatelessWidget {
  const AQIScaleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
          SkeletonWidget(width: 100.w, height: 18.h, borderRadius: 8),
          SizedBox(height: 16.h),
          ...List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  SkeletonWidget(width: 12.w, height: 12.w, borderRadius: 6),
                  SizedBox(width: 12.w),
                  SkeletonWidget(width: 80.w, height: 14.h, borderRadius: 6),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SkeletonWidget(
                      width: double.infinity,
                      height: 14.h,
                      borderRadius: 6,
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
}

/// Skeleton cho toàn bộ AQI screen
class AQIScreenSkeleton extends StatelessWidget {
  const AQIScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: const AQIHeaderSkeleton()),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 16.h),
              const AQIRecommendationsSkeleton(),
              SizedBox(height: 24.h),
              const AQIPollutantsSkeleton(),
              SizedBox(height: 24.h),
              const AQIAlertSwitchSkeleton(),
              SizedBox(height: 24.h),
              const AQIScaleSkeleton(),
              SizedBox(height: 24.h),
            ]),
          ),
        ),
      ],
    );
  }
}

