import 'package:go_router/go_router.dart';
import 'package:collab_task/core/app/app.dart';
import 'package:collab_task/core/app/pages/app_error_page.dart';
import 'package:collab_task/core/app/pages/splash_screen.dart';
import 'package:collab_task/core/helper/page_transition_helper.dart';
import 'package:collab_task/core/helper/secure_storage_helper.dart';
import 'package:collab_task/features/auth/presentation/pages/login_screen.dart';
import 'package:collab_task/features/demo/presentation/pages/demo_screen.dart';
import 'package:collab_task/features/dev/presentation/pages/ip_config_screen.dart';

class MainRoutes {
  MainRoutes._();

  static const String splashName = 'splash';
  static const String splashPath = '/';
  static const String ipConfigName = 'ipConfig';
  static const String ipConfigPath = '/ipConfig';
  static const String authName = 'auth';
  static const String authPath = '/auth';
  static const String demoName = 'demo';
  static const String demoPath = '/demo';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splashPath,
    errorBuilder: (context, state) => const AppErrorPage(),
    redirect: (context, state) {
      final loggedIn = SecureStorageHelper().isUserLoggedIn();

      // Splash and dev IP config are reachable without a session.
      if (state.matchedLocation == splashPath ||
          state.matchedLocation == ipConfigPath) {
        return null;
      }

      if (!loggedIn && state.matchedLocation != authPath) {
        return authPath;
      }
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
          child: const DemoScreen(),
        ),
        name: demoName,
        path: demoPath,
      ),
    ],
  );
}
