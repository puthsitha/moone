import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/category/category_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({required this.type, super.key});

  final TrackingType type;

  static MaterialPage<void> page({required TrackingType type, Key? key}) =>
      MaterialPage<void>(
        child: CategoryPage(key: key, type: type),
      );

  @override
  Widget build(BuildContext context) {
    return CategoryView(
      type: type,
    );
  }
}

class CategoryView extends StatefulWidget {
  const CategoryView({required this.type, super.key});

  final TrackingType type;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: TrackingType.values.indexOf(widget.type),
    );
  }

  @override
  void didUpdateWidget(CategoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _tabController.animateTo(TrackingType.values.indexOf(widget.type));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.category),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: l10n.expense), // Expense
            Tab(text: l10n.income), // Income
            Tab(text: l10n.saving), // Saving
          ],
        ),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              CategoryList(
                type: TrackingType.expense,
                categories: state.categories,
              ),
              CategoryList(
                type: TrackingType.income,
                categories: state.categories,
              ),
              CategoryList(
                type: TrackingType.saving,
                categories: state.categories,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final currentIndex = _tabController.index;
          final type = TrackingType.values[currentIndex];
          await context.pushNamed(
            Pages.categoryForm.name,
            queryParameters: {'type': type.name},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    required this.type,
    required this.categories,
    super.key,
  });

  final TrackingType type;
  final List<CategoryModel> categories;

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // force user decision
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.delete_category),
          content: Text(
            context.l10n.are_u_sure_delete_category,
          ),
          actions: [
            TextButton(
              style: FilledButton.styleFrom(
                foregroundColor: context.colors.redPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((c) => c.type == type).toList();

    if (filteredCategories.isEmpty) {
      return Center(
        child: Text(
          context.l10n.no_type_category(
            switch (type) {
              TrackingType.expense => context.l10n.expense.toUpperCase(),
              TrackingType.income => context.l10n.income.toUpperCase(),
              TrackingType.saving => context.l10n.saving.toUpperCase(),
            },
          ),
        ),
      );
    }

    return ReorderableListView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + Spacing.l9,
      ),
      itemCount: filteredCategories.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        final reordered = List<CategoryModel>.from(filteredCategories);
        final item = reordered.removeAt(oldIndex);
        reordered.insert(newIndex, item);

        final fullList = List<CategoryModel>.from(categories)
          ..removeWhere((c) => c.type == type);

        final insertIndex = categories.indexWhere((c) => c.type == type);
        fullList.insertAll(insertIndex, reordered);

        context.read<CategoryBloc>().add(
          CategoryReorder(categories: fullList),
        );
      },
      itemBuilder: (context, index) {
        final category = filteredCategories[index];

        return Column(
          key: ValueKey(category.id),
          children: [
            ListTile(
              leading: CustomImage(
                color: category.color,
                icon: category.icon,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: Spacing.sm,
                horizontal: Spacing.m,
              ),
              title: BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  return Text(
                    category.categoryTitle(state.selectLanguage.languageCode),
                    style: context.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await context.pushNamed(
                        Pages.categoryForm.name,
                        queryParameters: {'category': category.toJson()},
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirmed = await _showDeleteConfirmDialog(context);

                      if (confirmed ?? false) {
                        if (context.mounted) {
                          context.read<CategoryBloc>().add(
                            CategoryDelete(categoryId: category.id),
                          );
                        }
                      }
                    },
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: IconButton(
                      icon: const Icon(Icons.drag_handle),
                      onPressed: () {
                        _showToast(
                          context,
                          context.l10n.hold_up_down_drag,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (index != filteredCategories.length - 1)
              const Divider(height: 1),
          ],
        );
      },
    );
  }
}
