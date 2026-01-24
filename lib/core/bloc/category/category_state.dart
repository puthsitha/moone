part of 'category_bloc.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.categories = const [],
  });

  final List<CategoryModel> categories;

  CategoryState copyWith({
    List<CategoryModel>? categories,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [categories];
}
