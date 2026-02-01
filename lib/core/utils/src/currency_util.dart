import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/currency/currency_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/budget_model.dart';
import 'package:monee/core/models/tracking_model.dart';

class CurrencyUtil {
  /// Format currency based on the selected currency type from CurrencyBloc
  /// Returns formatted string:
  /// - USD: $100.23 or $100 (dynamically set decimal digits based on amount)
  /// - KHR: 1,000៛ (no decimals)
  static String caculateFormatCurrency(
    BuildContext context,
    num amount,
  ) {
    final currencyBloc = context.watch<CurrencyBloc>();
    final currencyType = currencyBloc.state.selectCurrency;

    switch (currencyType) {
      case CurrencyType.usd:
        // Check if amount is a whole number (.00)
        final decimalDigits = amount % 1 == 0 ? 0 : 2;
        return NumberFormat.currency(
          symbol: r'$',
          decimalDigits: decimalDigits,
        ).format(amount);
      case CurrencyType.khr:
        return NumberFormat.currency(
          symbol: '៛',
          decimalDigits: 0,
        ).format(amount);
    }
  }

  static String formatCurrency(
    num amount, {
    CurrencyType currencyType = CurrencyType.usd,
  }) {
    switch (currencyType) {
      case CurrencyType.usd:
        // Check if amount is a whole number (.00)
        final decimalDigits = amount % 1 == 0 ? 0 : 2;
        return NumberFormat.currency(
          symbol: r'$',
          decimalDigits: decimalDigits,
        ).format(amount);
      case CurrencyType.khr:
        return NumberFormat.currency(
          symbol: '៛',
          decimalDigits: 0,
        ).format(amount);
    }
  }

  static num currencyAmount(
    BuildContext context, {
    TrackingModel? tracking,
    BudgetModel? budget,
  }) {
    final currencyBloc = context.watch<CurrencyBloc>();
    final currencyType = currencyBloc.state.selectCurrency;
    if (budget != null) {
      final usdAmount = budget.currency.isUsd
          ? budget.budget
          : budget.budget / 4000;
      final khrAmount = budget.currency.isKhr
          ? budget.budget
          : budget.budget * 4000;
      return currencyType.isUsd ? usdAmount : khrAmount;
    }
    if (tracking != null) {
      final usdAmount = tracking.currency.isUsd
          ? tracking.amount
          : tracking.amount / 4000;
      final khrAmount = tracking.currency.isKhr
          ? tracking.amount
          : tracking.amount * 4000;
      return currencyType.isUsd ? usdAmount : khrAmount;
    }
    return 0;
  }
}
