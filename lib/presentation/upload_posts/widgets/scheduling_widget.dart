import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SchedulingWidget extends StatefulWidget {
  final DateTime? scheduledDateTime;
  final Function(DateTime?) onScheduleChanged;

  const SchedulingWidget({
    Key? key,
    required this.scheduledDateTime,
    required this.onScheduleChanged,
  }) : super(key: key);

  @override
  State<SchedulingWidget> createState() => _SchedulingWidgetState();
}

class _SchedulingWidgetState extends State<SchedulingWidget> {
  bool _isScheduled = false;

  @override
  void initState() {
    super.initState();
    _isScheduled = widget.scheduledDateTime != null;
  }

  Future<void> _selectDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.scheduledDateTime ?? now.add(Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme.copyWith(
            colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
              primary: AppTheme.accentPrimary,
              surface: AppTheme.secondaryBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          widget.scheduledDateTime ?? now.add(Duration(hours: 1)),
        ),
        builder: (context, child) {
          return Theme(
            data: AppTheme.darkTheme.copyWith(
              colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
                primary: AppTheme.accentPrimary,
                surface: AppTheme.secondaryBackground,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime scheduledDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        widget.onScheduleChanged(scheduledDateTime);
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year + 543; // Convert to Buddhist Era
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year เวลา $hour:$minute น.';
  }

  List<Map<String, dynamic>> _getQuickScheduleOptions() {
    final now = DateTime.now();
    return [
      {
        'label': 'ใน 1 ชั่วโมง',
        'dateTime': now.add(Duration(hours: 1)),
        'icon': 'schedule',
      },
      {
        'label': 'พรุ่งนี้ 9:00',
        'dateTime': DateTime(now.year, now.month, now.day + 1, 9, 0),
        'icon': 'wb_sunny',
      },
      {
        'label': 'พรุ่งนี้ 12:00',
        'dateTime': DateTime(now.year, now.month, now.day + 1, 12, 0),
        'icon': 'lunch_dining',
      },
      {
        'label': 'พรุ่งนี้ 19:00',
        'dateTime': DateTime(now.year, now.month, now.day + 1, 19, 0),
        'icon': 'dinner_dining',
      },
    ];
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
                iconName: 'schedule',
                color: AppTheme.accentPrimary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'กำหนดการโพสต์',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Post Now vs Schedule Toggle
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isScheduled = false;
                    });
                    widget.onScheduleChanged(null);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: !_isScheduled
                          ? AppTheme.accentPrimary
                          : AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_isScheduled
                            ? AppTheme.accentPrimary
                            : AppTheme.borderSubtle,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'send',
                          color: !_isScheduled
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'โพสต์ทันที',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: !_isScheduled
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontWeight: !_isScheduled
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isScheduled = true;
                    });
                    if (widget.scheduledDateTime == null) {
                      _selectDateTime();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _isScheduled
                          ? AppTheme.accentPrimary
                          : AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isScheduled
                            ? AppTheme.accentPrimary
                            : AppTheme.borderSubtle,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule_send',
                          color: _isScheduled
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'กำหนดเวลา',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: _isScheduled
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontWeight: _isScheduled
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (_isScheduled) ...[
            SizedBox(height: 3.h),

            // Current scheduled time display
            if (widget.scheduledDateTime != null)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'event',
                      color: AppTheme.accentPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'กำหนดโพสต์',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.accentPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _formatDateTime(widget.scheduledDateTime!),
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectDateTime,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.textPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 3.h),

            // Quick schedule options
            Text(
              'ตัวเลือกด่วน',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),

            Column(
              children: _getQuickScheduleOptions().map((option) {
                return GestureDetector(
                  onTap: () {
                    widget.onScheduleChanged(option['dateTime']);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.h),
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
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryBackground,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomIconWidget(
                            iconName: option['icon'],
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['label'],
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _formatDateTime(option['dateTime']),
                                style: AppTheme.darkTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color: AppTheme.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Custom date/time button
            GestureDetector(
              onTap: _selectDateTime,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentPrimary,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'date_range',
                      color: AppTheme.accentPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'เลือกวันและเวลาเอง',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
