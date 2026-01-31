part of 'currency_bloc.dart';

@immutable
sealed class CurrencyEvent {}

class CurrencyAppChange extends CurrencyEvent {
  CurrencyAppChange({
    required this.currency,
  });
  final CurrencyType currency;
}
