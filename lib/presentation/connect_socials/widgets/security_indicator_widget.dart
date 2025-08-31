import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityIndicatorWidget extends StatelessWidget {
  final bool isSecure;
  final String lastVerification;

  const SecurityIndicatorWidget({
    Key? key,
    required this.isSecure,
    required this.lastVerification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSecure ? AppTheme.success : AppTheme.warning,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (isSecure ? AppTheme.success : AppTheme.warning)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: isSecure ? 'security' : 'warning',
                  color: isSecure ? AppTheme.success : AppTheme.warning,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ความปลอดภัย',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isSecure
                          ? 'การเชื่อมต่อปลอดภัย'
                          : 'ต้องการการยืนยันตัวตน',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: isSecure ? AppTheme.success : AppTheme.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSecurityFeatures(),
          SizedBox(height: 2.h),
          _buildLastVerification(),
        ],
      ),
    );
  }

  Widget _buildSecurityFeatures() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': 'lock',
        'title': 'การเข้ารหัส SSL/TLS',
        'status': true,
      },
      {
        'icon': 'verified_user',
        'title': 'การยืนยันตัวตน OAuth 2.0',
        'status': isSecure,
      },
      {
        'icon': 'key',
        'title': 'การจัดเก็บ Token ที่ปลอดภัย',
        'status': true,
      },
      {
        'icon': 'privacy_tip',
        'title': 'การปกป้องข้อมูลส่วนบุคคล',
        'status': isSecure,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'คุณสมบัติด้านความปลอดภัย',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        ...features
            .map((feature) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: feature['status'] ? 'check_circle' : 'cancel',
                        color: feature['status']
                            ? AppTheme.success
                            : AppTheme.error,
                        size: 4.w,
                      ),
                      SizedBox(width: 3.w),
                      CustomIconWidget(
                        iconName: feature['icon'],
                        color: AppTheme.textSecondary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          feature['title'],
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildLastVerification() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.borderSubtle.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color: AppTheme.textSecondary,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'การยืนยันล่าสุด: $lastVerification',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
