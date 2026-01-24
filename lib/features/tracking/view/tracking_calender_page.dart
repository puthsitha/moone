import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/colors.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/widgets/widgets.dart';

class TrackingCalenderPage extends StatelessWidget {
  const TrackingCalenderPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: TrackingCalenderPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const TrackingCalenderView();
  }
}

class TrackingCalenderView extends StatefulWidget {
  const TrackingCalenderView({super.key});

  @override
  State<TrackingCalenderView> createState() => _TrackingCalenderViewState();
}

class _TrackingCalenderViewState extends State<TrackingCalenderView> {
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
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedDate.toMonthYear(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.pureWhite,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          final trackings = state.allTrackings;
          final dailyTotals = _calculateDailyTotals(trackings, _selectedDate);
          return Padding(
            padding: const EdgeInsets.all(Spacing.normal),
            child: CalendarGrid(
              selectedDate: _selectedDate,
              dailyTotals: dailyTotals,
            ),
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

  Map<DateTime, Map<TrackingType, double>> _calculateDailyTotals(
    List<TrackingModel> trackings,
    DateTime selectedDate,
  ) {
    final totals = <DateTime, Map<TrackingType, double>>{};

    for (final tracking in trackings) {
      try {
        final date = DateTime.parse(tracking.date);
        if (date.year == selectedDate.year &&
            date.month == selectedDate.month) {
          final dayKey = DateTime(date.year, date.month, date.day);
          totals[dayKey] ??= {
            TrackingType.expense: 0,
            TrackingType.income: 0,
            TrackingType.saving: 0,
          };
          totals[dayKey]![tracking.type] =
              (totals[dayKey]![tracking.type] ?? 0) +
              tracking.amount.toDouble();
        }
      } on Exception catch (_) {
        // Skip invalid dates
      }
    }

    return totals;
  }
}

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.selectedDate,
    required this.dailyTotals,
    super.key,
  });

  final DateTime selectedDate;
  final Map<DateTime, Map<TrackingType, double>> dailyTotals;

  @override
  Widget build(BuildContext context) {
    final languageState = context.watch<LanguageBloc>().state;
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedDate.year,
      selectedDate.month,
    );
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    final weekDaysEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekDaysKh = ['ច', 'អ', 'ព', 'ព្រ', 'សុ', 'ស', 'អា'];

    final weekDays = languageState.selectLanguage.languageCode == 'en'
        ? weekDaysEn
        : weekDaysKh;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
            ),
            itemCount: daysInMonth + firstWeekday - 1,
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) {
                return const SizedBox.shrink();
              }
              final day = index - (firstWeekday - 1) + 1;
              final date = DateTime(selectedDate.year, selectedDate.month, day);
              final totals = dailyTotals[date] ?? {};

              return CalendarDayCell(
                day: day,
                expense: totals[TrackingType.expense] ?? 0,
                income: totals[TrackingType.income] ?? 0,
                onTap: () async {
                  await context.pushNamed(
                    Pages.trackingCalenderDetail.name,
                    queryParameters: {'date': date.toIso8601String()},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.day,
    required this.expense,
    required this.income,
    required this.onTap,
    super.key,
  });

  final int day;
  final double expense;
  final double income;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasData = expense > 0 || income > 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasData) ...[
              const SizedBox(height: 4),
              if (expense > 0)
                Text(
                  '-${expense.toStringAsFixed(0)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.redPrimary,
                    fontSize: 10,
                  ),
                ),
              if (income > 0)
                Text(
                  '+${income.toStringAsFixed(0)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.greenPrimary,
                    fontSize: 10,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
