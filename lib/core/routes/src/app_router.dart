import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/enums/src/tracking_type.dart';
import 'package:monee/core/extensions/src/build_context_ext.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/src/not_found_screen.dart';
import 'package:monee/core/theme/theme.dart';
import 'package:monee/features/category/category.dart';
// import 'package:monee/features/dashboard/dashboard.dart';
import 'package:monee/features/onboarding/onboarding.dart';
import 'package:monee/features/record/record.dart';
import 'package:monee/features/report/report.dart';
import 'package:monee/features/saving/saving.dart';
import 'package:monee/features/setting/setting.dart';
import 'package:monee/features/splash/splash.dart';
import 'package:monee/features/tracking/tracking.dart';

enum Pages {
  /// Splash
  splash,
  onboarding,
  app,

  /// home
  tracking,
  trackingForm,
  trackingDetail,
  trackingSearch,
  trackingBalance,
  trackingCalender,
  trackingCalenderDetail,
  trackingSaving,
  // Category
  category,
  categoryForm,

  /// record
  record,

  /// report
  report,
  budget,
  budgetSetting,

  /// saving
  saving,

  /// setting
  setting,
}

class AppRouter {
  AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static late StatefulNavigationShell navigationBottomBarShell;

  static late ScrollController recordScrollController;

