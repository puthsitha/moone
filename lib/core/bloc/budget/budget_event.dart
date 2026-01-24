part of 'budget_bloc.dart';

sealed class BudgetEvent {}

class BudgetInitialize extends BudgetEvent {}

class BudgetSetBudget extends BudgetEvent {
  BudgetSetBudget({
    required this.categoryId,
    required this.budget,
  });
  final String categoryId;
  final num budget;
}

class BudgetSyncWithCategories extends BudgetEvent {
  BudgetSyncWithCategories({
    required this.categories,
  });
  final List<CategoryModel> categories;
}
