import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/enums/src/theme_color.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeAppChange>(
      (event, emit) => changeTheme(
        event,
        emit,
        theme: event.theme,
      ),
    );
  }

  Future<void> changeTheme(
    ThemeEvent event,
    Emitter<ThemeState> emit, {
    required ThemeColor theme,
  }) async {
    emit(
      state.copyWith(
        selectTheme: theme,
      ),
    );
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final theme = ThemeColor.values.byName(
        json['themeColor'] as String,
      );
      return ThemeState(selectTheme: theme);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error deserializing state: $e');
      }
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'themeColor': state.selectTheme.name,
    };
  }
}
