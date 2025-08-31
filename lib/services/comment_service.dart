import '../core/app_export.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  static final SupabaseClient _client = SupabaseService.instance.client;

  // Fetch comments with filtering and sorting
  static Future<List<dynamic>> getComments({
    String? platformFilter,
    String? sentimentFilter,
    String? statusFilter,
    String? searchKeyword,
    String sortBy = 'created_at',
    bool ascending = false,
    int limit = 50,
  }) async {
    try {
      var query = _client.from('social_comments').select('''
            *,
            posts(title, content),
            connected_accounts(platform, account_name)
          ''');

      // Apply filters
      if (platformFilter != null) {
        query = query.eq('platform', platformFilter);
      }
      if (sentimentFilter != null) {
        query = query.eq('sentiment', sentimentFilter);
      }
      if (statusFilter != null) {
        query = query.eq('moderation_status', statusFilter);
      }
      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        query = query.ilike('content', '%$searchKeyword%');
      }

      final response =
          await query.order(sortBy, ascending: ascending).limit(limit);

      return response;
    } catch (error) {
      throw Exception('Failed to fetch comments: $error');
    }
  }

  // Update comment moderation status
  static Future<void> updateCommentStatus(
      String commentId, String status) async {
    try {
      await _client.from('social_comments').update({
        'moderation_status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', commentId);
    } catch (error) {
      throw Exception('Failed to update comment status: $error');
    }
  }

  // Reply to comment
  static Future<void> replyToComment(
      String commentId, String replyContent) async {
    try {
      await _client.from('social_comments').update({
        'is_replied': true,
        'reply_content': replyContent,
        'replied_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', commentId);
    } catch (error) {
      throw Exception('Failed to reply to comment: $error');
    }
  }

  // Bulk update comments
  static Future<void> bulkUpdateComments(
      List<String> commentIds, String status) async {
    try {
      await _client.from('social_comments').update({
        'moderation_status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).inFilter('id', commentIds);
    } catch (error) {
      throw Exception('Failed to bulk update comments: $error');
    }
  }

  // Get comment statistics
  static Future<Map<String, dynamic>> getCommentStats() async {
    try {
      final totalData =
          await _client.from('social_comments').select('id').count();

      final pendingData = await _client
          .from('social_comments')
          .select('id')
          .eq('moderation_status', 'pending')
          .count();

      final positiveData = await _client
          .from('social_comments')
          .select('id')
          .eq('sentiment', 'positive')
          .count();

      final negativeData = await _client
          .from('social_comments')
          .select('id')
          .eq('sentiment', 'negative')
          .count();

      final spamData = await _client
          .from('social_comments')
          .select('id')
          .eq('sentiment', 'spam')
          .count();

      return {
        'total': totalData.count ?? 0,
        'pending': pendingData.count ?? 0,
        'positive': positiveData.count ?? 0,
        'negative': negativeData.count ?? 0,
        'spam': spamData.count ?? 0,
      };
    } catch (error) {
      throw Exception('Failed to fetch comment statistics: $error');
    }
  }

  // Get comment templates
  static Future<List<dynamic>> getCommentTemplates() async {
    try {
      final response = await _client
          .from('comment_templates')
          .select()
          .eq('is_active', true)
          .order('template_name');

      return response;
    } catch (error) {
      throw Exception('Failed to fetch comment templates: $error');
    }
  }

  // Auto-moderation check
  static Future<void> runAutoModeration(String commentId) async {
    try {
      // Get comment content
      final comment = await _client
          .from('social_comments')
          .select('content')
          .eq('id', commentId)
          .single();

      // Get auto-moderation rules
      final rules = await _client
          .from('auto_moderation_rules')
          .select()
          .eq('is_active', true);

      String content = comment['content'].toString().toLowerCase();
      String newStatus = 'approved'; // Default
      double confidenceScore = 0.5;

      for (var rule in rules) {
        List<dynamic> keywords = rule['keywords'] ?? [];
        bool hasKeyword = keywords.any(
            (keyword) => content.contains(keyword.toString().toLowerCase()));

        if (hasKeyword) {
          newStatus = rule['action'];
          confidenceScore = 0.85; // High confidence for rule match
          break;
        }
      }

      // Update comment with moderation result
      await _client.from('social_comments').update({
        'moderation_status': newStatus,
        'ai_confidence_score': confidenceScore,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', commentId);
    } catch (error) {
      throw Exception('Failed to run auto-moderation: $error');
    }
  }
}