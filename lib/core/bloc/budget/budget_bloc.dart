import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/common/common.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/budget_model.dart';
import 'package:monee/core/models/category_model.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends HydratedBloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(const BudgetState()) {
    on<BudgetInitialize>(_onInitialize);
    on<BudgetSetBudget>(_setBudget);
    on<BudgetSyncWithCategories>(_syncWithCategories);
  }

  void _onInitialize(
    BudgetInitialize event,
    Emitter<BudgetState> emit,
  ) {
    final firstBudget = [
      BudgetModel(
        id: 'monthly_budget',
        category: CategoryModel(
          id: 'monthly_budget',
          titleEn: 'Monthly Budget',
          titleKm: 'ថវិកាប្រចាំខែ',
          color: prettyGradients.last,
          icon: 'assets/images/categories/finance/money.png',
        ),
      ),
    ];

    // Merge existing budgets with defaults, adding only missing ones
    final existingBudgets = List<BudgetModel>.from(state.budgets);
    for (final defaultBudget in firstBudget) {
      if (!existingBudgets.any((b) => b.id == defaultBudget.id)) {
        existingBudgets.add(defaultBudget);
      }
    }

    emit(BudgetState(budgets: existingBudgets));
  }

  void _syncWithCategories(
    BudgetSyncWithCategories event,
    Emitter<BudgetState> emit,
  ) {
    final expenseCategories = event.categories
        .where((c) => c.type == TrackingType.expense)
        .toList();
    final existingBudgetIds = state.budgets.map((b) => b.category.id).toSet();

    final newBudgets = expenseCategories
        .where((c) => !existingBudgetIds.contains(c.id))
        .map(
          (c) => BudgetModel(
            id: c.id,
            category: c,
          ),
        )
        .toList();

    if (newBudgets.isNotEmpty) {
      final updatedBudgets = [...state.budgets, ...newBudgets];
      emit(BudgetState(budgets: updatedBudgets));
    }
  }

  void _setBudget(
    BudgetSetBudget event,
    Emitter<BudgetState> emit,
  ) {
    final updatedBudgets = state.budgets.map((b) {
      if (b.category.id == event.categoryId) {
        return b.copyWith(budget: event.budget, currency: event.currencyType);
      }
      return b;
    }).toList();

    // If budget for category doesn't exist, create it
    final existingIds = updatedBudgets.map((b) => b.category.id).toSet();
    if (!existingIds.contains(event.categoryId)) {
      // Note: This assumes we have the category, but we don't
      // In practice, this should be handled by sync
    }

    emit(BudgetState(budgets: updatedBudgets));
  }

  @override
  BudgetState? fromJson(Map<String, dynamic> json) {
    try {
      final budgets = (json['budgets'] as List<dynamic>)
          .map((e) => BudgetModel.fromJson(e as String))
          .toList();
      return BudgetState(budgets: budgets);
    } on Exception catch (_) {
      return const BudgetState();
    }
  }

  @override
  Map<String, dynamic>? toJson(BudgetState state) {
    return {
      'budgets': state.budgets.map((e) => e.toJson()).toList(),
    };
  }
}
