import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/billing_history_card.dart';
import './widgets/current_plan_card.dart';
import './widgets/payment_method_card.dart';
import './widgets/plan_comparison_card.dart';

class SubscriptionManagement extends StatefulWidget {
  const SubscriptionManagement({Key? key}) : super(key: key);

  @override
  State<SubscriptionManagement> createState() => _SubscriptionManagementState();
}

class _SubscriptionManagementState extends State<SubscriptionManagement> {
  bool _isLoading = false;

  // Mock data for current subscription
  final Map<String, dynamic> _currentPlan = {
    "id": "premium_monthly",
    "name": "แผนพรีเมียม",
    "price": "299",
    "cycle": "เดือน",
    "nextPayment": "31/08/2025",
    "autoRenewal": true,
    "features": [
      "AI สร้างเนื้อหาไม่จำกัด",
      "วิเคราะห์ข้อมูลขั้นสูง",
      "จัดตารางโพสต์ไม่จำกัด",
      "การสนับสนุนลำดับความสำคัญ",
      "ความร่วมมือของทีม",
      "รายงานการส่งออก",
      "การจัดการหลายบัญชี",
      "การแจ้งเตือนแบบเรียลไทม์"
    ]
  };

  // Mock data for plan comparison
  final Map<String, dynamic> _freePlan = {
    "id": "free",
    "name": "แผนฟรี",
    "price": "0",
    "features": [
      "โพสต์พื้นฐาน 5 โพสต์/เดือน",
      "วิเคราะห์ข้อมูลพื้นฐาน",
      "เชื่อมต่อ 2 แพลตฟอร์ม",
      "การสนับสนุนชุมชน"
    ]
  };

