import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage slideTransitionPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
