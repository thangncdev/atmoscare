import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/screen_util_helper.dart';
import '../core/theme.dart';

/// Màn hình Splash Screen với animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late AnimationController _cloud1Controller;
  late AnimationController _cloud2Controller;
  late AnimationController _aqiDotController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textTranslate;
  late Animation<double> _dotsOpacity;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeIn,
      ),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );
    _textTranslate = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Dots animation
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _dotsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: Curves.easeIn,
      ),
    );

    // Cloud animations
    _cloud1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    _cloud2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    // AQI dot animation with spring
    _aqiDotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Start animations
    _startAnimations();

    // Navigate to home after delay
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _startAnimations() {
    // Logo appears first with spring animation
    _logoController.forward();
    // AQI dot appears after logo with spring
    Future.delayed(const Duration(milliseconds: 600), () {
      _aqiDotController.forward();
    });
    // Text appears
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });
    // Dots appear
    Future.delayed(const Duration(milliseconds: 800), () {
      _dotsController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _cloud1Controller.dispose();
    _cloud2Controller.dispose();
    _aqiDotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.splashGradient,
        ),
        child: Stack(
          children: [
            // Animated background clouds
            _buildAnimatedCloud(
              top: 80.h,
              left: 40.w,
              size: 120.w,
              controller: _cloud1Controller,
            ),
            _buildAnimatedCloud(
              bottom: 128.h,
              right: 32.w,
              size: 80.w,
              controller: _cloud2Controller,
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Logo
                  _buildMainLogo(),
                  SizedBox(height: 32.h),

                  // App Name and Tagline
                  _buildAppText(),
                ],
              ),
            ),

            // Loading Dots
            Positioned(
              bottom: 64.h,
              left: 0,
              right: 0,
              child: _buildLoadingDots(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCloud({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Smooth animation for natural movement
        final yOffset = (controller.value - 0.5) * 40; // -20 to +20
        final xOffset = (controller.value - 0.5) * 20; // -10 to +10
        return Positioned(
          top: top != null ? top + yOffset : null,
          bottom: bottom != null ? bottom - yOffset : null,
          left: left != null ? left + xOffset : null,
          right: right != null ? right - xOffset : null,
          child: Opacity(
            opacity: 0.2,
            child: Icon(
              Icons.cloud,
              size: size,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _aqiDotController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Outer circle with blur effect and shadow
                PhysicalModel(
                  color: Colors.transparent,
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  child: Container(
                    width: 128.w,
                    height: 128.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.3),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 4.w,
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),

                // Inner white circle
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.cloud,
                    size: 48.w,
                    color: AppTheme.primary500, // Blue cloud từ theme
                  ),
                ),

                // AQI indicator dot with spring animation
                Positioned(
                  top: -8.h,
                  right: -8.w,
                  child: AnimatedBuilder(
                    animation: _aqiDotController,
                    builder: (context, child) {
                      // Spring-like scale animation
                      final scale = Curves.elasticOut.transform(_aqiDotController.value);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.aqiGood, // Green từ theme
                            border: Border.all(
                              color: Colors.white,
                              width: 4.w,
                            ),
                          ),
                          child: Icon(
                            Icons.water_drop,
                            size: 16.w,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value,
          child: Transform.translate(
            offset: Offset(0, _textTranslate.value),
            child: Column(
              children: [
                Text(
                  'AtmosCare',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Thời tiết & Chất lượng không khí',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Opacity(
          opacity: _dotsOpacity.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final animationValue = (_dotsController.value + delay) % 1.0;
              
              // Scale animation: 1 -> 1.5 -> 1
              final scale = 1.0 + (animationValue < 0.5
                      ? animationValue * 2 * 0.5
                      : (1.0 - animationValue) * 2 * 0.5);
              
              // Opacity animation: 0.5 -> 1 -> 0.5
              final opacity = 0.5 + (animationValue < 0.5
                      ? animationValue * 2 * 0.5
                      : (1.0 - animationValue) * 2 * 0.5);

              return Transform.scale(
                scale: scale,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Opacity(opacity: opacity),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

