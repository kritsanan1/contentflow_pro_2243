import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> platforms;
  final List<String> selectedPlatforms;
  final Function(List<String>) onPlatformsChanged;

  const PlatformSelectionWidget({
    Key? key,
    required this.platforms,
    required this.selectedPlatforms,
    required this.onPlatformsChanged,
  }) : super(key: key);

  void _togglePlatform(String platformId) {
    final updatedPlatforms = List<String>.from(selectedPlatforms);
    if (updatedPlatforms.contains(platformId)) {
      updatedPlatforms.remove(platformId);
    } else {
      updatedPlatforms.add(platformId);
    }
    onPlatformsChanged(updatedPlatforms);
  }

  int _getCharacterLimit() {
    if (selectedPlatforms.isEmpty) return 280;

    int minLimit = 280;
    for (String platformId in selectedPlatforms) {
      final platform = platforms.firstWhere(
        (p) => p['id'] == platformId,
        orElse: () => {'characterLimit': 280},
      );
      final limit = platform['characterLimit'] as int;
      if (limit < minLimit) {
        minLimit = limit;
      }
    }
    return minLimit;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: AppTheme.accentPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'เลือกแพลตฟอร์ม',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: platforms.map((platform) {
              final isSelected = selectedPlatforms.contains(platform['id']);
              final isConnected = platform['isConnected'] as bool;

              return GestureDetector(
                onTap:
                    isConnected ? () => _togglePlatform(platform['id']) : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentPrimary.withValues(alpha: 0.2)
                        : AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentPrimary
                          : isConnected
                              ? AppTheme.borderSubtle
                              : AppTheme.textDisabled,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: Color(platform['color']),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: platform['icon'],
                            color: AppTheme.textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            platform['name'],
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isConnected
                                  ? AppTheme.textPrimary
                                  : AppTheme.textDisabled,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (!isConnected)
                            Text(
                              'ไม่ได้เชื่อมต่อ',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textDisabled,
                                fontSize: 10.sp,
                              ),
                            ),
                        ],
                      ),
                      if (isSelected) ...[
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.accentPrimary,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedPlatforms.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.borderSubtle,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.accentSecondary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'ขีดจำกัดตัวอักษร: ${_getCharacterLimit()} ตัวอักษร',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (selectedPlatforms.isEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning_amber',
                    color: AppTheme.warning,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'กรุณาเลือกอย่างน้อย 1 แพลตฟอร์ม',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
