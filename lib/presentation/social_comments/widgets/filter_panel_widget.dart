import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterPanelWidget extends StatelessWidget {
  final String currentFilter;
  final String currentSentiment;
  final String currentStatus;
  final String sortBy;
  final bool sortAscending;
  final Function(String, String) onFilterChanged;
  final Function(String, bool) onSortChanged;

  const FilterPanelWidget({
    Key? key,
    required this.currentFilter,
    required this.currentSentiment,
    required this.currentStatus,
    required this.sortBy,
    required this.sortAscending,
    required this.onFilterChanged,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Filter Row 1: Platform and Sentiment
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Platform',
                  currentFilter,
                  [
                    {'label': 'All Platforms', 'value': 'all'},
                    {'label': 'Facebook', 'value': 'facebook'},
                    {'label': 'Instagram', 'value': 'instagram'},
                    {'label': 'Twitter', 'value': 'twitter'},
                    {'label': 'LinkedIn', 'value': 'linkedin'},
                    {'label': 'TikTok', 'value': 'tiktok'},
                    {'label': 'YouTube', 'value': 'youtube'},
                  ],
                  (value) => onFilterChanged('platform', value),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildFilterDropdown(
                  'Sentiment',
                  currentSentiment,
                  [
                    {'label': 'All Sentiments', 'value': 'all'},
                    {'label': 'Positive', 'value': 'positive'},
                    {'label': 'Neutral', 'value': 'neutral'},
                    {'label': 'Negative', 'value': 'negative'},
                    {'label': 'Spam', 'value': 'spam'},
                  ],
                  (value) => onFilterChanged('sentiment', value),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Filter Row 2: Status and Sort
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Status',
                  currentStatus,
                  [
                    {'label': 'All Status', 'value': 'all'},
                    {'label': 'Pending', 'value': 'pending'},
                    {'label': 'Approved', 'value': 'approved'},
                    {'label': 'Hidden', 'value': 'hidden'},
                    {'label': 'Deleted', 'value': 'deleted'},
                    {'label': 'Flagged', 'value': 'flagged'},
                  ],
                  (value) => onFilterChanged('status', value),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSortDropdown(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String currentValue,
    List<Map<String, String>> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, size: 16.sp),
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: const Color(0xFF1A1D29),
              ),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option['value']!,
                  child: Text(
                    option['label']!,
                    style: GoogleFonts.inter(fontSize: 13.sp),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: sortBy,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, size: 16.sp),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF1A1D29),
                    ),
                    items: [
                      {'label': 'Date', 'value': 'created_at'},
                      {'label': 'Sentiment', 'value': 'sentiment'},
                      {'label': 'Platform', 'value': 'platform'},
                      {'label': 'Engagement', 'value': 'engagement_count'},
                      {'label': 'Likes', 'value': 'likes_count'},
                    ].map((option) {
                      return DropdownMenuItem<String>(
                        value: option['value']!,
                        child: Text(
                          option['label']!,
                          style: GoogleFonts.inter(fontSize: 13.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        onSortChanged(newValue, sortAscending);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () => onSortChanged(sortBy, !sortAscending),
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3192).withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF2E3192).withAlpha(77),
                    ),
                  ),
                  child: Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14.sp,
                    color: const Color(0xFF2E3192),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}