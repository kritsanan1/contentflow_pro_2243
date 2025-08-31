import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformCardWidget extends StatelessWidget {
  final Map<String, dynamic> platform;
  final VoidCallback onConnect;
  final VoidCallback? onManage;

  const PlatformCardWidget({
    Key? key,
    required this.platform,
    required this.onConnect,
    this.onManage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isConnected = platform['isConnected'] ?? false;
    final String platformName = platform['name'] ?? '';
    final String iconName = platform['iconName'] ?? 'public';
    final Color brandColor = Color(platform['brandColor'] ?? 0xFF6B46C1);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected ? AppTheme.success : AppTheme.borderSubtle,
          width: isConnected ? 2 : 1,
        ),
        boxShadow: AppTheme.getElevationShadow(2),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(brandColor, iconName, platformName, isConnected),
            if (isConnected) ...[
              SizedBox(height: 2.h),
              _buildConnectedInfo(),
              SizedBox(height: 2.h),
              _buildManageButton(),
            ] else ...[
              SizedBox(height: 2.h),
              _buildConnectButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color brandColor, String iconName, String platformName,
      bool isConnected) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: brandColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: brandColor,
              size: 6.w,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platformName,
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: isConnected
                          ? AppTheme.success
                          : AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isConnected ? 'เชื่อมต่อแล้ว' : 'ยังไม่ได้เชื่อมต่อ',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: isConnected
                          ? AppTheme.success
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.success.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: platform['avatar'] ?? 'https://via.placeholder.com/40',
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform['username'] ?? 'ไม่ทราบชื่อผู้ใช้',
                  style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${platform['followers'] ?? 0} ผู้ติดตาม',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'ซิงค์ล่าสุด: ${platform['lastSync'] ?? 'ไม่ทราบ'}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onConnect,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentPrimary,
          foregroundColor: AppTheme.textPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'link',
              color: AppTheme.textPrimary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'เชื่อมต่อบัญชี',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onManage,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.accentPrimary,
          side: BorderSide(color: AppTheme.accentPrimary, width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.accentPrimary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'จัดการบัญชี',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
