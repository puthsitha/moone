part of 'currency_bloc.dart';

class CurrencyState extends Equatable {
  const CurrencyState({
    this.selectCurrency = CurrencyType.usd,
  });

  final CurrencyType selectCurrency;

  CurrencyState copyWith({
    CurrencyType? selectCurrency,
  }) {
    return CurrencyState(
      selectCurrency: selectCurrency ?? this.selectCurrency,
    );
  }

  @override
  List<Object?> get props => [selectCurrency];
}
