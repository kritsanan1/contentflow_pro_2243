import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalendarHeaderWidget extends StatelessWidget {
  final bool isWeekView;
  final VoidCallback onToggleView;
  final VoidCallback onTodayPressed;
  final String currentMonth;

  const CalendarHeaderWidget({
    Key? key,
    required this.isWeekView,
    required this.onToggleView,
    required this.onTodayPressed,
    required this.currentMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth,
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  _buildViewToggleButton(),
                  SizedBox(width: 3.w),
                  _buildTodayButton(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleOption('สัปดาห์', true, isWeekView),
          _buildToggleOption('เดือน', false, !isWeekView),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isWeek, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if ((isWeek && !isWeekView) || (!isWeek && isWeekView)) {
          onToggleView();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Text(
          text,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayButton() {
    return GestureDetector(
      onTap: onTodayPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.accentSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'วันนี้',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
