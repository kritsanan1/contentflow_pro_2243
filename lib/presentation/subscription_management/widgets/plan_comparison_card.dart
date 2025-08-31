import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PlanComparisonCard extends StatefulWidget {
  final Map<String, dynamic> freePlan;
  final Map<String, dynamic> premiumPlan;
  final Function(String) onPlanSelect;

  const PlanComparisonCard({
    Key? key,
    required this.freePlan,
    required this.premiumPlan,
    required this.onPlanSelect,
  }) : super(key: key);

  @override
  State<PlanComparisonCard> createState() => _PlanComparisonCardState();
}

class _PlanComparisonCardState extends State<PlanComparisonCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'compare_arrows',
                    color: AppTheme.accentPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'เปรียบเทียบแผน',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? _buildComparisonContent()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
      child: Column(
        children: [
          Container(
            height: 1,
            color: AppTheme.borderSubtle,
            margin: EdgeInsets.only(bottom: 3.h),
          ),
          Row(
            children: [
              Expanded(
                child: _buildPlanColumn(
                  title: 'แผนฟรี',
                  price: '฿0',
                  cycle: '/เดือน',
                  features: widget.freePlan['features'] as List<String>,
                  buttonText: 'แผนปัจจุบัน',
                  buttonColor: AppTheme.borderSubtle,
                  isCurrentPlan: true,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildPlanColumn(
                  title: 'แผนพรีเมียม',
                  price: '฿${widget.premiumPlan['price']}',
                  cycle: '/เดือน',
                  features: widget.premiumPlan['features'] as List<String>,
                  buttonText: 'อัปเกรด',
                  buttonColor: AppTheme.accentPrimary,
                  isCurrentPlan: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanColumn({
    required String title,
    required String price,
    required String cycle,
    required List<String> features,
    required String buttonText,
    required Color buttonColor,
    required bool isCurrentPlan,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentPlan
            ? null
            : Border.all(
                color: AppTheme.accentPrimary.withValues(alpha: 0.3),
                width: 1,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: isCurrentPlan
                      ? AppTheme.textSecondary
                      : AppTheme.accentPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                cycle,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...features
              .take(4)
              .map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName:
                              isCurrentPlan && features.indexOf(feature) > 2
                                  ? 'close'
                                  : 'check',
                          color: isCurrentPlan && features.indexOf(feature) > 2
                              ? AppTheme.error
                              : AppTheme.success,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isCurrentPlan ? null : () => widget.onPlanSelect('premium'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                disabledBackgroundColor: AppTheme.borderSubtle,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: isCurrentPlan
                      ? AppTheme.textSecondary
                      : AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
