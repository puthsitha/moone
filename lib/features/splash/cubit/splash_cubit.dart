import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/routes/routes.dart';

part 'splash_state.dart';

class SplashCubit extends HydratedCubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  void init() {
    final currentState = state;

    if (currentState is SplashInitialized) {
      // Already initialized before
      emit(
        const SplashInitialized(
          initialPage: Pages.app,
          isFirstRun: false,
        ),
      );
      return;
    }

    // First time app opened
    emit(
      const SplashInitialized(
        initialPage: Pages.onboarding,
        isFirstRun: true,
      ),
    );
  }

  // -------------------------------
  // Hydrated overrides
  // -------------------------------
  @override
  SplashState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'initialized') {
        return SplashInitialized.fromMap(json['data'] as Map<String, dynamic>);
      }
      return const SplashInitial();
    } on Exception catch (_) {
      return const SplashInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(SplashState state) {
    if (state is SplashInitialized) {
      return {
        'type': 'initialized',
        'data': state.toMap(),
      };
    }
    return null;
  }
}
