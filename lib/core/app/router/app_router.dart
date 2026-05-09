import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/app.dart';
import 'package:collab_task/core/app/pages/app_error_page.dart';
import 'package:collab_task/core/app/pages/splash_screen.dart';
import 'package:collab_task/core/helper/page_transition_helper.dart';
import 'package:collab_task/features/auth/presentation/pages/login_screen.dart';
import 'package:collab_task/features/auth/presentation/pages/register_screen.dart'; 
import 'package:collab_task/features/auth/presentation/pages/forgot_password_screen.dart'; 
import 'package:collab_task/features/auth/presentation/pages/otp_input_screen.dart'; 
import 'package:collab_task/features/auth/presentation/pages/reset_password_screen.dart'; 
import 'package:collab_task/features/dev/presentation/pages/ip_config_screen.dart';
import 'package:collab_task/features/tasks/presentation/pages/task_board_screen.dart';
import 'package:collab_task/features/tasks/presentation/pages/task_detail_screen.dart';
import 'package:collab_task/features/demo/presentation/pages/demo_screen.dart';
import 'package:collab_task/features/chat/presentation/pages/chat_screen.dart';
import 'package:collab_task/features/tasks/presentation/pages/task_discussion_screen.dart';
import 'package:collab_task/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:collab_task/features/settings/presentation/pages/settings_screen.dart';

class MainRoutes {
  MainRoutes._();

  static const String splashName = 'splash';
  static const String splashPath = '/';
  static const String ipConfigName = 'ipConfig';
  static const String ipConfigPath = '/ipConfig';
  static const String authName = 'auth';
  static const String authPath = '/auth';
  static const String registerName = 'register'; 
  static const String registerPath = '/register'; 
  static const String forgotPasswordName = 'forgotPassword'; 
  static const String forgotPasswordPath = '/forgotPassword'; 
  static const String otpInputName = 'otpInput'; 
  static const String otpInputPath = '/otpInput'; 
  static const String resetPasswordName = 'resetPassword'; 
  static const String resetPasswordPath = '/resetPassword'; 
  static const String taskBoardName = 'taskBoard';
  static const String taskBoardPath = '/tasks';
  static const String taskDetailName = 'taskDetail';
  static const String taskDetailPath = '/tasks/:id';
  static const String taskDiscussionName = 'taskDiscussion';
  static const String taskDiscussionPath = '/tasks/:id/discussion';
  static const String notificationName = 'notification';
  static const String notificationPath = '/notification';
  static const String settingsName = 'settings';
  static const String settingsPath = '/settings';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splashPath,
    errorBuilder: (context, state) => const AppErrorPage(),
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const SplashScreen(),
        ),
        name: splashName,
        path: splashPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const IpConfigScreen(),
        ),
        name: ipConfigName,
        path: ipConfigPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const LoginScreen(),
        ),
        name: authName,
        path: authPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const RegisterScreen(),
        ),
        name: registerName,
        path: registerPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
        name: forgotPasswordName,
        path: forgotPasswordPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const OtpInputScreen(),
        ),
        name: otpInputName,
        path: otpInputPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const ResetPasswordScreen(),
        ),
        name: resetPasswordName,
        path: resetPasswordPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const TaskBoardScreen(),
        ),
        name: taskBoardName,
        path: taskBoardPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const DemoScreen(),
        ),
        name: 'demo',
        path: '/demo',
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const ChatScreen(),
        ),
        name: 'chat',
        path: '/chat',
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: TaskDetailScreen(taskId: state.pathParameters['id']!),
        ),
        name: taskDetailName,
        path: taskDetailPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: TaskDiscussionScreen(taskId: state.pathParameters['id']!),
        ),
        name: taskDiscussionName,
        path: taskDiscussionPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const NotificationsScreen(),
        ),
        name: notificationName,
        path: notificationPath,
      ),
      GoRoute(
        pageBuilder: (context, state) => slideTransitionPage<void>(
          state: state,
          child: const SettingsScreen(),
        ),
        name: settingsName,
        path: settingsPath,
      ),
    ],
  );
}
