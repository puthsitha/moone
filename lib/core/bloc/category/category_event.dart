part of 'category_bloc.dart';

sealed class CategoryEvent {}

class CategoryInitialize extends CategoryEvent {}

class CategoryCreate extends CategoryEvent {
  CategoryCreate({
    required this.category,
  });
  final CategoryModel category;
}

class CategoryUpdate extends CategoryEvent {
  CategoryUpdate({
    required this.category,
  });
  final CategoryModel category;
}

class CategoryDelete extends CategoryEvent {
  CategoryDelete({
    required this.categoryId,
  });
  final String categoryId;
}

class CategoryReorder extends CategoryEvent {
  CategoryReorder({
    required this.categories,
  });
  final List<CategoryModel> categories;
}
