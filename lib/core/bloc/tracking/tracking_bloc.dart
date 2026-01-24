import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/services/notification_services.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends HydratedBloc<TrackingEvent, TrackingState> {
  TrackingBloc() : super(const TrackingState()) {
    on<TrackingCreate>(_createTracking);
    on<TrackingUpdate>(_updateTracking);
    on<TrackingDelete>(_deleteTracking);
    on<TrackingSearch>(_searchTracking);
  }

  Future<void> _createTracking(
    TrackingCreate event,
    Emitter<TrackingState> emit,
  ) async {
    final tracking = event.tracking;
    switch (tracking.type) {
      case TrackingType.expense:
        emit(state.copyWith(expenses: [...state.expenses, tracking]));
      case TrackingType.income:
        emit(state.copyWith(incomes: [...state.incomes, tracking]));
      case TrackingType.saving:
        emit(state.copyWith(savings: [...state.savings, tracking]));
        // Schedule daily notifications until end date
        if (tracking.endDate != null) {
          final startDate = DateTime.parse(tracking.date);
          final endDate = DateTime.parse(tracking.endDate!);
          var currentDate = startDate;
          var idOffset = 0;
          while (currentDate.isBefore(endDate) ||
              currentDate.isAtSameMomentAs(endDate)) {
            await NotificationService().scheduleNotification(
              id:
                  (tracking.id.hashCode.abs() + idOffset) %
                  1000000, // Keep ID in valid range
              title:
                  event.context?.l10n.daily_saving_reminder ??
                  'Daily Saving Reminder',
              body:
                  event.context?.l10n.rememeber_for_saving(tracking.title) ??
                  'Remember to save for ${tracking.title}',
              scheduledDate: currentDate,
              payload: tracking.toJson(),
            );
            currentDate = currentDate.add(const Duration(days: 1));
            idOffset++;
          }
        }
    }
  }

  void _updateTracking(TrackingUpdate event, Emitter<TrackingState> emit) {
    final tracking = event.tracking;
    switch (tracking.type) {
      case TrackingType.expense:
        final updatedExpenses = List<TrackingModel>.from(state.expenses);
        final index = updatedExpenses.indexWhere((t) => t.id == tracking.id);
        if (index != -1) {
          updatedExpenses[index] = tracking;
          emit(state.copyWith(expenses: updatedExpenses));
        }
      case TrackingType.income:
        final updatedIncomes = List<TrackingModel>.from(state.incomes);
        final index = updatedIncomes.indexWhere((t) => t.id == tracking.id);
        if (index != -1) {
          updatedIncomes[index] = tracking;
          emit(state.copyWith(incomes: updatedIncomes));
        }
      case TrackingType.saving:
        final updatedSavings = List<TrackingModel>.from(state.savings);
        final index = updatedSavings.indexWhere((t) => t.id == tracking.id);
        if (index != -1) {
          updatedSavings[index] = tracking;
          emit(state.copyWith(savings: updatedSavings));
        }
    }
  }

  void _deleteTracking(TrackingDelete event, Emitter<TrackingState> emit) {
    var expenses = List<TrackingModel>.from(state.expenses);
    var incomes = List<TrackingModel>.from(state.incomes);
    var savings = List<TrackingModel>.from(state.savings);

    if (expenses.any((t) => t.id == event.trackingId)) {
      expenses = expenses.where((t) => t.id != event.trackingId).toList();
    } else if (incomes.any((t) => t.id == event.trackingId)) {
      incomes = incomes.where((t) => t.id != event.trackingId).toList();
    } else if (savings.any((t) => t.id == event.trackingId)) {
      savings = savings.where((t) => t.id != event.trackingId).toList();
    }

    emit(
      state.copyWith(expenses: expenses, incomes: incomes, savings: savings),
    );
  }

  void _searchTracking(TrackingSearch event, Emitter<TrackingState> emit) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        selectedTypes: event.selectedTypes,
        selectedCategories: event.selectedCategories,
      ),
    );
  }

  @override
  TrackingState? fromJson(Map<String, dynamic> json) {
    try {
      final expenses = (json['expenses'] as List<dynamic>)
          .map((e) => TrackingModel.fromJson(e as String))
          .toList();
      final incomes = (json['incomes'] as List<dynamic>)
          .map((e) => TrackingModel.fromJson(e as String))
          .toList();
      final savings = (json['savings'] as List<dynamic>)
          .map((e) => TrackingModel.fromJson(e as String))
          .toList();
      final selectedTypes =
          (json['selectedTypes'] as List<dynamic>?)
              ?.map((e) => TrackingType.fromMap(e as String))
              .toList() ??
          [];
      final selectedCategories =
          (json['selectedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];
      return TrackingState(
        expenses: expenses,
        incomes: incomes,
        savings: savings,
        searchQuery: json['searchQuery'] as String? ?? '',
        selectedTypes: selectedTypes,
        selectedCategories: selectedCategories,
      );
    } on Exception catch (_) {
      return const TrackingState();
    }
  }

  @override
  Map<String, dynamic>? toJson(TrackingState state) {
    return {
      'expenses': state.expenses.map((e) => e.toJson()).toList(),
      'incomes': state.incomes.map((e) => e.toJson()).toList(),
      'savings': state.savings.map((e) => e.toJson()).toList(),
      'searchQuery': state.searchQuery,
      'selectedTypes': state.selectedTypes.map((e) => e.name).toList(),
      'selectedCategories': state.selectedCategories,
    };
  }
}
