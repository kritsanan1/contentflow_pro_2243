import 'package:flutter/material.dart';
import '../presentation/upload_posts/upload_posts.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/content_calendar/content_calendar.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/subscription_management/subscription_management.dart';
import '../presentation/connect_socials/connect_socials.dart';
import '../presentation/social_dashboard/social_dashboard.dart';
import '../presentation/social_messages/social_messages.dart';
import '../presentation/social_comments/social_comments.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String uploadPosts = '/upload-posts';
  static const String splash = '/splash-screen';
  static const String contentCalendar = '/content-calendar';
  static const String login = '/login-screen';
  static const String subscriptionManagement = '/subscription-management';
  static const String connectSocials = '/connect-socials';
  static const String socialDashboard = '/social-dashboard';
  static const String socialMessages = '/social-messages';
  static const String socialComments = '/social-comments';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    uploadPosts: (context) => const UploadPosts(),
    splash: (context) => const SplashScreen(),
    contentCalendar: (context) => const ContentCalendar(),
    login: (context) => const LoginScreen(),
    subscriptionManagement: (context) => const SubscriptionManagement(),
    connectSocials: (context) => const ConnectSocials(),
    socialDashboard: (context) => const SocialDashboard(),
    socialMessages: (context) => const SocialMessages(),
    socialComments: (context) => const SocialComments(),
    // TODO: Add your other routes here
  };
}