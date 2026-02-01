import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/core/utils/util.dart';
import 'package:monee/widgets/src/custom_image.dart';

class TrackingItem extends StatelessWidget {
  const TrackingItem({required this.tracking, super.key});

  final TrackingModel tracking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomImage(
        color: tracking.category.color,
        icon: tracking.category.icon,
      ),
      onTap: () => context.pushNamed(
        Pages.trackingDetail.name,
        queryParameters: {'tracking': tracking.toJson()},
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.normal,
        vertical: Spacing.s,
      ),
      title: Text(tracking.title),
      trailing: Text(
        '${tracking.type.isExpense
            ? '-'
            : tracking.type.isIncome
            ? '+'
            : ''}${CurrencyUtil.formatCurrency(
          tracking.amount,
          currencyType: tracking.currency,
        )}',
        style: context.textTheme.bodyMedium?.copyWith(
          color: tracking.type.isExpense
              ? context.colors.redPrimary
              : tracking.type.isIncome
              ? context.colors.greenPrimary
              : context.colors.primary,
        ),
      ),
    );
  }
}
