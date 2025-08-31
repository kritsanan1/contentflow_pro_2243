import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {
      "email": "admin@contentflow.com",
      "password": "admin123",
      "role": "Administrator"
    },
    {
      "email": "manager@contentflow.com",
      "password": "manager123",
      "role": "Social Media Manager"
    },
    {
      "email": "creator@contentflow.com",
      "password": "creator123",
      "role": "Content Creator"
    }
  ];

  @override
  void initState() {
    super.initState();
    // Set status bar style for dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      final validCredential = _mockCredentials.firstWhere(
        (credential) =>
            credential['email'] == email && credential['password'] == password,
        orElse: () => {},
      );

      if (validCredential.isNotEmpty) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        // Navigate to dashboard (route will be handled by routing system)
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/content-calendar');
        }
      } else {
        // Invalid credentials
        _showErrorMessage('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
      }
    } catch (e) {
      _showErrorMessage('เกิดข้อผิดพลาดในการเข้าสู่ระบบ กรุณาลองใหม่อีกครั้ง');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate social login process
      await Future.delayed(const Duration(seconds: 3));

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/content-calendar');
      }
    } catch (e) {
      _showErrorMessage('เกิดข้อผิดพลาดในการเข้าสู่ระบบด้วย $provider');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _navigateToSignUp() {
    // TODO: Navigate to sign up screen when implemented
    _showErrorMessage('หน้าสมัครสมาชิกจะเปิดให้ใช้งานเร็วๆ นี้');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8.h),

                      // App Logo Section
                      const AppLogoWidget(),
                      SizedBox(height: 6.h),

                      // Welcome Text
                      Text(
                        'ยินดีต้อนรับกลับมา',
                        style: AppTheme.darkTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'เข้าสู่ระบบเพื่อจัดการเนื้อหาโซเชียลมีเดียของคุณ',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      SizedBox(height: 4.h),

                      // Social Login Section
                      SocialLoginWidget(
                        onSocialLogin: _handleSocialLogin,
                        isLoading: _isLoading,
                      ),

                      // Spacer to push sign up link to bottom
                      const Spacer(),
                      SizedBox(height: 4.h),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ผู้ใช้ใหม่? ',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading ? null : _navigateToSignUp,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'สมัครสมาชิก',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.accentPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
