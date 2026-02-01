import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/l10n/l10n.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  late Locale _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final languageState = context.read<LanguageBloc>().state;
    _selectedLanguage = languageState.selectLanguage;
  }

  void _onSaveLanguage() {
    context.read<LanguageBloc>().add(
      LanguageAppChange(locale: _selectedLanguage),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.language),
      content: RadioGroup<Locale>(
        groupValue: _selectedLanguage,
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              locale: Locale('km'),
              label: 'ខ្មែរ',
              image: 'assets/images/km_flag.png',
            ),
            _LanguageOption(
              locale: Locale('en'),
              label: 'English',
              image: 'assets/images/en_flag.png',
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.label,
    required this.image,
  });

  final Locale locale;
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
          height: 20,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(label),
      trailing: Radio<Locale>(
        value: locale,
      ),
    );
  }
}
