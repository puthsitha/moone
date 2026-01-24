part of 'language_bloc.dart';

@immutable
sealed class LanguageEvent {}

class LanguageAppChange extends LanguageEvent {
  LanguageAppChange({
    required this.locale,
  });
  final Locale locale;
}
