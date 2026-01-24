import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/budget/budget_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/common/common.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: ReportPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const ReportView();
  }
}

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.report),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, budgetState) {
          return BlocBuilder<TrackingBloc, TrackingState>(
            builder: (context, trackingState) {
              final now = DateTime.now();
              final currentYear = now.year;
              final currentMonth = now.month;

              final monthlyTrackings = trackingState.allTrackings.where((
                tracking,
              ) {
                try {
                  final date = DateTime.parse(tracking.date);
                  return date.year == currentYear && date.month == currentMonth;
                } on Exception catch (_) {
                  return false;
                }
              }).toList();

              const initValue = 0.0;
              final totalExpense = monthlyTrackings
                  .where((t) => t.type == TrackingType.expense)
                  .fold(initValue, (sum, t) => sum + t.amount);
              final totalIncome = monthlyTrackings
                  .where((t) => t.type == TrackingType.income)
                  .fold(initValue, (sum, t) => sum + t.amount);
              final balance = totalIncome - totalExpense;

              // Assuming a monthly budget of $5000 for demonstration
              final monthlyBudget = budgetState.budgets.first.budget;
              final remaining = monthlyBudget - totalExpense;
              final remainingPercentage = (remaining / monthlyBudget).clamp(
                0.0,
                1.0,
              );
              final remainingLabel = 100 - (remainingPercentage * 100);

              return Padding(
                padding: const EdgeInsets.all(Spacing.normal),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await context.pushNamed(Pages.trackingBalance.name);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.normal),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$currentYear',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  DateFormat.MMMM().format(now),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colors.darkShadeGrey60,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  l10n.expense,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colors.redPrimary,
                                      ),
                                ),
                                Text(
                                  '\$${totalExpense.toStringAsFixed(2)}',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colors.redPrimary,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  l10n.income,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colors.greenPrimary,
                                      ),
                                ),
                                Text(
                                  '\$${totalIncome.toStringAsFixed(2)}',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colors.greenPrimary,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  l10n.balance,
                                  style: context.textTheme.titleMedium,
                                ),
                                Text(
                                  '\$${balance.toStringAsFixed(2)}',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: balance >= 0
                                            ? context.colors.greenPrimary
                                            : context.colors.redPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.normal),
                    // Monthly Budget
                    InkWell(
                      onTap: () async {
                        await context.pushNamed(Pages.budget.name);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(Spacing.normal),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            // Circular Progress Indicator
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: remainingLabel,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        remaining >= 0
                                            ? context.colors.greenPrimary
                                            : context.colors.redPrimary,
                                      ),
                                      strokeWidth: 8,
                                    ),
                                  ),
                                  Align(
                                    child: remaining > 0
                                        ? Text(
                                            '${(remainingLabel * 100).toStringAsFixed(0)}%',
                                          )
                                        : const Text('--'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Spacing.normal),
                            // Budget Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${l10n.budget}: \$${monthlyBudget.toStringAsFixed(2)}',
                                    style: context.textTheme.titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Divider(),
                                  Text(
                                    '${l10n.expense}: \$${totalExpense.toStringAsFixed(2)}',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: context.colors.redPrimary,
                                        ),
                                  ),
                                  Text(
                                    '${l10n.remaining}: \$${remaining.toStringAsFixed(2)}',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: remaining >= 0
                                              ? context.colors.greenPrimary
                                              : context.colors.redPrimary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.normal),
                    Container(
                      padding: const EdgeInsets.all(Spacing.l),
                      decoration: BoxDecoration(
                        // color: context.colors.pureWhite,
                        borderRadius: kBorderRadius,
                        border: Border.all(color: Colors.pinkAccent.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.quick_stats,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: Spacing.normal),
                          BlocBuilder<TrackingBloc, TrackingState>(
                            builder: (context, state) {
                              final totalIncome = state.incomes.fold<double>(
                                0,
                                (sum, item) => sum + item.amount,
                              );
                              final totalExpenses = state.expenses.fold<double>(
                                0,
                                (sum, item) => sum + item.amount,
                              );
                              final balance = totalIncome - totalExpenses;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  StatItem(
                                    label: l10n.income,
                                    value: NumberFormat.currency(
                                      symbol: r'$',
                                    ).format(totalIncome),
                                    color: Colors.green,
                                  ),
                                  StatItem(
                                    label: l10n.expenses,
                                    value: NumberFormat.currency(
                                      symbol: r'$',
                                    ).format(totalExpenses),
                                    color: Colors.red,
                                  ),
                                  StatItem(
                                    label: l10n.balance,
                                    value: NumberFormat.currency(
                                      symbol: r'$',
                                    ).format(balance),
                                    color: Colors.blue,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
