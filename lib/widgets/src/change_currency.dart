import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/currency/currency_bloc.dart';
import 'package:monee/core/common/common.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/l10n/l10n.dart';

class ChangeCurrency extends StatefulWidget {
  const ChangeCurrency({super.key});

  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  late CurrencyType _selectedCurrency;

  @override
  void initState() {
    super.initState();
    final currencyState = context.read<CurrencyBloc>().state;
    _selectedCurrency = currencyState.selectCurrency;
  }

  void _onSaveLanguage() {
    context.read<CurrencyBloc>().add(
      CurrencyAppChange(currency: _selectedCurrency),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.language),
      contentPadding: EdgeInsets.zero,
      content: RadioGroup<CurrencyType>(
        groupValue: _selectedCurrency,
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value!;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CurrencyOption(
              currency: CurrencyType.usd,
              label: l10n.usd,
              image: ImagePaths.usd,
            ),
            _CurrencyOption(
              currency: CurrencyType.khr,
              label: l10n.khr,
              image: ImagePaths.khr,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: FilledButton.styleFrom(
            foregroundColor: context.colors.redPrimary,
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _onSaveLanguage,
          child: Text(
            l10n.save,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  const _CurrencyOption({
    required this.currency,
    required this.label,
    required this.image,
  });

  final CurrencyType currency;
  final String label;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          image,
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(label),
      trailing: Radio<CurrencyType>(
        value: currency,
      ),
    );
  }
}