  final Map<String, dynamic> _premiumPlan = {
    "id": "premium",
    "name": "แผนพรีเมียม",
    "price": "299",
    "features": [
      "AI สร้างเนื้อหาไม่จำกัด",
      "วิเคราะห์ข้อมูลขั้นสูง",
      "จัดตารางโพสต์ไม่จำกัด",
      "การสนับสนุนลำดับความสำคัญ",
      "ความร่วมมือของทีม",
      "รายงานการส่งออก",
      "การจัดการหลายบัญชี",
      "การแจ้งเตือนแบบเรียลไทม์"
    ]
  };

  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "card_1",
      "type": "Visa",
      "name": "Visa •••• 4242",
      "details": "หมดอายุ 12/26",
      "isDefault": true
    },
    {
      "id": "card_2",
      "type": "MasterCard",
      "name": "MasterCard •••• 8888",
      "details": "หมดอายุ 08/25",
      "isDefault": false
    }
  ];

  // Mock data for billing history
  final List<Map<String, dynamic>> _billingHistory = [
    {
      "id": "txn_001",
      "description": "แผนพรีเมียม - สิงหาคม 2024",
      "amount": "299.00",
      "date": "01/08/2024",
      "status": "completed",
      "paymentMethod": "Visa •••• 4242"
    },
    {
      "id": "txn_002",
      "description": "แผนพรีเมียม - กรกฎาคม 2024",
      "amount": "299.00",
      "date": "01/07/2024",
      "status": "completed",
      "paymentMethod": "Visa •••• 4242"
    },
    {
      "id": "txn_003",
      "description": "แผนพรีเมียม - มิถุนายน 2024",
      "amount": "299.00",
      "date": "01/06/2024",
      "status": "completed",
      "paymentMethod": "MasterCard •••• 8888"
    },
    {
      "id": "txn_004",
      "description": "แผนพรีเมียม - พฤษภาคม 2024",
      "amount": "299.00",
      "date": "01/05/2024",
      "status": "pending",
      "paymentMethod": "Visa •••• 4242"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การจัดการสมาชิก',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'รอบการเรียกเก็บเงิน: รายเดือน',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showSecurityInfo,
          icon: CustomIconWidget(
            iconName: 'security',
            color: AppTheme.success,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accentPrimary,
          ),
          SizedBox(height: 2.h),
          Text(
            'กำลังโหลดข้อมูลสมาชิก...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          CurrentPlanCard(
            currentPlan: _currentPlan,
            onAutoRenewalToggle: _handleAutoRenewalToggle,
          ),
          PlanComparisonCard(
            freePlan: _freePlan,
            premiumPlan: _premiumPlan,
            onPlanSelect: _handlePlanSelect,
          ),
          PaymentMethodCard(
            paymentMethods: _paymentMethods,
            onAddPaymentMethod: _handleAddPaymentMethod,
            onRemovePaymentMethod: _handleRemovePaymentMethod,
          ),
          BillingHistoryCard(
            billingHistory: _billingHistory,
            onDownloadReceipt: _handleDownloadReceipt,
          ),
          _buildCancellationSection(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildCancellationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'cancel',
                color: AppTheme.error,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'ยกเลิกสมาชิก',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'หากคุณยกเลิกสมาชิก คุณจะยังคงสามารถใช้คุณสมบัติพรีเมียมได้จนถึงวันที่ 31/08/2025',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showCancellationDialog,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(color: AppTheme.error, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ยกเลิกสมาชิก',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAutoRenewalToggle(bool value) {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _currentPlan['autoRenewal'] = value;
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: value
            ? 'เปิดการต่ออายุอัตโนมัติแล้ว'
            : 'ปิดการต่ออายุอัตโนมัติแล้ว',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.success,
        textColor: AppTheme.textPrimary,
      );
    });
  }

  void _handlePlanSelect(String planId) {
    _showUpgradeDialog(planId);
  }

  void _handleAddPaymentMethod(String type) {
    _showAddPaymentMethodDialog(type);
  }

  void _handleRemovePaymentMethod(String methodId) {
    _showRemovePaymentMethodDialog(methodId);
  }

  void _handleDownloadReceipt(String transactionId) {
    setState(() {
      _isLoading = true;
    });

    // Simulate receipt generation and download
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'ดาวน์โหลดใบเสร็จสำเร็จ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.success,
        textColor: AppTheme.textPrimary,
      );
    });
  }

  void _showSecurityInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: AppTheme.success,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'ความปลอดภัย',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityItem('การเข้ารหัส SSL/TLS',
                'ข้อมูลของคุณได้รับการปกป้องด้วยการเข้ารหัสระดับธนาคาร'),
            SizedBox(height: 2.h),
            _buildSecurityItem('PCI DSS Compliant',
                'ระบบชำระเงินปฏิบัติตามมาตรฐานความปลอดภัยสูงสุด'),
            SizedBox(height: 2.h),
            _buildSecurityItem('การสนับสนุน 24/7',
                'ทีมงานพร้อมให้ความช่วยเหลือตลอด 24 ชั่วโมง'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'เข้าใจแล้ว',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: 'check_circle',
          color: AppTheme.success,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(String planId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: 'upgrade',
              color: AppTheme.accentPrimary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'อัปเกรดเป็นแผนพรีเมียม',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'คุณจะได้รับคุณสมบัติพิเศษทั้งหมดทันที\nการเรียกเก็บเงินจะเริ่มในรอบถัดไป',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'ยกเลิก',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processUpgrade(planId);
                    },
                    child: Text(
                      'อัปเกรด',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodDialog(String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'เพิ่มวิธีการชำระเงิน',
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              if (type == 'card') ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'หมายเลขบัตร',
                    hintText: '1234 5678 9012 3456',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'วันหมดอายุ',
                          hintText: 'MM/YY',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'ชื่อบนบัตร',
                    hintText: 'John Doe',
                  ),
                ),
              ] else ...[
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code',
                        color: AppTheme.accentPrimary,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'การชำระเงินผ่าน $type',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'คุณจะถูกนำไปยังหน้าชำระเงินเมื่อมีการเรียกเก็บเงิน',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'ยกเลิก',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _processAddPaymentMethod(type);
                      },
                      child: Text(
                        'เพิ่ม',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemovePaymentMethodDialog(String methodId) {
    final method = _paymentMethods.firstWhere((m) => m['id'] == methodId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'ลบวิธีการชำระเงิน',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'คุณต้องการลบ ${method['name']} หรือไม่?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processRemovePaymentMethod(methodId);
            },
            child: Text(
              'ลบ',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancellationDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: 'sentiment_dissatisfied',
              color: AppTheme.warning,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'ยกเลิกสมาชิก',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'เราเสียใจที่คุณจะไป! กรุณาแจ้งให้เราทราบว่าเหตุใดคุณจึงยกเลิกสมาชิก',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'เหตุผลในการยกเลิก (ไม่บังคับ)',
                hintText: 'แจ้งให้เราทราบเพื่อปรับปรุงบริการ...',
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'กลับไป',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.accentPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processCancellation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error,
                    ),
                    child: Text(
                      'ยกเลิก',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _processUpgrade(String planId) {
    setState(() {
      _isLoading = true;
    });

    // Simulate upgrade process
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'อัปเกรดสำเร็จ! ยินดีต้อนรับสู่แผนพรีเมียม',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.success,
        textColor: AppTheme.textPrimary,
      );
    });
  }

  void _processAddPaymentMethod(String type) {
    setState(() {
      _isLoading = true;
    });

    // Simulate adding payment method
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'เพิ่มวิธีการชำระเงินสำเร็จ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.success,
        textColor: AppTheme.textPrimary,
      );
    });
  }

  void _processRemovePaymentMethod(String methodId) {
    setState(() {
      _paymentMethods.removeWhere((method) => method['id'] == methodId);
    });

    Fluttertoast.showToast(
      msg: 'ลบวิธีการชำระเงินสำเร็จ',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.textPrimary,
    );
  }

  void _processCancellation() {
    setState(() {
      _isLoading = true;
    });

    // Simulate cancellation process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'ยกเลิกสมาชิกสำเร็จ คุณสามารถใช้งานได้จนถึง 31/08/2025',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.warning,
        textColor: AppTheme.textPrimary,
      );
    });
  }
}
