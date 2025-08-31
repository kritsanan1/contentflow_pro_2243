import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class SocialDashboardService {
  static SocialDashboardService? _instance;
  static SocialDashboardService get instance =>
      _instance ??= SocialDashboardService._();

  SocialDashboardService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get dashboard metrics for the authenticated user
  Future<Map<String, dynamic>> getDashboardMetrics() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get today's metrics using parallel queries
      final today = DateTime.now().toIso8601String().split('T')[0];

      final postsData = await _client
          .from('posts')
          .select('id')
          .eq('profile_id', userId)
          .eq('status', 'published')
          .gte('published_at', '${today}T00:00:00Z')
          .count();

      final analyticsData = await _client
          .from('analytics')
          .select('metric_value')
          .eq('profile_id', userId)
          .eq('metric_type', 'engagement_rate')
          .eq('date_recorded', today);

      final followersData = await _client
          .from('connected_accounts')
          .select('follower_count')
          .eq('profile_id', userId)
          .eq('status', 'connected');

      // Calculate engagement rate and follower growth
      final engagementRate = analyticsData.isNotEmpty
          ? analyticsData
                  .map((e) => e['metric_value'] as int)
                  .reduce((a, b) => a + b) /
              analyticsData.length
          : 0.0;

      final totalFollowers = followersData.isNotEmpty
          ? followersData
              .map((e) => e['follower_count'] as int)
              .reduce((a, b) => a + b)
          : 0;

      return {
        'posts_published': postsData.count ?? 0,
        'engagement_rate': engagementRate,
        'follower_growth': totalFollowers,
        'total_followers': totalFollowers,
      };
    } catch (error) {
      debugPrint('Dashboard metrics error: $error');
      return {
        'posts_published': 0,
        'engagement_rate': 0.0,
        'follower_growth': 0,
        'total_followers': 0,
      };
    }
  }

  // Get connected accounts for the user
  Future<List<Map<String, dynamic>>> getConnectedAccounts() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('connected_accounts')
          .select('*')
          .eq('profile_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Connected accounts error: $error');
      return [];
    }
  }

  // Get recent posts performance
  Future<List<Map<String, dynamic>>> getRecentPostsPerformance() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('posts')
          .select('*, connected_accounts!inner(platform, account_name)')
          .eq('profile_id', userId)
          .eq('status', 'published')
          .order('published_at', ascending: false)
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Recent posts error: $error');
      return [];
    }
  }

  // Get activity feed data
  Future<List<Map<String, dynamic>>> getActivityFeed() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get recent analytics data as activity feed
      final response = await _client
          .from('analytics')
          .select('*, connected_accounts!inner(platform, account_name)')
          .eq('profile_id', userId)
          .order('created_at', ascending: false)
          .limit(20);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Activity feed error: $error');
      return [];
    }
  }

  // Get platform-specific metrics
  Future<Map<String, dynamic>> getPlatformMetrics(String platform) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final analyticsData = await _client
          .from('analytics')
          .select(
              'metric_type, metric_value, connected_accounts!inner(platform)')
          .eq('profile_id', userId)
          .eq('connected_accounts.platform', platform)
          .gte(
              'date_recorded',
              DateTime.now()
                  .subtract(Duration(days: 7))
                  .toIso8601String()
                  .split('T')[0]);

      // Group metrics by type
      Map<String, List<int>> groupedMetrics = {};
      for (var item in analyticsData) {
        final metricType = item['metric_type'] as String;
        final metricValue = item['metric_value'] as int;

        groupedMetrics[metricType] ??= [];
        groupedMetrics[metricType]!.add(metricValue);
      }

      // Calculate averages
      Map<String, double> averages = {};
      groupedMetrics.forEach((type, values) {
        averages[type] = values.isEmpty
            ? 0.0
            : values.reduce((a, b) => a + b) / values.length;
      });

      return averages;
    } catch (error) {
      debugPrint('Platform metrics error: $error');
      return {};
    }
  }

  // Subscribe to real-time dashboard updates
  RealtimeChannel subscribeToAnalytics(
      Function(Map<String, dynamic>) onUpdate) {
    return _client
        .channel('dashboard_analytics')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'analytics',
          callback: (payload) async {
            final metrics = await getDashboardMetrics();
            onUpdate(metrics);
          },
        )
        .subscribe();
  }
}