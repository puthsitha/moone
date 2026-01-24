import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    required this.category,
    required this.monthlyBudget,
    required this.remaining,
    required this.remainingPercentage,
    required this.totalExpense,
    super.key,
    this.onPress,
  });

  final VoidCallback? onPress;
  final double remainingPercentage;
  final num remaining;
  final num monthlyBudget;
  final num totalExpense;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final remainingLabel = 100 - (remainingPercentage * 100);
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(Spacing.m),
        child: Column(
          spacing: Spacing.m,
          children: [
            Row(
              spacing: Spacing.m,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomImage(
                    color: category.color,
                    icon: category.icon,
                  ),
                ),
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    return Text(
                      category.categoryTitle(state.selectLanguage.languageCode),
                    );
                  },
                ),
              ],
            ),
            Row(
              spacing: Spacing.l,
              children: [
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
                            remaining >= 0.0
                                ? context.colors.greenPrimary
                                : context.colors.redPrimary,
                          ),
                          strokeWidth: 8,
                        ),
                      ),
                      Align(
                        child: remaining >= 0
                            ? Text(
                                '${remainingLabel.toStringAsFixed(0)}%',
                              )
                            : const Text('--'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.budget,
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            monthlyBudget > 0
                                ? '\$${monthlyBudget.toStringAsFixed(2)}'
                                : '--',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: context.colors.divider,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.expense,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.redPrimary,
                            ),
                          ),
                          Text(
                            '\$${totalExpense.toStringAsFixed(2)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.redPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.remaining,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: remaining >= 0
                                  ? context.colors.greenPrimary
                                  : context.colors.redPrimary,
                            ),
                          ),
                          Text(
                            '\$${remaining.toStringAsFixed(2)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: remaining >= 0
                                  ? context.colors.greenPrimary
                                  : context.colors.redPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
