import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/category/category_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/common/common.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';

import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({required this.type, super.key});

  final TrackingType type;

  static MaterialPage<void> page({
    required TrackingType type,
    Key? key,
  }) => MaterialPage<void>(
    child: TrackingPage(
      key: key,
      type: type,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TrackingView(type: type);
  }
}

class TrackingView extends StatefulWidget {
  const TrackingView({required this.type, super.key});

  final TrackingType type;

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView>
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
  void didUpdateWidget(TrackingView oldWidget) {
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.add_tracking),
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
                CategoriesGridView(
                  type: TrackingType.expense,
                  categories: state.categories,
                ),
                CategoriesGridView(
                  type: TrackingType.income,
                  categories: state.categories,
                ),
                CategoriesGridView(
                  type: TrackingType.saving,
                  categories: state.categories,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoriesGridView extends StatelessWidget {
  const CategoriesGridView({
    required this.categories,
    required this.type,
    super.key,
  });

  final TrackingType type;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((c) => c.type == type).toList();
    final settingsCategory = CategoryModel(
      id: 'settings',
      type: type,
      titleEn: context.l10n.setting_category,
      titleKm: context.l10n.setting_category,
      color: const LinearGradient(colors: [Colors.grey, Colors.black]),
      icon: CategoriesPath.add,
    );
    filteredCategories.insert(0, settingsCategory);

    if (filteredCategories.isEmpty) {
      return Center(
        child: Text(context.l10n.no_type_category(type.name)),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.only(
        top: Spacing.normal,
        left: Spacing.normal,
        right: Spacing.normal,
        bottom: MediaQuery.of(context).padding.bottom + Spacing.normal,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Spacing.m,
        mainAxisSpacing: Spacing.m,
      ),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return CupertinoButton(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          onPressed: () async {
            if (category.id == 'settings') {
              await context.pushNamed(
                Pages.category.name,
                queryParameters: {
                  'type': type.name,
                },
              );
            } else {
              await context.pushNamed(
                Pages.trackingForm.name,
                queryParameters: {'category': category.toJson()},
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImage(
                color: category.color,
                icon: category.icon,
              ),
              const SizedBox(height: Spacing.xs),
              BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  return Text(
                    category.categoryTitle(state.selectLanguage.languageCode),
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
