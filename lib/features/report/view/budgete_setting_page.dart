import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/budget/budget_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/extensions/src/build_context_ext.dart';
import 'package:monee/core/models/budget_model.dart';
import 'package:monee/l10n/l10n.dart';

class BudgeteSettingPage extends StatelessWidget {
  const BudgeteSettingPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: BudgeteSettingPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const BudgetSettingView();
  }
}

class BudgetSettingView extends StatelessWidget {
  const BudgetSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budget_setting),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state.budgets.isEmpty) {
            return Center(
              child: Text(l10n.no_budget_available),
            );
          }
          return ListView.builder(
            itemCount: state.budgets.length,
            itemBuilder: (context, index) {
              final budget = state.budgets[index];
              return ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: budget.budget > 0 ? context.colors.redPrimary : null,
                  ),
                  onPressed: budget.budget > 0
                      ? () async {
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l10n.clear_budget_value),
                              content: BlocBuilder<LanguageBloc, LanguageState>(
                                builder: (context, state) {
                                  return Text.rich(
                                    TextSpan(
                                      text: l10n.are_u_sure_remove_budget_value,
                                      children: [
                                        TextSpan(
                                          text: budget.category.categoryTitle(
                                            state.selectLanguage.languageCode,
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: ' ?'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    context.read<BudgetBloc>().add(
                                      BudgetSetBudget(
                                        categoryId: budget.category.id,
                                        budget: 0,
                                      ),
                                    );
                                    context.pop();
                                  },
                                  child: Text(l10n.remove),
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                ),
                title: BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    return Text(
                      budget.category.categoryTitle(
                        state.selectLanguage.languageCode,
                      ),
                    );
                  },
                ),
                trailing: budget.budget > 0
                    ? Text(
                        NumberFormat.currency(
                          symbol: r'$',
                        ).format(budget.budget),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.edit,
                          ),
                          const Icon(Icons.arrow_right),
                        ],
                      ),
                onTap: () => _showBudgetInputDialog(context, budget),
              );
            },
          );
        },
      ),
    );
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
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.budget_amount,
              hintText: l10n.enter_budget_amount,
            ),
          ),
          actions: [
            TextButton(
              style: FilledButton.styleFrom(
                foregroundColor: context.colors.redPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final value = num.tryParse(controller.text) ?? 0;
                context.read<BudgetBloc>().add(
                  BudgetSetBudget(
                    categoryId: budget.category.id,
                    budget: value,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }
}
