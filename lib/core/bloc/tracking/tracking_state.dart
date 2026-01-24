part of 'tracking_bloc.dart';

class TrackingState extends Equatable {
  const TrackingState({
    this.expenses = const [],
    this.incomes = const [],
    this.savings = const [],
    this.searchQuery = '',
    this.selectedTypes = const [],
    this.selectedCategories = const [],
  });

  final List<TrackingModel> expenses;
  final List<TrackingModel> incomes;
  final List<TrackingModel> savings;
  final String searchQuery;
  final List<TrackingType> selectedTypes;
  final List<String> selectedCategories;

  List<TrackingModel> get allTrackings => [...expenses, ...incomes, ...savings];

  List<TrackingModel> get filteredTrackings {
    var trackings = allTrackings;

    // Filter by query
    if (searchQuery.isNotEmpty) {
      trackings = trackings
          .where(
            (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Filter by types
    if (selectedTypes.isNotEmpty) {
      trackings = trackings
          .where((t) => selectedTypes.contains(t.type))
          .toList();
    }

    // Filter by categories
    if (selectedCategories.isNotEmpty) {
      trackings = trackings
          .where((t) => selectedCategories.contains(t.category.id))
          .toList();
    }

    return trackings;
  }

  TrackingState copyWith({
    List<TrackingModel>? expenses,
    List<TrackingModel>? incomes,
    List<TrackingModel>? savings,
    String? searchQuery,
    List<TrackingType>? selectedTypes,
    List<String>? selectedCategories,
  }) {
    return TrackingState(
      expenses: expenses ?? this.expenses,
      incomes: incomes ?? this.incomes,
      savings: savings ?? this.savings,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [
    expenses,
    incomes,
    savings,
    searchQuery,
    selectedTypes,
    selectedCategories,
  ];
}
