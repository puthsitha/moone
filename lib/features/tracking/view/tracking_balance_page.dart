import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/theme/theme.dart';
import 'package:monee/core/utils/util.dart';
import 'package:monee/l10n/l10n.dart';

class TrackingBalancePage extends StatelessWidget {
  const TrackingBalancePage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: TrackingBalancePage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const TrackingBalanceView();
  }
}

class TrackingBalanceView extends StatefulWidget {
  const TrackingBalanceView({super.key});

  @override
  State<TrackingBalanceView> createState() => _TrackingBalanceViewState();
}

class _TrackingBalanceViewState extends State<TrackingBalanceView> {
  String _selectedYear = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentYear = DateTime.now().year;
    final years = [
      'all',
      ...List.generate(10, (index) => (currentYear - 9 + index).toString()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: _selectedYear,
          underline: const SizedBox(),
          iconEnabledColor: AppColors.pureWhite,
          dropdownColor: context.colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          borderRadius: BorderRadius.circular(8),
          style: context.textTheme.titleLarge?.copyWith(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w600,
          ),
          alignment: Alignment.center,
          items: years.map((year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(
                year == 'all' ? l10n.all : year,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedYear = value;
              });
            }
          },
        ),
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          final trackings = state.allTrackings;
          final monthlyData = _calculateMonthlyData(trackings, _selectedYear);

          const initValue = 0.0;
          final totalExpense = _selectedYear == 'all'
              ? trackings
                    .where((t) => t.type == TrackingType.expense)
                    .fold(initValue, (sum, t) => sum + t.amount)
              : monthlyData.values.fold(
                  initValue,
                  (sum, data) => sum + data['expense']!,
                );
          final totalIncome = _selectedYear == 'all'
              ? trackings
                    .where((t) => t.type == TrackingType.income)
                    .fold(initValue, (sum, t) => sum + t.amount)
              : monthlyData.values.fold(
                  initValue,
                  (sum, data) => sum + data['income']!,
                );
          final totalBalance = totalIncome - totalExpense;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.normal),
                child: Column(
                  spacing: Spacing.normal,
                  children: [
                    Column(
                      children: [
                        Text(
                          l10n.total_balance,
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: totalBalance >= 0
                                    ? context.colors.greenPrimary
                                    : context.colors.redPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              l10n.total_expense,
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colors.redPrimary,
                              ),
                            ),
                            Text(
                              '\$${totalExpense.toStringAsFixed(2)}',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colors.redPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              l10n.total_icome,
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colors.greenPrimary,
                              ),
                            ),
                            Text(
                              '\$${totalIncome.toStringAsFixed(2)}',
                              style: context.textTheme.titleLarge?.copyWith(
                                color: context.colors.greenPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // List Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.normal,
                  vertical: Spacing.s,
                ),
                color: context.colors.lightShadeGrey30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.month,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.expense,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.income,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.balance,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // List Items
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: monthlyData.length,
                  itemBuilder: (context, index) {
                    final entry = monthlyData.entries.elementAt(index);
                    final year = entry.key.split('-')[0];
                    final month = entry.key.split('-')[1];
                    final data = entry.value;

                    final showYear =
                        _selectedYear == 'all' &&
                        (index == 0 ||
                            monthlyData.entries
                                    .elementAt(index - 1)
                                    .key
                                    .split('-')[0] !=
                                year);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showYear)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            color: context.colors.lightShadeGrey20,
                            width: double.infinity,
                            child: Text(
                              year,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getMonthName(int.tryParse(month) ?? 1, l10n),
                              ),
                              Text(
                                '\$${data['expense']!.toStringAsFixed(2)}',
                              ),
                              Text(
                                '\$${data['income']!.toStringAsFixed(2)}',
                              ),
                              Text(
                                '\$${(data['income']! - data['expense']!).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color:
                                      (data['income']! - data['expense']!) >= 0
                                      ? context.colors.greenPrimary
                                      : context.colors.redPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, Map<String, double>> _calculateMonthlyData(
    List<TrackingModel> trackings,
    String selectedYear,
  ) {
    final monthlyData = <String, Map<String, double>>{};

    for (final tracking in trackings) {
      try {
        final date = DateTime.parse(tracking.date);
        final year = date.year.toString();
        final month = date.month.toString().padLeft(2, '0');
        final key = '$year-$month';

        if (selectedYear != 'all' && year != selectedYear) continue;

        monthlyData[key] ??= {'expense': 0, 'income': 0};
        if (tracking.type == TrackingType.expense) {
          monthlyData[key]!['expense'] =
              monthlyData[key]!['expense']! + tracking.amount;
        } else if (tracking.type == TrackingType.income) {
          monthlyData[key]!['income'] =
              monthlyData[key]!['income']! + tracking.amount;
        }
      } on Exception catch (_) {
        // Skip invalid dates
      }
    }

    // Sort by year and month descending
    final sortedKeys = monthlyData.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final sortedData = Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, monthlyData[key]!)),
    );

    return sortedData;
  }
}
