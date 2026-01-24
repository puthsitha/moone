import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/common/common.dart' hide Icons;
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/theme/theme.dart';

import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: DashboardPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const DashboardView();
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    unawaited(
      _animationController.repeat(reverse: true),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '${context.l10n.good_morning} 🌅';
    } else if (hour < 17) {
      return '${context.l10n.good_afternoon} 🫖';
    } else if (hour < 21) {
      return '${context.l10n.good_evening} 🌆';
    } else {
      return '${context.l10n.good_night} 🌃';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final l10n = context.l10n;
    Color color1;
    Color color2;
    if (hour < 12) {
      color1 = Colors.blue.shade300;
      color2 = Colors.yellow.shade300;
    } else if (hour < 17) {
      color1 = Colors.yellow.shade300;
      color2 = Colors.orange.shade300;
    } else if (hour < 21) {
      color1 = Colors.orange.shade300;
      color2 = Colors.purple.shade300;
    } else {
      color1 = Colors.purple.shade300;
      color2 = Colors.blue.shade900;
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Animated AppBar with greeting
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return FlexibleSpaceBar(
                      title: Text(
                        _getGreeting(context),
                        style: context.textTheme.titleLarge?.copyWith(
                          color: AppColors.pureWhite,
                        ),
                      ),
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(
                        left: Spacing.normal,
                        bottom: Spacing.normal,
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2, color1],
                            stops: [0.0, _animation.value, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: Image.asset(GifPaths.welcome),
                ),
              ],
            ),
          ),

          // Dashboard Content
          SliverPadding(
            padding: const EdgeInsets.all(Spacing.normal),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: Spacing.s),

                // Records Section
                _AnimatedDashboardCard(
                  delay: 100,
                  child: _DashboardSection(
                    icon: Icons.receipt_long,
                    title: l10n.record,
                    description: l10n.view_all_record,
                    color: Colors.blue,
                    onTap: () {
                      AppRouter.navigationBottomBarShell.goBranch(1);
                    },
                  ),
                ),

                const SizedBox(height: Spacing.normal),

                // // Add Transaction Section
                _AnimatedDashboardCard(
                  delay: 200,
                  child: _DashboardSection(
                    icon: Icons.add_circle,
                    title: l10n.add_tracking,
                    description: l10n.record_new_tracking,
                    color: Colors.green,
                    onTap: () async {
                      await context.pushNamed(Pages.tracking.name);
                    },
                  ),
                ),

                const SizedBox(height: Spacing.normal),

                // // Reports Section
                _AnimatedDashboardCard(
                  delay: 300,
                  child: _DashboardSection(
                    icon: Icons.bar_chart,
                    title: l10n.report,
                    description: l10n.view_insights_analytics,
                    color: Colors.purple,
                    onTap: () {
                      AppRouter.navigationBottomBarShell.goBranch(2);
                    },
                  ),
                ),

                const SizedBox(height: Spacing.l1),

                // Quick Stats Section
                _AnimatedDashboardCard(
                  delay: 400,
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.l),
                    decoration: BoxDecoration(
                      color: context.colors.pureWhite,
                      borderRadius: kBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quick_stats,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: Spacing.normal),
                        BlocBuilder<TrackingBloc, TrackingState>(
                          builder: (context, state) {
                            final totalIncome = state.incomes.fold<double>(
                              0,
                              (sum, item) => sum + item.amount,
                            );
                            final totalExpenses = state.expenses.fold<double>(
                              0,
                              (sum, item) => sum + item.amount,
                            );
                            final balance = totalIncome - totalExpenses;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatItem(
                                  label: l10n.income,
                                  value: NumberFormat.currency(
                                    symbol: r'$',
                                  ).format(totalIncome),
                                  color: Colors.green,
                                ),
                                StatItem(
                                  label: l10n.expenses,
                                  value: NumberFormat.currency(
                                    symbol: r'$',
                                  ).format(totalExpenses),
                                  color: Colors.red,
                                ),
                                StatItem(
                                  label: l10n.balance,
                                  value: NumberFormat.currency(
                                    symbol: r'$',
                                  ).format(balance),
                                  color: Colors.blue,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _AnimatedDashboardCard(delay: 400, child: Container()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDashboardCard extends StatefulWidget {
  const _AnimatedDashboardCard({
    required this.child,
    this.delay = 0,
  });

  final Widget child;
  final int delay;

  @override
  State<_AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<_AnimatedDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );

    Future.delayed(Duration(milliseconds: widget.delay), () async {
      if (mounted) {
        await _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.pureWhite,
      borderRadius: kBorderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: kBorderRadius,
        splashColor: color.withValues(alpha: .1),
        highlightColor: color.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(Spacing.l),
          decoration: BoxDecoration(
            borderRadius: kBorderRadius,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.m),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: Spacing.normal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      description,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
