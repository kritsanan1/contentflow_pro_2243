import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';
import './scheduled_post_card_widget.dart';

class CalendarViewWidget extends StatelessWidget {
  final bool isWeekView;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<Map<String, dynamic>> scheduledPosts;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final Function(DateTime) onCreatePost;
  final Function(Map<String, dynamic>) onPostTap;
  final Function(Map<String, dynamic>) onPostEdit;
  final Function(Map<String, dynamic>) onPostDuplicate;
  final Function(Map<String, dynamic>) onPostDelete;

  const CalendarViewWidget({
    Key? key,
    required this.isWeekView,
    required this.focusedDay,
    required this.selectedDay,
    required this.scheduledPosts,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onCreatePost,
    required this.onPostTap,
    required this.onPostEdit,
    required this.onPostDuplicate,
    required this.onPostDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        Expanded(
          child: isWeekView ? _buildWeekView() : _buildMonthView(),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderSubtle,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'อา',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'จ',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'อ',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'พ',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'พฤ',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'ศ',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'ส',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCalendarWidget(),
          _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCalendarWidget(),
          SizedBox(height: 2.h),
          _buildSelectedDayPosts(),
        ],
      ),
    );
  }

  Widget _buildCalendarWidget() {
    return Container(
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1.0,
        ),
      ),
      child: TableCalendar<Map<String, dynamic>>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        calendarFormat: isWeekView ? CalendarFormat.week : CalendarFormat.month,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        headerVisible: false,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ) ?? AppTheme.darkTheme.textTheme.bodyMedium!,
          holidayTextStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.error,
          ) ?? AppTheme.darkTheme.textTheme.bodyMedium!,
          defaultTextStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ) ?? AppTheme.darkTheme.textTheme.bodyMedium!,
          selectedTextStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ) ?? AppTheme.darkTheme.textTheme.bodyMedium!,
          todayTextStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ) ?? AppTheme.darkTheme.textTheme.bodyMedium!,
          selectedDecoration: BoxDecoration(
            color: AppTheme.accentPrimary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.accentSecondary,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.success,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          canMarkersOverflow: true,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ) ?? AppTheme.darkTheme.textTheme.bodySmall!,
          weekendStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ) ?? AppTheme.darkTheme.textTheme.bodySmall!,
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (!isWeekView) return const SizedBox.shrink();

    final timeSlots = _generateTimeSlots();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: timeSlots.map((timeSlot) {
          return _buildTimeSlotRow(timeSlot);
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSlotRow(Map<String, dynamic> timeSlot) {
    final time = timeSlot['time'] as String;
    final posts = _getPostsForTimeSlot(timeSlot['dateTime'] as DateTime);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 15.w,
            child: Text(
              time,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onCreatePost(timeSlot['dateTime'] as DateTime),
              child: Container(
                height: 8.h,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: posts.isEmpty
                      ? AppTheme.primaryBackground
                      : AppTheme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppTheme.borderSubtle,
                    width: 1.0,
                  ),
                ),
                child: posts.isEmpty
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : Column(
                        children: posts.map((post) {
                          return ScheduledPostCardWidget(
                            post: post,
                            onTap: () => onPostTap(post),
                            onEdit: () => onPostEdit(post),
                            onDuplicate: () => onPostDuplicate(post),
                            onDelete: () => onPostDelete(post),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayPosts() {
    final dayPosts = _getEventsForDay(selectedDay);

    if (dayPosts.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'event_note',
              color: AppTheme.textSecondary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'ไม่มีโพสต์ที่กำหนดไว้สำหรับวันนี้',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              onPressed: () => onCreatePost(selectedDay),
              child: Text('สร้างโพสต์ใหม่'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              'โพสต์ที่กำหนดไว้ (${dayPosts.length})',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...dayPosts.map((post) {
            return ScheduledPostCardWidget(
              post: post,
              onTap: () => onPostTap(post),
              onEdit: () => onPostEdit(post),
              onDuplicate: () => onPostDuplicate(post),
              onDelete: () => onPostDelete(post),
            );
          }).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return scheduledPosts.where((post) {
      final scheduledTime = post['scheduledTime'] as DateTime?;
      if (scheduledTime == null) return false;
      return isSameDay(scheduledTime, day);
    }).toList();
  }

  List<Map<String, dynamic>> _generateTimeSlots() {
    final slots = <Map<String, dynamic>>[];
    final baseDate = selectedDay;

    for (int hour = 6; hour <= 23; hour++) {
      final dateTime =
          DateTime(baseDate.year, baseDate.month, baseDate.day, hour);
      slots.add({
        'time': '${hour.toString().padLeft(2, '0')}:00',
        'dateTime': dateTime,
      });
    }

    return slots;
  }

  List<Map<String, dynamic>> _getPostsForTimeSlot(DateTime timeSlot) {
    return scheduledPosts.where((post) {
      final scheduledTime = post['scheduledTime'] as DateTime?;
      if (scheduledTime == null) return false;
      return scheduledTime.hour == timeSlot.hour &&
          isSameDay(scheduledTime, timeSlot);
    }).toList();
  }
}