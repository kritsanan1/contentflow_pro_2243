import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.borderSubtle,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'หรือ',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.borderSubtle,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _SocialButton(
                onPressed: isLoading ? null : () => onSocialLogin('google'),
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                iconColor: Colors.red,
                iconName: 'g_translate',
                text: 'Google',
                isLoading: isLoading,
              ),
            ),
            SizedBox(width: 3.w),

            // Facebook Login
            Expanded(
              child: _SocialButton(
                onPressed: isLoading ? null : () => onSocialLogin('facebook'),
                backgroundColor: const Color(0xFF1877F2),
                textColor: Colors.white,
                iconColor: Colors.white,
                iconName: 'facebook',
                text: 'Facebook',
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String iconName;
  final String text;
  final bool isLoading;

  const _SocialButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconName,
    required this.text,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: AppTheme.surfaceElevated,
          disabledForegroundColor: AppTheme.textDisabled,
          side: BorderSide(
            color: backgroundColor == Colors.white
                ? AppTheme.borderSubtle
                : Colors.transparent,
            width: 1,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isLoading ? AppTheme.textDisabled : iconColor,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              text,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: isLoading ? AppTheme.textDisabled : textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
