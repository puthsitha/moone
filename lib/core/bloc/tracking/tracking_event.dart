part of 'tracking_bloc.dart';

sealed class TrackingEvent {}

class TrackingCreate extends TrackingEvent {
  TrackingCreate({
    required this.tracking,
    this.context,
  });
  final TrackingModel tracking;
  final BuildContext? context;
}

class TrackingUpdate extends TrackingEvent {
  TrackingUpdate({
    required this.tracking,
  });
  final TrackingModel tracking;
}

class TrackingDelete extends TrackingEvent {
  TrackingDelete({
    required this.trackingId,
  });
  final String trackingId;
}

class TrackingSearch extends TrackingEvent {
  TrackingSearch({
    this.query = '',
    this.selectedTypes = const [],
    this.selectedCategories = const [],
  });

  final String query;
  final List<TrackingType> selectedTypes;
  final List<String> selectedCategories; // category ids
}
