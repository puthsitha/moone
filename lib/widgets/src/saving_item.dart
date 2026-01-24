import 'package:flutter/material.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class SavingItem extends StatelessWidget {
  const SavingItem({
    required this.saving,
    required this.goalSaving,
    required this.remaining,
    required this.remainingPercentage,
    required this.currentSaving,
    super.key,
    this.onPress,
  });

  final VoidCallback? onPress;
  final double remainingPercentage;
  final num remaining;
  final num goalSaving;
  final num currentSaving;
  final TrackingModel saving;

  @override
  Widget build(BuildContext context) {
    final remainingLabel = 100 - (remainingPercentage * 100);
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(Spacing.m),
        child: Column(
          spacing: Spacing.m,
          children: [
            Row(
              spacing: Spacing.m,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomImage(
                    color: saving.category.color,
                    icon: saving.category.icon,
                  ),
                ),
                Text(
                  saving.title.toUpperCase(),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              spacing: Spacing.l,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: remainingLabel / 100.0,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            remaining >= 0.0
                                ? context.colors.greenPrimary
                                : context.colors.redPrimary,
                          ),
                          strokeWidth: 8,
                        ),
                      ),
                      Align(
                        child: remaining >= 0
                            ? Text(
                                '${remainingLabel.toStringAsFixed(0)}%',
                              )
                            : const Text('--'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.goal_saving,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            goalSaving > 0
                                ? '\$${goalSaving.toStringAsFixed(2)}'
                                : '--',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: context.colors.divider,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.current_amount,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          Text(
                            '\$${currentSaving.toStringAsFixed(2)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: remainingLabel >= 50
                                  ? context.colors.primary
                                  : remainingLabel >= 80
                                  ? context.colors.greenPrimary
                                  : context.colors.redPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.remaining,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: remaining >= 0
                                  ? context.colors.greenPrimary
                                  : context.colors.redPrimary,
                            ),
                          ),
                          Text(
                            '\$${remaining.toStringAsFixed(2)}',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: remaining >= 0
                                  ? context.colors.greenPrimary
                                  : context.colors.redPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
