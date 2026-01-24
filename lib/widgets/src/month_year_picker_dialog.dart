import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';

class MonthYearPickerDialog extends StatefulWidget {
  const MonthYearPickerDialog({required this.initialDate, super.key});

  final DateTime initialDate;

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (index) => currentYear - 5 + index);

    return AlertDialog(
      title: Text(l10n.select_month_year),
      content: Row(
        spacing: Spacing.l,
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: _selectedYear,
              items: years
                  .map(
                    (year) => DropdownMenuItem(
                      value: year,
                      child: Text('$year'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: DropdownButton<int>(
              value: _selectedMonth,
              isExpanded: true,
              items: List.generate(12, (index) => index + 1)
                  .map(
                    (month) => DropdownMenuItem<int>(
                      value: month,
                      child: Text(
                        DateFormat.MMMM().format(
                          DateTime(_selectedYear, month),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: FilledButton.styleFrom(
            foregroundColor: context.colors.redPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(DateTime(_selectedYear, _selectedMonth)),
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
