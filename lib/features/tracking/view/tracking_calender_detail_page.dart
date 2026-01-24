import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class TrackingCalenderDetailPage extends StatelessWidget {
  const TrackingCalenderDetailPage({required this.date, super.key});

  final String date;

  static MaterialPage<void> page({required String date, Key? key}) =>
      MaterialPage<void>(
        child: TrackingCalenderDetailPage(
          key: key,
          date: date,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TrackingCalenderDetailView(date: date);
  }
}

class TrackingCalenderDetailView extends StatelessWidget {
  const TrackingCalenderDetailView({required this.date, super.key});

  final String date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedDate = DateTime.parse(date);
    final formattedDate = DateFormat.yMMMMd().format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          final trackings = state.allTrackings.where((tracking) {
            try {
              final trackingDate = DateTime.parse(tracking.date);
              return trackingDate.year == selectedDate.year &&
                  trackingDate.month == selectedDate.month &&
                  trackingDate.day == selectedDate.day;
            } on Exception catch (_) {
              return false;
            }
          }).toList();

          const initValue = 0.0;
          final totalExpense = trackings
              .where((t) => t.type == TrackingType.expense)
              .fold(initValue, (sum, t) => sum + t.amount);
          final totalIncome = trackings
              .where((t) => t.type == TrackingType.income)
              .fold(initValue, (sum, t) => sum + t.amount);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          context.l10n.total_expense,
                          style: context.textTheme.headlineMedium?.copyWith(
                            color: context.colors.redPrimary,
                          ),
                        ),
                        Text(
                          '\$${totalExpense.toStringAsFixed(2)}',
                          style: context.textTheme.headlineMedium?.copyWith(
                            color: context.colors.redPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          l10n.total_icome,
                          style: context.textTheme.headlineMedium?.copyWith(
                            color: context.colors.greenPrimary,
                          ),
                        ),
                        Text(
                          '\$${totalIncome.toStringAsFixed(2)}',
                          style: context.textTheme.headlineMedium?.copyWith(
                            color: context.colors.greenPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                  itemCount: trackings.length,
                  itemBuilder: (context, index) {
                    final tracking = trackings[index];
                    return TrackingItem(tracking: tracking);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed(Pages.tracking.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
