part of 'budget_bloc.dart';

class BudgetState extends Equatable {
  const BudgetState({
    this.budgets = const [],
  });

  final List<BudgetModel> budgets;

  BudgetState copyWith({
    List<BudgetModel>? budgets,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
    );
  }

  @override
  List<Object?> get props => [budgets];
}
