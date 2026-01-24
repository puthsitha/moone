import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/widgets/widgets.dart';

class SavingPage extends StatelessWidget {
  const SavingPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
    child: SavingPage(key: key),
  );

  @override
  Widget build(BuildContext context) {
    return const SavingView();
  }
}

class SavingView extends StatefulWidget {
  const SavingView({super.key});

  @override
  State<SavingView> createState() => _SavingViewState();
}

class _SavingViewState extends State<SavingView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.your_saving),
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state.savings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: Spacing.s,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 100,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  Text(
                    l10n.no_saving_yet,
                    textAlign: TextAlign.center,
                  ),
                  CustomButton(
                    child: Row(
                      spacing: Spacing.s,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add),
                        Text(l10n.create_saving_goal),
                      ],
                    ),
                    onPress: () async {
                      await context.pushNamed(
                        Pages.tracking.name,
                        queryParameters: {'type': TrackingType.saving.name},
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              thickness: 3,
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + Spacing.l4,
            ),
            itemCount: state.savings.length,
            itemBuilder: (context, index) {
              final saving = state.savings[index];
              final remaining = saving.amount - saving.savingAmount;
              final remainingPercentage = remaining / saving.amount;
              return SavingItem(
                saving: saving,
                remainingPercentage: remainingPercentage,
                goalSaving: saving.amount,
                remaining: remaining,
                currentSaving: saving.savingAmount,
                onPress: () => _showSavingInputDialog(context, saving),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showSavingInputDialog(
    BuildContext context,
    TrackingModel saving,
  ) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.add_saving_amount),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: context.l10n.amount),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                final input = double.tryParse(controller.text) ?? 0;
                if (input > 0) {
                  final newSavingAmount = saving.savingAmount + input;
                  final updatedSaving = saving.copyWith(
                    savingAmount: newSavingAmount,
                  );
                  context.read<TrackingBloc>().add(
                    TrackingUpdate(tracking: updatedSaving),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(context.l10n.add),
            ),
          ],
        );
      },
    );
  }
}
