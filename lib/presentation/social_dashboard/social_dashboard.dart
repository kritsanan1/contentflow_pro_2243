import 'package:flutter/material.dart'; // Add this import for Flutter widgets and types
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/social_dashboard_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_error_widget.dart';
import './widgets/activity_feed_card.dart';
import './widgets/dashboard_header.dart';
import './widgets/dashboard_metrics_card.dart';
import './widgets/platform_overview_card.dart';
import './widgets/quick_actions_fab.dart';
import './widgets/recent_posts_card.dart';
import 'widgets/activity_feed_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_metrics_card.dart';
import 'widgets/platform_overview_card.dart';
import 'widgets/quick_actions_fab.dart';
import 'widgets/recent_posts_card.dart';

class SocialDashboard extends StatefulWidget {
  const SocialDashboard({super.key}); // Fix constructor parameter

  @override
  State<SocialDashboard> createState() => _SocialDashboardState();
}

class _SocialDashboardState extends State<SocialDashboard>
    with TickerProviderStateMixin {
  final SocialDashboardService _dashboardService =
      SocialDashboardService.instance;
  late TabController _tabController;

  Map<String, dynamic> _dashboardMetrics = {};
  List<Map<String, dynamic>> _connectedAccounts = [];
  List<Map<String, dynamic>> _recentPosts = [];
  List<Map<String, dynamic>> _activityFeed = [];

  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final results = await Future.wait([
        _dashboardService.getDashboardMetrics(),
        _dashboardService.getConnectedAccounts(),
        _dashboardService.getRecentPostsPerformance(),
        _dashboardService.getActivityFeed(),
      ]);

      setState(() {
        _dashboardMetrics = results[0] as Map<String, dynamic>;
        _connectedAccounts = results[1] as List<Map<String, dynamic>>;
        _recentPosts = results[2] as List<Map<String, dynamic>>;
        _activityFeed = results[3] as List<Map<String, dynamic>>;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await _loadDashboardData();
  }

  void _navigateToMessages() {
    Navigator.pushNamed(context, AppRoutes.socialMessages);
  }

  void _navigateToContentCalendar() {
    Navigator.pushNamed(context, AppRoutes.contentCalendar);
  }

  void _navigateToUploadPosts() {
    Navigator.pushNamed(context, AppRoutes.uploadPosts);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: Center(
          child: CustomErrorWidget(
            errorDetails: FlutterErrorDetails(
              exception: Exception(_error),
              library: 'Social Dashboard',
              context: ErrorDescription('Failed to load dashboard data'),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: DashboardHeader(
          onNotificationTap: _navigateToMessages,
          onRefresh: _refreshData,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentPrimary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.accentPrimary,
              backgroundColor: AppTheme.secondaryBackground,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Metrics Cards
                    DashboardMetricsCard(
                      metrics: _dashboardMetrics,
                      isRefreshing: _isRefreshing,
                    ),

                    SizedBox(height: 20.h),

                    // Tab Navigation for Different Views
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Posts'),
                          Tab(text: 'Activity'),
                        ],
                        labelColor: AppTheme.accentPrimary,
                        unselectedLabelColor: AppTheme.textSecondary,
                        indicator: BoxDecoration(
                          color: AppTheme.accentPrimary.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Tab Content
                    SizedBox(
                      height: 400.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Overview Tab
                          PlatformOverviewCard(
                            connectedAccounts: _connectedAccounts,
                            onAccountTap: (account) {
                              // Handle account selection for detailed view
                            },
                          ),

                          // Posts Tab
                          RecentPostsCard(
                            posts: _recentPosts,
                            onPostTap: (post) {
                              // Handle post selection for boost/respond
                            },
                          ),

                          // Activity Tab
                          ActivityFeedCard(
                            activities: _activityFeed,
                            onActivityTap: (activity) {
                              // Handle activity item tap
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

      // Quick Action Floating Buttons
      floatingActionButton: QuickActionsFab(
        onCreatePost: _navigateToUploadPosts,
        onViewMessages: _navigateToMessages,
        onViewCalendar: _navigateToContentCalendar,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}