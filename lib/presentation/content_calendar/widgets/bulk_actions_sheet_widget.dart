import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsSheetWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedPosts;
  final VoidCallback onReschedule;
  final VoidCallback onChangePlatforms;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const BulkActionsSheetWidget({
    Key? key,
    required this.selectedPosts,
    required this.onReschedule,
    required this.onChangePlatforms,
    required this.onDelete,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 3.h),
          _buildSelectedPostsInfo(),
          SizedBox(height: 3.h),
          _buildActionButtons(),
          SizedBox(height: 2.h),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'checklist',
          color: AppTheme.accentPrimary,
          size: 24,
        ),
        SizedBox(width: 3.w),
        Text(
          'การดำเนินการแบบกลุ่ม',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPostsInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.accentPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.accentPrimary.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: AppTheme.accentPrimary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            'เลือกโพสต์ ${selectedPosts.length} รายการ',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.accentPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: 'schedule',
          title: 'เปลี่ยนเวลาเผยแพร่',
          subtitle: 'กำหนดเวลาใหม่สำหรับโพสต์ที่เลือก',
          onTap: onReschedule,
        ),
        SizedBox(height: 2.h),
        _buildActionButton(
          icon: 'swap_horiz',
          title: 'เปลี่ยนแพลตฟอร์ม',
          subtitle: 'เลือกแพลตฟอร์มใหม่สำหรับการเผยแพร่',
          onTap: onChangePlatforms,
        ),
        SizedBox(height: 2.h),
        _buildActionButton(
          icon: 'delete',
          title: 'ลบโพสต์',
          subtitle: 'ลบโพสต์ที่เลือกทั้งหมด',
          onTap: onDelete,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? AppTheme.error : AppTheme.textSecondary;
    final titleColor = isDestructive ? AppTheme.error : AppTheme.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isDestructive
                ? AppTheme.error.withValues(alpha: 0.3)
                : AppTheme.borderSubtle,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: iconColor,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onCancel,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Text('ยกเลิก'),
      ),
    );
  }
}
