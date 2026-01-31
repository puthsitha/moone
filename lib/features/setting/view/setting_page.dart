import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monee/core/bloc/theme/theme_bloc.dart';
import 'package:monee/core/common/common.dart' hide Icons;
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/theme/spacing.dart';

import 'package:monee/features/setting/setting.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: SettingPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingBloc(),
      child: const SettingView(),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  Future<void> _showLanguageDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ChangeLanguage(),
    );
  }

  Future<void> _showCurrencyDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const ChangeCurrency(),
    );
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    final version = kDebugMode
        ? '${info.version}+${info.buildNumber}'
        : info.version;

    return version;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.colors.primary,
            title: Text(l10n.setting),
          ),
          body: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    ImagePaths.logo,
                    width: 200,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      size: 40,
                      color: Colors.tealAccent,
                    ),
                    title: Text(
                      l10n.language,
                      style: context.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      l10n.press_here_change_language,
                      style: context.textTheme.bodyLarge,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.currency_exchange_rounded,
                      size: 40,
                      color: Colors.amber,
                    ),
                    title: Text(
                      l10n.currency,
                      style: context.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      l10n.press_here_to_change_currency,
                      style: context.textTheme.bodyLarge,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showCurrencyDialog(context),
                  ),
                  const SizedBox(height: Spacing.sm),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      return ListTile(
                        leading: Icon(
                          themeState.selectTheme == ThemeColor.darkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          size: 40,
                          color: themeState.selectTheme == ThemeColor.darkMode
                              ? Colors.indigoAccent
                              : Colors.amberAccent,
                        ),
                        title: Text(
                          l10n.theme,
                          style: context.textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          l10n.customize_theme_appearance,
                          style: context.textTheme.bodyLarge,
                        ),
                        trailing: Switch(
                          value: themeState.selectTheme == ThemeColor.darkMode,
                          onChanged: (value) {
                            final newTheme = value
                                ? ThemeColor.darkMode
                                : ThemeColor.lightMode;
                            context.read<ThemeBloc>().add(
                              ThemeAppChange(theme: newTheme),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: FutureBuilder<String>(
                    future: getAppVersion(),
                    builder: (context, snapshot) {
                      final version = snapshot.data ?? '';
                      return Text(
                        '${l10n.copyright} © ${l10n.version} $version',
                        style: context.textTheme.titleMedium,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
