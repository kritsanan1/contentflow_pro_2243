import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_actions_sheet_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/create_post_modal_widget.dart';
import './widgets/scheduled_post_card_widget.dart';

class ContentCalendar extends StatefulWidget {
  const ContentCalendar({Key? key}) : super(key: key);

  @override
  State<ContentCalendar> createState() => _ContentCalendarState();
}

class _ContentCalendarState extends State<ContentCalendar>
    with TickerProviderStateMixin {
  bool _isWeekView = true;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>> _scheduledPosts = [];
  List<Map<String, dynamic>> _selectedPosts = [];
  bool _isSelectionMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      _isLoading = true;
    });

    // Mock scheduled posts data
    _scheduledPosts = [
      {
        "id": 1,
        "content":
            "เปิดตัวผลิตภัณฑ์ใหม่ล่าสุดของเรา! 🚀 นวัตกรรมที่จะเปลี่ยนแปลงวิธีการทำงานของคุณ พร้อมฟีเจอร์ที่ล้ำสมัยและการออกแบบที่ใช้งานง่าย",
        "image":
            "https://images.unsplash.com/photo-1611224923853-80b023f02d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "platforms": ["Facebook", "Instagram", "Twitter"],
        "scheduledTime": DateTime.now().add(const Duration(hours: 2)),
        "status": "scheduled",
        "engagement": {"likes": 245, "comments": 18},
        "createdAt": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "id": 2,
        "content":
            "Tips สำหรับการเพิ่มประสิทธิภาพในการทำงาน 💡 เรียนรู้เทคนิคง่ายๆ ที่จะช่วยให้คุณทำงานได้อย่างมีประสิทธิภาพมากขึ้น",
        "platforms": ["LinkedIn", "Twitter"],
        "scheduledTime": DateTime.now().add(const Duration(days: 1, hours: 10)),
        "status": "scheduled",
        "createdAt": DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        "id": 3,
        "content":
            "ขอบคุณลูกค้าทุกท่านที่ไว้วางใจในบริการของเรา 🙏 เราจะพัฒนาและปรับปรุงบริการให้ดียิ่งขึ้นเสมอ",
        "image":
            "https://images.unsplash.com/photo-1552664730-d307ca884978?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "platforms": ["Facebook", "Instagram"],
        "scheduledTime": DateTime.now().add(const Duration(days: 2, hours: 14)),
        "status": "scheduled",
        "engagement": {"likes": 189, "comments": 25},
        "createdAt": DateTime.now().subtract(const Duration(hours: 6)),
      },
      {
        "id": 4,
        "content":
            "Workshop ออนไลน์ฟรี! 📚 เรียนรู้เทคนิคการตลาดดิจิทัลที่ทันสมัย พร้อมเคล็ดลับจากผู้เชี่ยวชาญ",
        "platforms": ["Facebook", "LinkedIn"],
        "scheduledTime": DateTime.now().add(const Duration(days: 3, hours: 9)),
        "status": "scheduled",
        "createdAt": DateTime.now().subtract(const Duration(hours: 12)),
      },
      {
        "id": 5,
        "content":
            "สุขสันต์วันศุกร์! 🎉 ขอให้ทุกคนมีสุขภาพแข็งแรงและประสบความสำเร็จในทุกเรื่องที่ตั้งใจไว้",
        "platforms": ["Instagram", "Twitter"],
        "scheduledTime": DateTime.now().subtract(const Duration(hours: 1)),
        "status": "published",
        "engagement": {"likes": 156, "comments": 12},
        "createdAt": DateTime.now().subtract(const Duration(days: 1)),
      },
    ];

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 20,
          ),
        ),
      ),
      title: Text(
        'ปฏิทินเนื้อหา',
        style: AppTheme.darkTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        if (_isSelectionMode) _buildSelectionActions(),
        _buildMenuButton(),
      ],
    );
  }

  Widget _buildSelectionActions() {
    return Row(
      children: [
        GestureDetector(
          onTap: _selectAllPosts,
          child: Container(
            margin: EdgeInsets.only(right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppTheme.accentPrimary,
                width: 1.0,
              ),
            ),
            child: Text(
              'เลือกทั้งหมด',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.accentPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _exitSelectionMode,
          child: Container(
            margin: EdgeInsets.only(right: 3.w),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: _showMenuOptions,
      child: Container(
        margin: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'more_vert',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
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
            'กำลังโหลดปฏิทินเนื้อหา...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppTheme.accentPrimary,
      backgroundColor: AppTheme.secondaryBackground,
      child: Column(
        children: [
          CalendarHeaderWidget(
            isWeekView: _isWeekView,
            onToggleView: _toggleView,
            onTodayPressed: _goToToday,
            currentMonth: _getCurrentMonthText(),
          ),
          Expanded(
            child: CalendarViewWidget(
              isWeekView: _isWeekView,
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              scheduledPosts: _scheduledPosts,
              onDaySelected: _onDaySelected,
              onPageChanged: _onPageChanged,
              onCreatePost: _showCreatePostModal,
              onPostTap: _onPostTap,
              onPostEdit: _onPostEdit,
              onPostDuplicate: _onPostDuplicate,
              onPostDelete: _onPostDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showCreatePostModal(DateTime.now()),
      backgroundColor: AppTheme.accentPrimary,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.textPrimary,
        size: 24,
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _isWeekView = !_isWeekView;
    });
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  String _getCurrentMonthText() {
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

    return '${months[_focusedDay.month - 1]} ${_focusedDay.year + 543}';
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadMockData();
  }

  void _showCreatePostModal(DateTime? preSelectedDateTime) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostModalWidget(
        preSelectedDateTime: preSelectedDateTime,
        onCreatePost: _onCreatePost,
      ),
    );
  }

  void _onCreatePost(Map<String, dynamic> post) {
    setState(() {
      _scheduledPosts.add(post);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('สร้างโพสต์เรียบร้อยแล้ว'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _onPostTap(Map<String, dynamic> post) {
    if (_isSelectionMode) {
      _togglePostSelection(post);
    } else {
      _showPostDetails(post);
    }
  }

  void _onPostEdit(Map<String, dynamic> post) {
    // Navigate to edit post screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดหน้าแก้ไขโพสต์'),
        backgroundColor: AppTheme.accentPrimary,
      ),
    );
  }

  void _onPostDuplicate(Map<String, dynamic> post) {
    final duplicatedPost = Map<String, dynamic>.from(post);
    duplicatedPost['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedPost['scheduledTime'] =
        (post['scheduledTime'] as DateTime).add(const Duration(hours: 1));
    duplicatedPost['status'] = 'scheduled';

    setState(() {
      _scheduledPosts.add(duplicatedPost);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ทำสำเนาโพสต์เรียบร้อยแล้ว'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _onPostDelete(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        title: Text(
          'ยืนยันการลบ',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'คุณต้องการลบโพสต์นี้หรือไม่?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _scheduledPosts.removeWhere((p) => p['id'] == post['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ลบโพสต์เรียบร้อยแล้ว'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: Text(
              'ลบ',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showPostDetails(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'รายละเอียดโพสต์',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ScheduledPostCardWidget(
              post: post,
              onEdit: () {
                Navigator.pop(context);
                _onPostEdit(post);
              },
              onDuplicate: () {
                Navigator.pop(context);
                _onPostDuplicate(post);
              },
              onDelete: () {
                Navigator.pop(context);
                _onPostDelete(post);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _togglePostSelection(Map<String, dynamic> post) {
    setState(() {
      if (_selectedPosts.any((p) => p['id'] == post['id'])) {
        _selectedPosts.removeWhere((p) => p['id'] == post['id']);
        if (_selectedPosts.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedPosts.add(post);
      }
    });

    if (_selectedPosts.isNotEmpty) {
      _showBulkActionsSheet();
    }
  }

  void _selectAllPosts() {
    setState(() {
      _selectedPosts = List.from(_scheduledPosts);
    });
    _showBulkActionsSheet();
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedPosts.clear();
    });
  }

  void _showBulkActionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkActionsSheetWidget(
        selectedPosts: _selectedPosts,
        onReschedule: _bulkReschedule,
        onChangePlatforms: _bulkChangePlatforms,
        onDelete: _bulkDelete,
        onCancel: () {
          Navigator.pop(context);
          _exitSelectionMode();
        },
      ),
    );
  }

  void _bulkReschedule() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดหน้าเปลี่ยนเวลาเผยแพร่'),
        backgroundColor: AppTheme.accentPrimary,
      ),
    );
    _exitSelectionMode();
  }

  void _bulkChangePlatforms() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดหน้าเปลี่ยนแพลตฟอร์ม'),
        backgroundColor: AppTheme.accentPrimary,
      ),
    );
    _exitSelectionMode();
  }

  void _bulkDelete() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBackground,
        title: Text(
          'ยืนยันการลบ',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'คุณต้องการลบโพสต์ที่เลือก ${_selectedPosts.length} รายการหรือไม่?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              final selectedIds = _selectedPosts.map((p) => p['id']).toList();
              setState(() {
                _scheduledPosts
                    .removeWhere((post) => selectedIds.contains(post['id']));
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'ลบโพสต์ ${_selectedPosts.length} รายการเรียบร้อยแล้ว'),
                  backgroundColor: AppTheme.success,
                ),
              );
              _exitSelectionMode();
            },
            child: Text(
              'ลบ',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'checklist',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: Text(
                'เลือกหลายรายการ',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isSelectionMode = true;
                });
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: Text(
                'กรองโพสต์',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เปิดหน้ากรองโพสต์'),
                    backgroundColor: AppTheme.accentPrimary,
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: Text(
                'ตั้งค่าปฏิทิน',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เปิดหน้าตั้งค่าปฏิทิน'),
                    backgroundColor: AppTheme.accentPrimary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
