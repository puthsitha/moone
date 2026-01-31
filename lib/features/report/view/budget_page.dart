import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/budget/budget_bloc.dart';
import 'package:monee/core/bloc/currency/currency_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/budget_model.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/theme/theme.dart';
import 'package:monee/core/utils/util.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: BudgetPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const BadgetView();
  }
}

class BadgetView extends StatefulWidget {
  const BadgetView({super.key});

  @override
  State<BadgetView> createState() => _BadgetViewState();
}

class _BadgetViewState extends State<BadgetView> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthYearPickerDialog(initialDate: _selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: Spacing.xs,
              children: [
                Text(
                  _selectedDate.toMonthYear(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.pureWhite,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          return BlocBuilder<TrackingBloc, TrackingState>(
            builder: (context, trackingState) {
              final filteredBudgets = budgetState.budgets
                  .where((b) => b.budget > 0)
                  .skip(1) // Skip the first item
                  .toList();

              final firstBudget = [budgetState.budgets.first];
              final budgetData = <BudgetModel>[
                ...firstBudget,
                ...filteredBudgets,
              ];

              if (budgetData.isEmpty) {
                return Center(
                  child: Text(l10n.no_budget),
                );
              }

              final monthlyTrackings = trackingState.allTrackings.where((
                tracking,
              ) {
                try {
                  final date = DateTime.parse(tracking.date);
                  return date.year == _selectedDate.year &&
                      date.month == _selectedDate.month;
                } on Exception catch (_) {
                  return false;
                }
              }).toList();

              const initValue = 0.0;
              final totalExpense = monthlyTrackings
                  .where((t) => t.type == TrackingType.expense)
                  .fold(initValue, (sum, tracking) {
                    final currencyAmount = CurrencyUtil.currencyAmount(
                      context,
                      tracking: tracking,
                    );
                    return sum + currencyAmount;
                  });

              return ListView.separated(
                separatorBuilder: (context, index) => Container(
                  height: Spacing.normal,
                  color: context.colors.divider,
                ),
                itemCount: budgetData.length,
                itemBuilder: (context, index) {
                  final budget = budgetData[index];
                  final expense = budget.category.id == 'monthly_budget'
                      ? totalExpense
                      : _calculateExpenseForCategory(
                          trackingState.expenses,
                          budget.category.id,
                          _selectedDate,
                        );
                  final budgetAmount = CurrencyUtil.currencyAmount(
                    context,
                    budget: budget,
                  );
                  final remaining = budgetAmount - expense;
                  final percentage = budgetAmount > 0
                      ? (remaining / budgetAmount).clamp(
                          0.0,
                          1.0,
                        )
                      : 1.0;

                  return BudgetItem(
                    category: budget.category,
                    remainingPercentage: percentage,
                    monthlyBudget: budget.budget,
                    remaining: remaining,
                    totalExpense: expense,
                    currencyType: budget.currency,
                    onPress: () => _showBudgetInputDialog(context, budget),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed(Pages.budgetSetting.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  double _calculateExpenseForCategory(
    List<TrackingModel> expenses,
    String categoryId,
    DateTime selectedDate,
  ) {
    if (categoryId == 'monthly_budget') {
      return expenses
          .where((t) => _isInSelectedMonth(t.date, selectedDate))
          .fold(0, (sum, tracking) {
            final currencyAmount = CurrencyUtil.currencyAmount(
              context,
              tracking: tracking,
            );
            return sum + currencyAmount;
          });
    } else {
      return expenses
          .where(
            (t) =>
                t.category.id == categoryId &&
                _isInSelectedMonth(t.date, selectedDate),
          )
          .fold(0, (sum, tracking) {
            final currencyAmount = CurrencyUtil.currencyAmount(
              context,
              tracking: tracking,
            );
            return sum + currencyAmount;
          });
    }
  }

  bool _isInSelectedMonth(String dateStr, DateTime selectedDate) {
    try {
      final date = DateTime.parse(dateStr);
      return date.year == selectedDate.year && date.month == selectedDate.month;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> _showBudgetInputDialog(
    BuildContext context,
    BudgetModel budget,
  ) async {
    final controller = TextEditingController(
      text: budget.budget > 0 ? budget.budget.toString() : '',
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return Text(
                l10n.set_budget_for(
                  budget.category.categoryTitle(
                    state.selectLanguage.languageCode,
                  ),
                ),
              );
            },
          ),
          content: BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, currencyState) {
              final currrencyType =
                  (budget.budget > 0 ? budget.currency : null) ??
                  currencyState.selectCurrency;
              return TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      '${l10n.budget_amount} ${currrencyType.isUsd ? l10n.usd : l10n.khr}',
                  hintText: l10n.enter_budget_amount,
                ),
              );
            },
          ),
          actions: [
            TextButton(
              style: FilledButton.styleFrom(
                foregroundColor: context.colors.redPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
              ),
            ),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currencyState) {
                final currrencyType =
                    (budget.budget > 0 ? budget.currency : null) ??
                    currencyState.selectCurrency;
                return FilledButton(
                  onPressed: () {
                    final value = num.tryParse(controller.text) ?? 0;
                    context.read<BudgetBloc>().add(
                      BudgetSetBudget(
                        categoryId: budget.category.id,
                        budget: value,
                        currencyType: currrencyType,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.save),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
