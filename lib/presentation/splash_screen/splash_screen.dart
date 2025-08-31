import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _initializationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Loading indicator animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization steps with progress updates
      await _performInitializationSteps();

      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'เกิดข้อผิดพลาดในการเริ่มต้นแอป';
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'name': 'กำลังตรวจสอบการเชื่อมต่อ...', 'duration': 500},
      {'name': 'กำลังโหลดการตั้งค่าผู้ใช้...', 'duration': 600},
      {'name': 'กำลังตรวจสอบการเชื่อมต่อโซเชียลมีเดีย...', 'duration': 700},
      {'name': 'กำลังเตรียมข้อมูลแคช...', 'duration': 500},
      {'name': 'เสร็จสิ้น', 'duration': 200},
    ];

    for (int i = 0; i < steps.length; i++) {
      if (!mounted) return;

      await Future.delayed(Duration(milliseconds: steps[i]['duration'] as int));

      if (mounted) {
        setState(() {
          _initializationProgress = (i + 1) / steps.length;
        });
      }
    }
  }

  Future<void> _navigateToNextScreen() async {
    // Add a small delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Simulate authentication check
    final isAuthenticated = await _checkAuthenticationStatus();

    if (!mounted) return;

    // Navigate based on authentication status
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/content-calendar');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 300));

    // For demo purposes, return false to show login screen
    // In real implementation, check stored authentication tokens
    return false;
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitializing = true;
      _initializationProgress = 0.0;
      _errorMessage = '';
    });

    _logoAnimationController.reset();
    _logoAnimationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryBackground,
                AppTheme.secondaryBackground,
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: _hasError ? _buildErrorView() : _buildSplashContent(),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // App Logo Section
        AnimatedBuilder(
          animation: _logoAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                opacity: _logoFadeAnimation.value,
                child: _buildAppLogo(),
              ),
            );
          },
        ),

        SizedBox(height: 8.h),

        // App Name
        AnimatedBuilder(
          animation: _logoAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _logoFadeAnimation.value,
              child: Text(
                'ContentFlow Pro',
                style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Tagline
        AnimatedBuilder(
          animation: _logoAnimationController,
          builder: (context, child) {
            return Opacity(
              opacity: _logoFadeAnimation.value * 0.8,
              child: Text(
                'AI-Powered Social Media Management',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),

        const Spacer(flex: 2),

        // Loading Section
        if (_isInitializing) _buildLoadingSection(),

        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentPrimary,
            AppTheme.accentSecondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentPrimary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'dashboard',
          color: AppTheme.textPrimary,
          size: 16.w,
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Progress Bar
        Container(
          width: 60.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: AppTheme.borderSubtle,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.w * _initializationProgress,
            height: 0.5.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.accentPrimary,
                  AppTheme.accentSecondary,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Loading Indicator
        AnimatedBuilder(
          animation: _loadingAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _loadingAnimation.value * 2 * 3.14159,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderSubtle,
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: _LoadingPainter(),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Loading Text
        Text(
          'กำลังเริ่มต้น...',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Error Icon
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.error.withValues(alpha: 0.1),
            border: Border.all(
              color: AppTheme.error.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.error,
              size: 10.w,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // Error Message
        Text(
          _errorMessage,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 2.h),

        Text(
          'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและลองใหม่อีกครั้ง',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 6.h),

        // Retry Button
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentPrimary,
            foregroundColor: AppTheme.textPrimary,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.textPrimary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'ลองใหม่อีกครั้ง',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}

class _LoadingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentPrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start from top (-90 degrees in radians)
      1.5708, // Draw quarter circle (90 degrees in radians)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