  static final dashboradShellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'dashboard',
  );
  static final savingShellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'dashboard',
  );
  static final recordShellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'record',
  );
  static final reportShellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'report',
  );
  static final settingShellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'setting',
  );

  static GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (kDebugMode) {
        print('route fullPath : ${state.fullPath}');
      }
      return null;
    },
    errorPageBuilder: (context, state) {
      return NotFoundScreen.page(key: state.pageKey);
    },
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        name: Pages.splash.name,
        path: '/',
        pageBuilder: (context, state) {
          return SplashPage.page(key: state.pageKey);
        },
      ),
      GoRoute(
        name: Pages.onboarding.name,
        path: '/onboarding',
        pageBuilder: (context, state) {
          return OnboardingPage.page(key: state.pageKey);
        },
      ),
      GoRoute(
        name: Pages.app.name,
        path: '/app',
        redirect: (context, state) {
          if (state.fullPath == '/app') {
            return '/app/report';
          }
          return null;
        },
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              navigationBottomBarShell = navigationShell;
              return BottomNavigationPage(
                child: navigationShell,
              );
            },
            branches: [
              StatefulShellBranch(
                navigatorKey: reportShellNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'report',
                    parentNavigatorKey: reportShellNavigatorKey,
                    redirect: (context, state) {
                      if (state.fullPath == '/app/report') {
                        return '/app/report/report-analytis';
                      }
                      return null;
                    },
                    routes: [
                      GoRoute(
                        name: Pages.report.name,
                        parentNavigatorKey: reportShellNavigatorKey,
                        path: 'report-analytis',
                        pageBuilder: (context, state) {
                          return ReportPage.page(
                            key: state.pageKey,
                          );
                        },
                        routes: [
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            name: Pages.budget.name,
                            path: 'budget',
                            pageBuilder: (context, state) {
                              return BudgetPage.page(key: state.pageKey);
                            },
                          ),
                          GoRoute(
                            parentNavigatorKey: rootNavigatorKey,
                            name: Pages.budgetSetting.name,
                            path: 'budget-setting',
                            pageBuilder: (context, state) {
                              return BudgeteSettingPage.page(
                                key: state.pageKey,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // StatefulShellBranch(
              //   navigatorKey: dashboradShellNavigatorKey,
              //   routes: [
              //     GoRoute(
              //       name: Pages.saving.name,
              //       path: '/dashboard',
              //       pageBuilder: (context, state) {
              //         return DashboardPage.page(key: state.pageKey);
              //       },
              //     ),
              //   ],
              // ),
              StatefulShellBranch(
                navigatorKey: recordShellNavigatorKey,
                routes: [
                  GoRoute(
                    name: Pages.record.name,
                    path: 'record',
                    pageBuilder: (context, state) {
                      return RecordPage.page(key: state.pageKey);
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: savingShellNavigatorKey,
                routes: [
                  GoRoute(
                    name: Pages.saving.name,
                    path: '/saving',
                    pageBuilder: (context, state) {
                      return SavingPage.page(key: state.pageKey);
                    },
                  ),
                ],
              ),
              // StatefulShellBranch(
              //   navigatorKey: reportShellNavigatorKey,
              //   routes: [
              //     GoRoute(
              //       path: 'report',
              //       parentNavigatorKey: reportShellNavigatorKey,
              //       redirect: (context, state) {
              //         if (state.fullPath == '/app/report') {
              //           return '/app/report/report-analytis';
              //         }
              //         return null;
              //       },
              //       routes: [
              //         GoRoute(
              //           name: Pages.report.name,
              //           parentNavigatorKey: reportShellNavigatorKey,
              //           path: 'report-analytis',
              //           pageBuilder: (context, state) {
              //             return ReportPage.page(
              //               key: state.pageKey,
              //             );
              //           },
              //           routes: [
              //             GoRoute(
              //               parentNavigatorKey: rootNavigatorKey,
              //               name: Pages.budget.name,
              //               path: 'budget',
              //               pageBuilder: (context, state) {
              //                 return BudgetPage.page(key: state.pageKey);
              //               },
              //             ),
              //             GoRoute(
              //               parentNavigatorKey: rootNavigatorKey,
              //               name: Pages.budgetSetting.name,
              //               path: 'budget-setting',
              //               pageBuilder: (context, state) {
              //                 return BudgeteSettingPage.page(
              //                   key: state.pageKey,
              //                 );
              //               },
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              StatefulShellBranch(
                navigatorKey: settingShellNavigatorKey,
                routes: [
                  GoRoute(
                    path: 'setting',
                    name: Pages.setting.name,
                    pageBuilder: (context, state) {
                      return SettingPage.page(
                        key: state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            name: Pages.tracking.name,
            path: 'tracking',
            pageBuilder: (context, state) {
              var type = TrackingType.expense;
              final jsonType = state.uri.queryParameters['type'];
              if (jsonType != null && jsonType.isNotEmpty) {
                type = TrackingType.fromMap(jsonType);
              } else {
                type = TrackingType.expense;
              }
              return TrackingPage.page(key: state.pageKey, type: type);
            },
          ),
          GoRoute(
            name: Pages.trackingForm.name,
            path: 'tracking-form',
            pageBuilder: (context, state) {
              TrackingModel? tracking;
              final jsonString = state.uri.queryParameters['tracking'];
              if (jsonString != null && jsonString.isNotEmpty) {
                tracking = TrackingModel.fromJson(jsonString);
              }
              final category = CategoryModel.fromJson(
                state.uri.queryParameters['category'] ?? '',
              );
              return TrackingFormPage.page(
                key: state.pageKey,
                tracking: tracking,
                selectedCategory: category,
              );
            },
          ),
          GoRoute(
            name: Pages.trackingDetail.name,
            path: 'tracking-detail',
            pageBuilder: (context, state) {
              final tracking = TrackingModel.fromJson(
                state.uri.queryParameters['tracking'] ?? '',
              );
              return TrackingDetailPage.page(
                key: state.pageKey,
                tracking: tracking,
              );
            },
          ),
          GoRoute(
            name: Pages.trackingSearch.name,
            path: 'tracking-search',
            pageBuilder: (context, state) {
              return TrackingSearchPage.page(key: state.pageKey);
            },
          ),
          GoRoute(
            name: Pages.trackingCalender.name,
            path: 'tracking-canlender',
            pageBuilder: (context, state) {
              return TrackingCalenderPage.page(key: state.pageKey);
            },
          ),
          GoRoute(
            name: Pages.trackingCalenderDetail.name,
            path: 'tracking-canlender-detail',
            pageBuilder: (context, state) {
              final date = state.uri.queryParameters['date'] ?? '';
              return TrackingCalenderDetailPage.page(
                key: state.pageKey,
                date: date,
              );
            },
          ),
          GoRoute(
            name: Pages.trackingBalance.name,
            path: 'tracking-balance',
            pageBuilder: (context, state) {
              return TrackingBalancePage.page(key: state.pageKey);
            },
          ),
          GoRoute(
            name: Pages.category.name,
            path: 'category',
            pageBuilder: (context, state) {
              var type = TrackingType.expense;
              final jsonType = state.uri.queryParameters['type'];
              if (jsonType != null && jsonType.isNotEmpty) {
                type = TrackingType.fromMap(jsonType);
              }
              return CategoryPage.page(key: state.pageKey, type: type);
            },
          ),
          GoRoute(
            name: Pages.categoryForm.name,
            path: 'category-form',
            pageBuilder: (context, state) {
              CategoryModel? category;
              TrackingType? type;
              final jsonCategory = state.uri.queryParameters['category'];
              final jsonType = state.uri.queryParameters['type'];
              if (jsonCategory != null && jsonCategory.isNotEmpty) {
                category = CategoryModel.fromJson(jsonCategory);
              }
              if (jsonType != null && jsonType.isNotEmpty) {
                type = TrackingType.fromMap(jsonType);
              }
              return CategoryFormPage.page(
                key: state.pageKey,
                category: category,
                type: type,
              );
            },
          ),
        ],
      ),
    ],
  );
}

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({required this.child, super.key});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.colors.primary,
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.pureWhite,
        ),
        onPressed: () async {
          await context.pushNamed(
            Pages.tracking.name,
          );
        },
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: context.colors.primary,
        notchSmoothness: NotchSmoothness.sharpEdge,
        gapLocation: GapLocation.center,
        blurEffect: true,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: AppColors.pureWhite,
        inactiveColor: AppColors.pureWhite.withValues(alpha: 0.5),

        icons: const [
          Icons.bar_chart_rounded,
          // Icons.dashboard_rounded,
          Icons.receipt_long_rounded,
          Icons.savings_rounded,
          // Icons.bar_chart_rounded,
          Icons.settings_rounded,
        ],
        activeIndex: child.currentIndex,
        onTap: (index) {
          if (index == child.currentIndex) return;
          child.goBranch(
            index,
            initialLocation: index == child.currentIndex,
          );
        },
      ),
      body: child,
    );
  }
}
