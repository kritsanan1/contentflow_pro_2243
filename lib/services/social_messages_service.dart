import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class SocialMessagesService {
  static SocialMessagesService? _instance;
  static SocialMessagesService get instance =>
      _instance ??= SocialMessagesService._();

  SocialMessagesService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get all messages for the authenticated user
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get messages error: $error');
      return [];
    }
  }

  // Get messages filtered by platform
  Future<List<Map<String, dynamic>>> getMessagesByPlatform(
      String platform) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .eq('platform', platform)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get platform messages error: $error');
      return [];
    }
  }

  // Get messages by status (unread, read, replied, archived)
  Future<List<Map<String, dynamic>>> getMessagesByStatus(String status) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .eq('status', status)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get messages by status error: $error');
      return [];
    }
  }

  // Get unread message count
  Future<int> getUnreadMessageCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('id')
          .eq('profile_id', userId)
          .eq('status', 'unread')
          .count();

      return response.count ?? 0;
    } catch (error) {
      debugPrint('Get unread count error: $error');
      return 0;
    }
  }

  // Search messages
  Future<List<Map<String, dynamic>>> searchMessages(String query) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .or('content.ilike.%$query%,sender_name.ilike.%$query%')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Search messages error: $error');
      return [];
    }
  }

  // Update message status
  Future<bool> updateMessageStatus(String messageId, String status) async {
    try {
      await _client.from('messages').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String()
      }).eq('id', messageId);

      return true;
    } catch (error) {
      debugPrint('Update message status error: $error');
      return false;
    }
  }

  // Mark message as read
  Future<bool> markAsRead(String messageId) async {
    return await updateMessageStatus(messageId, 'read');
  }

  // Mark message as replied
  Future<bool> markAsReplied(String messageId) async {
    return await updateMessageStatus(messageId, 'replied');
  }

  // Archive message
  Future<bool> archiveMessage(String messageId) async {
    return await updateMessageStatus(messageId, 'archived');
  }

  // Get conversation thread
  Future<List<Map<String, dynamic>>> getConversationThread(
      String threadId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .eq('thread_id', threadId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get conversation thread error: $error');
      return [];
    }
  }

  // Send reply to message
  Future<bool> sendReply(
      String threadId, String content, String platform) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client.from('messages').insert({
        'profile_id': userId,
        'thread_id': threadId,
        'content': content,
        'platform': platform,
        'status': 'read',
        'sender_name': 'You',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (error) {
      debugPrint('Send reply error: $error');
      return false;
    }
  }

  // Get priority messages (using AI sentiment analysis simulation)
  Future<List<Map<String, dynamic>>> getPriorityMessages() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('messages')
          .select('*')
          .eq('profile_id', userId)
          .eq('status', 'unread')
          .order('created_at', ascending: false)
          .limit(5);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('Get priority messages error: $error');
      return [];
    }
  }

  // Subscribe to real-time message updates
  RealtimeChannel subscribeToMessages(
      Function(Map<String, dynamic>) onNewMessage) {
    final userId = _client.auth.currentUser?.id;

    return _client
        .channel('user_messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'profile_id',
            value: userId,
          ),
          callback: (payload) {
            onNewMessage(payload.newRecord);
          },
        )
        .subscribe();
  }
}