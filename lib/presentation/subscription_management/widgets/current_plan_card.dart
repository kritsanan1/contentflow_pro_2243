import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CurrentPlanCard extends StatefulWidget {
  final Map<String, dynamic> currentPlan;
  final Function(bool) onAutoRenewalToggle;

  const CurrentPlanCard({
    Key? key,
    required this.currentPlan,
    required this.onAutoRenewalToggle,
  }) : super(key: key);

  @override
  State<CurrentPlanCard> createState() => _CurrentPlanCardState();
}

class _CurrentPlanCardState extends State<CurrentPlanCard> {
  bool _autoRenewal = true;

  @override
  void initState() {
    super.initState();
    _autoRenewal = widget.currentPlan['autoRenewal'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentPrimary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'แผนปัจจุบัน',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.accentPrimary,
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            widget.currentPlan['name'] ?? 'Premium Plan',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '฿${widget.currentPlan['price'] ?? '299'}',
                style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accentPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '/${widget.currentPlan['cycle'] ?? 'เดือน'}',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'วันต่ออายุถัดไป: ${widget.currentPlan['nextPayment'] ?? '31/08/2025'}',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ต่ออายุอัตโนมัติ',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _autoRenewal,
                      onChanged: (value) {
                        setState(() {
                          _autoRenewal = value;
                        });
                        widget.onAutoRenewalToggle(value);
                      },
                      activeColor: AppTheme.accentPrimary,
                      inactiveThumbColor: AppTheme.textSecondary,
                      inactiveTrackColor: AppTheme.borderSubtle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'คุณสมบัติที่รวมอยู่:',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ..._buildFeatureList(),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = widget.currentPlan['features'] as List<String>? ?? [];
    return features
        .map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.success,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
