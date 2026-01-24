import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/budget/budget_bloc.dart';
import 'package:monee/core/bloc/category/category_bloc.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/bloc/theme/theme_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/src/theme_color.dart';
import 'package:monee/core/routes/src/app_router.dart';
import 'package:monee/core/theme/src/dark_theme.dart';
import 'package:monee/core/theme/src/light_theme.dart';
import 'package:monee/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    _initSplashScreen();
    super.initState();
  }

  void _initSplashScreen() {
    // await Future<void>.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = AppRouter.router;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc()..add(CategoryInitialize()),
        ),
        BlocProvider(
          create: (context) => BudgetBloc()..add(BudgetInitialize()),
        ),
        BlocProvider(
          create: (context) => TrackingBloc(),
        ),
      ],
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          context.read<BudgetBloc>().add(
            BudgetSyncWithCategories(categories: state.categories),
          );
        },
        listenWhen: (previous, current) =>
            previous.categories != current.categories,
        child: Builder(
          builder: (context) {
            final languageState = context.watch<LanguageBloc>().state;
            final themeState = context.watch<ThemeBloc>().state;
            Intl.defaultLocale =
                languageState.selectLanguage == const Locale('km')
                ? 'km_KH'
                : 'en_US';
            return GestureDetector(
              onTap: () {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
              child: MaterialApp.router(
                // showPerformanceOverlay: true, // show performance overlay
                theme: themeState.selectTheme == ThemeColor.darkMode
                    ? darkTheme
                    : lightTheme,
                locale: languageState.selectLanguage,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: goRouter,
                builder: (context, child) {
                  final childToast = MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.noScaling,
                    ),
                    child: child!,
                  );
                  return childToast;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
