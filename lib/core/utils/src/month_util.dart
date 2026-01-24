import 'package:monee/l10n/l10n.dart';

String getMonthName(int month, AppLocalizations l10n) {
  final monthKeys = [
    l10n.jan,
    l10n.feb,
    l10n.mar,
    l10n.apr,
    l10n.may,
    l10n.jun,
    l10n.jul,
    l10n.aug,
    l10n.sep,
    l10n.oct,
    l10n.nov,
    l10n.dec,
  ];
  return monthKeys[month - 1];
}
