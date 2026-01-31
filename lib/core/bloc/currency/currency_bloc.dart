import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/enums/enum.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends HydratedBloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(const CurrencyState()) {
    on<CurrencyAppChange>(
      _changeCurrency,
    );
  }

  Future<void> _changeCurrency(
    CurrencyAppChange event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(
      state.copyWith(
        selectCurrency: event.currency,
      ),
    );
  }

  @override
  CurrencyState? fromJson(Map<String, dynamic> json) {
    try {
      final currency = CurrencyType.values.byName(
        json['currency'] as String,
      );
      return CurrencyState(selectCurrency: currency);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error deserializing state: $e');
      }
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CurrencyState state) {
    return {
      'currency': state.selectCurrency.name,
    };
  }
}
