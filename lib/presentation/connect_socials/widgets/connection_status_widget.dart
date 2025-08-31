import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final int connectedCount;
  final int totalCount;
  final VoidCallback onRefresh;

  const ConnectionStatusWidget({
    Key? key,
    required this.connectedCount,
    required this.totalCount,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = totalCount > 0 ? connectedCount / totalCount : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'สถานะการเชื่อมต่อ',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onRefresh,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.accentPrimary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$connectedCount จาก $totalCount แพลตฟอร์ม',
                      style:
                          AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: connectedCount > 0
                            ? AppTheme.success
                            : AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      connectedCount == totalCount
                          ? 'เชื่อมต่อครบทุกแพลตฟอร์มแล้ว'
                          : 'เชื่อมต่อเพิ่มเติมเพื่อขยายการเข้าถึง',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              _buildProgressCircle(progress),
            ],
          ),
          SizedBox(height: 2.h),
          _buildProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(double progress) {
    return SizedBox(
      width: 16.w,
      height: 16.w,
      child: Stack(
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? AppTheme.success : AppTheme.accentPrimary,
              ),
              strokeWidth: 1.w,
            ),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color:
                    progress == 1.0 ? AppTheme.success : AppTheme.accentPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ความคืบหน้า',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1.h,
          decoration: BoxDecoration(
            color: AppTheme.borderSubtle,
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color:
                    progress == 1.0 ? AppTheme.success : AppTheme.accentPrimary,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
