import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log('Bloc Event: ${bloc.runtimeType}, Event: $event');

    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    log('Bloc Created: ${bloc.runtimeType}');

    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log('Bloc Changed: ${bloc.runtimeType}, Change: $change');

    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log('Bloc Transition: ${bloc.runtimeType}, Transition: $transition');

    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      'Bloc Error: ${bloc.runtimeType}, Error: $error',
      stackTrace: stackTrace,
    );

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    log('Bloc Closed: ${bloc.runtimeType}');
  }
}

