import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_task/core/app/router/app_router.dart';
import 'package:collab_task/core/config/theme/app_theme.dart';
import 'package:collab_task/core/extension/snackbar_extension.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:collab_task/features/auth/presentation/cubit/auth_state.dart';
import 'package:collab_task/features/locale/presentation/cubit/locale_cubit.dart';
import 'package:collab_task/features/shared/widget/global_recovery_listener_widget.dart';
import 'package:collab_task/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:collab_task/l10n/gen/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return BlocSelector<ThemeCubit, ThemeMode, ThemeMode>(
              selector: (state) => state,
              builder: (context, themeMode) {
                debugPrint('locale is $locale');
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Clean Starter',
                  routerConfig: MainRoutes.router,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) {
                    return BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        state.whenOrNull(
                          unauthenticated: () {
                            MainRoutes.router.goNamed(MainRoutes.authName);
                            final snackCtx = navigatorKey.currentContext;
                            if (snackCtx != null) {
                              snackCtx.showSnackbar(
                                AppLocalizations.of(
                                  snackCtx,
                                ).loggedOutSuccessfully,
                              );
                            }
                          },
                        );
                      },
                      child: GlobalNetworkRecoveryListener(child: child!),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
