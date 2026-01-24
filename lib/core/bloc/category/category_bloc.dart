import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/common/common.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends HydratedBloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<CategoryCreate>(_createCategory);
    on<CategoryUpdate>(_updateCategory);
    on<CategoryDelete>(_deleteCategory);
    on<CategoryReorder>(_reorderCategories);
    on<CategoryInitialize>(_onInitialize);
  }

  void _onInitialize(
    CategoryInitialize event,
    Emitter<CategoryState> emit,
  ) {
    final expenseCategories = {
      'food': 'assets/images/categories/food_drink/fruit.png',
      'shopping': 'assets/images/categories/shopping/shopping_basket.png',
      'phone': 'assets/images/categories/other/iphone.png',
      'entertainment': 'assets/images/categories/entertainment/cenima.png',
      'education': 'assets/images/categories/education/book.png',
      'beauty': 'assets/images/categories/life/barber_salon.png',
      'sports': 'assets/images/categories/sport/sport.png',
      'transportation': 'assets/images/categories/other/gas.png',
      'clothing': 'assets/images/categories/shopping/t_shirt.png',
      'car': 'assets/images/categories/other/car.png',
      'electronics': 'assets/images/categories/other/earphones.png',
      'travel': 'assets/images/categories/travel/airport.png',
      'health': 'assets/images/categories/health_care/hospital.png',
      'pets': 'assets/images/categories/other/glass.png',
      'housing': 'assets/images/categories/life/rent_room.png',
      'gifts': 'assets/images/categories/other/backpack.png',
      'donations': 'assets/images/categories/finance/money.png',
      'snacks': 'assets/images/categories/food_drink/bread.png',
      'fruits': 'assets/images/categories/food_drink/apple.png',
    };

    final incomeCategories = {
      'salary': 'assets/images/categories/finance/money.png',
      'investment': 'assets/images/categories/finance/profit.png',
      'part-time': 'assets/images/categories/other/watch.png',
      'bonus': 'assets/images/categories/finance/pay.png',
    };

    final defaultCategories = [
      ...expenseCategories.entries.map((entry) {
        final name = entry.key;
        final icon = entry.value;
        return CategoryModel(
          id: name,
          titleEn: name[0].toUpperCase() + name.substring(1),
          titleKm: _getKhmerTitle(name),
          color:
              prettyGradients[expenseCategories.keys.toList().indexOf(name) %
                  prettyGradients.length],
          icon: icon,
        );
      }),
      ...incomeCategories.entries.map((entry) {
        final name = entry.key;
        final icon = entry.value;
        return CategoryModel(
          id: name,
          titleEn: name[0].toUpperCase() + name.substring(1),
          titleKm: _getKhmerTitle(name),
          color:
              prettyGradients[(expenseCategories.length +
                      incomeCategories.keys.toList().indexOf(name)) %
                  prettyGradients.length],
          icon: icon,
          type: TrackingType.income,
        );
      }),
    ];

    // Merge existing categories with defaults, adding only missing ones
    final existingCategories = List<CategoryModel>.from(state.categories);
    for (final defaultCat in defaultCategories) {
      if (!existingCategories.any((c) => c.id == defaultCat.id)) {
        existingCategories.add(defaultCat);
      }
    }

    emit(CategoryState(categories: existingCategories));
  }

  void _createCategory(CategoryCreate event, Emitter<CategoryState> emit) {
    final updatedCategories = List<CategoryModel>.from(state.categories)
      ..add(event.category);
    emit(state.copyWith(categories: updatedCategories));
  }

  void _updateCategory(CategoryUpdate event, Emitter<CategoryState> emit) {
    final updatedCategories = List<CategoryModel>.from(state.categories);
    final index = updatedCategories.indexWhere(
      (c) => c.id == event.category.id,
    );
    if (index != -1) {
      updatedCategories[index] = event.category;
      emit(state.copyWith(categories: updatedCategories));
    }
  }

  void _deleteCategory(CategoryDelete event, Emitter<CategoryState> emit) {
    final updatedCategories = state.categories
        .where((c) => c.id != event.categoryId)
        .toList();
    emit(state.copyWith(categories: updatedCategories));
  }

  void _reorderCategories(CategoryReorder event, Emitter<CategoryState> emit) {
    emit(state.copyWith(categories: event.categories));
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) {
    try {
      final categories = (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as String))
          .toList();
      return CategoryState(categories: categories);
    } on Exception catch (_) {
      return const CategoryState();
    }
  }

  @override
  Map<String, dynamic>? toJson(CategoryState state) {
    return {
      'categories': state.categories.map((e) => e.toJson()).toList(),
    };
  }

  String _getKhmerTitle(String name) {
    const khmerTitles = {
      'food': 'អាហារ',
      'shopping': 'ការទិញទំនិញ',
      'phone': 'ទូរស័ព្ទ',
      'entertainment': 'ការកំសាន្ត',
      'education': 'ការអប់រំ',
      'beauty': 'សម្រស់',
      'sports': 'កីឡា',
      'transportation': 'ការដឹកជញ្ជូន',
      'clothing': 'សម្លៀកបំពាក់',
      'car': 'រថយន្ត',
      'electronics': 'អេឡិចត្រូនិច',
      'travel': 'ការធ្វើដំណើរ',
      'health': 'សុខភាព',
      'pets': 'សត្វចិញ្ចឹម',
      'housing': 'លំនៅឋាន',
      'gifts': 'អំណោយ',
      'donations': 'ការបរិច្ចាគ',
      'snacks': 'ម្ហូបអាហារ',
      'fruits': 'ផ្លែឈើ',
      'salary': 'ប្រាក់ខែ',
      'investment': 'ការវិនិយោគ',
      'part-time': 'ការងាក្រៅម៉ោង',
      'bonus': 'ប្រាក់បន្ថែម',
    };
    return khmerTitles[name] ?? name;
  }
}
