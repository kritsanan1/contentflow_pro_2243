import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentMethodCard extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final Function(String) onAddPaymentMethod;
  final Function(String) onRemovePaymentMethod;

  const PaymentMethodCard({
    Key? key,
    required this.paymentMethods,
    required this.onAddPaymentMethod,
    required this.onRemovePaymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.accentPrimary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'วิธีการชำระเงิน',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (paymentMethods.isEmpty)
            _buildEmptyState()
          else
            ..._buildPaymentMethodsList(),
          SizedBox(height: 3.h),
          _buildAddPaymentButton(),
          SizedBox(height: 2.h),
          _buildLocalPaymentOptions(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'credit_card_off',
            color: AppTheme.textSecondary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'ยังไม่มีวิธีการชำระเงิน',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'เพิ่มบัตรเครดิต/เดบิตหรือเลือกวิธีการชำระเงินอื่น',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentMethodsList() {
    return paymentMethods
        .map((method) => Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: method['isDefault'] == true
                    ? Border.all(
                        color: AppTheme.accentPrimary,
                        width: 2,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: _getCardColor(method['type'] as String),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getCardIcon(method['type'] as String),
                        color: AppTheme.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              method['name'] as String,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (method['isDefault'] == true) ...[
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentPrimary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'หลัก',
                                  style: AppTheme.darkTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          method['details'] as String,
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        onRemovePaymentMethod(method['id'] as String),
                    icon: CustomIconWidget(
                      iconName: 'delete_outline',
                      color: AppTheme.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildAddPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => onAddPaymentMethod('card'),
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.accentPrimary,
          size: 20,
        ),
        label: Text(
          'เพิ่มบัตรเครดิต/เดบิต',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.accentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          side: BorderSide(color: AppTheme.accentPrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLocalPaymentOptions() {
    final localMethods = [
      {
        'name': 'PromptPay',
        'icon': 'qr_code',
        'description': 'สแกน QR Code เพื่อชำระเงิน'
      },
      {
        'name': 'โอนเงินผ่านธนาคาร',
        'icon': 'account_balance',
        'description': 'โอนเงินผ่านแอปธนาคาร'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'วิธีการชำระเงินอื่น ๆ',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...localMethods
            .map((method) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    tileColor: AppTheme.secondaryBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      width: 10.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.accentPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: method['icon'] as String,
                          color: AppTheme.accentPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      method['name'] as String,
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      method['description'] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    onTap: () => onAddPaymentMethod(method['name'] as String),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Color _getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF006FCF);
      default:
        return AppTheme.accentPrimary;
    }
  }

  String _getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
      case 'mastercard':
      case 'amex':
        return 'credit_card';
      default:
        return 'payment';
    }
  }
}
