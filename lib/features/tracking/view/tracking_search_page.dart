import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/category/category_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/theme/theme.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class TrackingSearchPage extends StatelessWidget {
  const TrackingSearchPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: TrackingSearchPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const TrackingSearchView();
  }
}

class TrackingSearchView extends StatefulWidget {
  const TrackingSearchView({super.key});

  @override
  State<TrackingSearchView> createState() => _TrackingSearchViewState();
}

class _TrackingSearchViewState extends State<TrackingSearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<TrackingType> _selectedTypes = [];
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<TrackingBloc>().add(
      TrackingSearch(
        query: _searchController.text,
        selectedTypes: _selectedTypes,
        selectedCategories: _selectedCategories,
      ),
    );
  }

  Future<void> _showFilterBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.7;

        return SizedBox(
          height: height,
          child: FilterBottomSheet(
            selectedTypes: _selectedTypes,
            selectedCategories: _selectedCategories,
            onApply: (types, categories) {
              setState(() {
                _selectedTypes = types;
                _selectedCategories = categories;
              });
              _onSearchChanged();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.search_by_title,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TrackingBloc, TrackingState>(
              builder: (context, state) {
                final filteredTrackings = state.filteredTrackings;
                if (filteredTrackings.isEmpty) {
                  return Center(
                    child: Text(l10n.no_tracking_found),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                  itemCount: filteredTrackings.length,
                  itemBuilder: (context, index) {
                    final tracking = filteredTrackings[index];
                    return TrackingItem(tracking: tracking);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    required this.selectedTypes,
    required this.selectedCategories,
    required this.onApply,
    super.key,
  });

  final List<TrackingType> selectedTypes;
  final List<String> selectedCategories;
  final void Function(List<TrackingType>, List<String>) onApply;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<TrackingType> _tempSelectedTypes;
  late List<String> _tempSelectedCategories;

  @override
  void initState() {
    super.initState();
    _tempSelectedTypes = List.from(widget.selectedTypes);
    _tempSelectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.normal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.filter,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.type,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8,
              children: TrackingType.values.map((type) {
                final isSelected = _tempSelectedTypes.contains(type);
                return FilterChip(
                  label: Text(
                    type.name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _tempSelectedTypes.add(type);
                      } else {
                        _tempSelectedTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 8,
                  children: state.categories.map((category) {
                    final isSelected = _tempSelectedCategories.contains(
                      category.id,
                    );
                    return FilterChip(
                      label: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return Text(
                            category.categoryTitle(
                              state.selectLanguage.languageCode,
                            ),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.pureWhite,
                            ),
                          );
                        },
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _tempSelectedCategories.add(category.id);
                          } else {
                            _tempSelectedCategories.remove(category.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.redPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => widget.onApply(
                    _tempSelectedTypes,
                    _tempSelectedCategories,
                  ),
                  child: Text(
                    l10n.apply,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
