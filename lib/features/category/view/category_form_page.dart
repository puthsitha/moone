import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/category/category_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/common/common.dart' hide Icons;
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/src/build_context_ext.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/utils/util.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class CategoryFormPage extends StatelessWidget {
  const CategoryFormPage({super.key, this.category, this.type});

  final CategoryModel? category;
  final TrackingType? type;

  static MaterialPage<void> page({
    Key? key,
    CategoryModel? category,
    TrackingType? type,
  }) => MaterialPage<void>(
    child: CategoryFormPage(
      key: key,
      category: category,
      type: type,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CategoryBloc>(),
      child: CategoryFormView(
        category: category,
        type: type,
      ),
    );
  }
}

class CategoryFormView extends StatefulWidget {
  const CategoryFormView({super.key, this.category, this.type});

  final CategoryModel? category;
  final TrackingType? type;

  @override
  State<CategoryFormView> createState() => _CategoryFormViewState();
}

class _CategoryFormViewState extends State<CategoryFormView> {
  final TextEditingController _titleControllerEn = TextEditingController();
  final TextEditingController _titleControllerKm = TextEditingController();
  TrackingType _selectedType = TrackingType.expense;
  LinearGradient _selectedGradient = prettyGradients.first;
  String _selectedIcon = CategoriesPath.book;

  @override
  void initState() {
    if (widget.type != null) {
      _selectedType = widget.type!;
    }
    final category = widget.category;
    if (category != null) {
      setState(() {
        _titleControllerEn.text = category.titleEn;
        _titleControllerKm.text = category.titleKm;
        _selectedType = category.type;
        _selectedGradient = category.color;
        _selectedIcon = category.icon;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleControllerEn.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_titleControllerEn.text.trim().isEmpty ||
        _titleControllerKm.text.trim().isEmpty) {
      return;
    }
    final updateCategory = widget.category;
    final category = CategoryModel(
      id: updateCategory != null ? updateCategory.id : const Uuid().v4(),
      type: _selectedType,
      titleEn: _titleControllerEn.text,
      titleKm: _titleControllerKm.text,
      color: _selectedGradient,
      icon: _selectedIcon,
      gradientDirection: gradientDirectionFromLinearGradient(_selectedGradient),
    );
    if (updateCategory != null) {
      context.read<CategoryBloc>().add(CategoryUpdate(category: category));
    } else {
      context.read<CategoryBloc>().add(CategoryCreate(category: category));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUpdate = widget.category != null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isUpdate ? l10n.update_category : l10n.add_categories,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(l10n.expense.toUpperCase()),
            onTap: () {
              setState(() {
                _selectedType = TrackingType.expense;
              });
            },
            trailing: Icon(
              _selectedType == TrackingType.expense
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedType == TrackingType.expense
                  ? context.colors.secondary
                  : context.colors.greyPrimary,
            ),
          ),
          ListTile(
            title: Text(l10n.income.toUpperCase()),
            onTap: () {
              setState(() {
                _selectedType = TrackingType.income;
              });
            },
            trailing: Icon(
              _selectedType == TrackingType.income
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedType == TrackingType.income
                  ? context.colors.secondary
                  : context.colors.greyPrimary,
            ),
          ),
          ListTile(
            title: Text(l10n.saving.toUpperCase()),
            onTap: () {
              setState(() {
                _selectedType = TrackingType.saving;
              });
            },
            trailing: Icon(
              _selectedType == TrackingType.saving
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedType == TrackingType.saving
                  ? context.colors.secondary
                  : context.colors.greyPrimary,
            ),
          ),
          const SizedBox(height: Spacing.m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.normal),
            child: Row(
              spacing: Spacing.m,
              children: [
                CustomImage(
                  color: _selectedGradient,
                  icon: _selectedIcon,
                ),
                Expanded(
                  child: Column(
                    spacing: Spacing.normal,
                    children: [
                      TextField(
                        controller: _titleControllerEn,
                        decoration: InputDecoration(
                          labelText: l10n.category_title_en,
                          hintText: l10n.enter_category_title_en,
                        ),
                      ),
                      TextField(
                        controller: _titleControllerKm,
                        decoration: InputDecoration(
                          labelText: l10n.category_title_km,
                          hintText: l10n.enter_category_title_km,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.normal),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: Spacing.m,
              mainAxisSpacing: Spacing.m,
            ),
            padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
            itemCount: prettyGradients.length,
            itemBuilder: (context, index) {
              final gradient = prettyGradients[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGradient = gradient;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                    shape: BoxShape.circle,
                  ),
                  child: gradient == _selectedGradient
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: context.colors.blueLight,
                          ),
                        )
                      : const SizedBox(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              children: [
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    final categories = state.selectLanguage.languageCode == 'en'
                        ? Categories().categories.entries.toList()
                        : Categories().categoriesKm.entries.toList();
                    return CustomScrollView(
                      slivers: categories.asMap().entries.expand((mapEntry) {
                        final index = mapEntry.key;
                        final entry = mapEntry.value;

                        final title = entry.key;
                        final icons = entry.value;

                        final isLast = index == categories.length - 1;

                        return [
                          SliverPadding(
                            padding: const EdgeInsets.all(Spacing.normal),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                '🏷 ${title.toUpperCase()}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              bottom: Spacing.normal,
                              right: Spacing.normal,
                              left: Spacing.normal,
                            ),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final icon = icons[index];

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIcon = icon;
                                      });
                                    },
                                    child: CustomImage(
                                      color: _selectedIcon == icon
                                          ? _selectedGradient
                                          : null,
                                      icon: icon,
                                    ),
                                  );
                                },
                                childCount: icons.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    mainAxisSpacing: Spacing.m,
                                    crossAxisSpacing: Spacing.m,
                                  ),
                            ),
                          ),

                          if (isLast)
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 100),
                            ),
                        ];
                      }).toList(),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.normal,
                      ),
                      width: double.infinity,
                      child: CustomButton(
                        onPress: _saveCategory,
                        child: Text(
                          isUpdate ? l10n.update : l10n.create,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
