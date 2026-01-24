import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/utils/util.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: RecordPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const RecordView();
  }
}

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate() async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthYearPickerDialog(initialDate: _selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final allTrackings = state.allTrackings.where((t) {
          final date = DateTime.parse(t.date);
          return date.year == _selectedDate.year &&
              date.month == _selectedDate.month;
        }).toList();

        // Group by date
        final grouped = <String, List<TrackingModel>>{};
        for (final t in allTrackings) {
          final dateStr = t.date.split('T')[0]; // assume ISO format
          grouped.putIfAbsent(dateStr, () => []).add(t);
        }

        // Calculate totals
        double totalExpense = 0;
        double totalIncome = 0;
        for (final t in allTrackings) {
          if (t.type == TrackingType.expense) totalExpense += t.amount;
          if (t.type == TrackingType.income) totalIncome += t.amount;
        }
        final balance = totalIncome - totalExpense;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                await context.pushNamed(Pages.trackingCalender.name);
              },
            ),
            title: Text(l10n.record),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  await context.pushNamed(Pages.trackingSearch.name);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacing.normal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_selectedDate.year}'),
                            Text(getMonthName(_selectedDate.month, l10n)),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(Pages.trackingBalance.name),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(l10n.expense),
                            Text(
                              '\$${totalExpense.toStringAsFixed(2)}',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colors.redPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(Pages.trackingBalance.name),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(l10n.income),
                            Text(
                              '\$${totalIncome.toStringAsFixed(2)}',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colors.greenPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.pushNamed(Pages.trackingBalance.name),
                      child: Column(
                        children: [
                          Text(l10n.balance),
                          Text(
                            '\$${balance.toStringAsFixed(2)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: balance > 0
                                  ? context.colors.primary
                                  : context.colors.redPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (grouped.entries.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: Spacing.s,
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 100,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        Text(
                          l10n.no_record_found,
                          textAlign: TextAlign.center,
                        ),
                        CustomButton(
                          child: Row(
                            spacing: Spacing.s,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add),
                              Text(l10n.add_record),
                            ],
                          ),
                          onPress: () async {
                            await context.pushNamed(
                              Pages.tracking.name,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(context).padding.bottom + Spacing.l4,
                    ),
                    children: grouped.entries.map((entry) {
                      final date = entry.key;
                      final trackings = entry.value;
                      const initValue = 0.0;
                      final dayExpense = trackings
                          .where((t) => t.type == TrackingType.expense)
                          .fold(initValue, (sum, t) => sum + t.amount);
                      final dayIncome = trackings
                          .where((t) => t.type == TrackingType.income)
                          .fold(initValue, (sum, t) => sum + t.amount);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.normal,
                              vertical: Spacing.s,
                            ),
                            color: context.colors.lightShadeGrey30,
                            child: Row(
                              children: [
                                Text(date),
                                const Spacer(),
                                Text.rich(
                                  TextSpan(
                                    text: '${l10n.expense}: ',
                                    children: [
                                      TextSpan(
                                        text:
                                            '\$${dayExpense.toStringAsFixed(2)}',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: context.colors.redPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Spacing.normal),
                                Text.rich(
                                  TextSpan(
                                    text: '${l10n.income}: ',
                                    children: [
                                      TextSpan(
                                        text:
                                            '\$${dayIncome.toStringAsFixed(2)}',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  context.colors.greenPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...trackings.map(
                            (tracking) => TrackingItem(tracking: tracking),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
