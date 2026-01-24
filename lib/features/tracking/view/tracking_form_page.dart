import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monee/core/bloc/lang/language_bloc.dart';
import 'package:monee/core/bloc/tracking/tracking_bloc.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/models/category_model.dart';
import 'package:monee/core/models/tracking_model.dart';
import 'package:monee/core/routes/routes.dart';
import 'package:monee/core/theme/spacing.dart';
import 'package:monee/l10n/l10n.dart';
import 'package:monee/services/notification_services.dart';
import 'package:monee/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class TrackingFormPage extends StatelessWidget {
  const TrackingFormPage({
    this.selectedCategory = const CategoryModel(),
    super.key,
    this.tracking,
  });

  final TrackingModel? tracking;
  final CategoryModel selectedCategory;

  static MaterialPage<void> page({
    required CategoryModel selectedCategory,
    Key? key,
    TrackingModel? tracking,
  }) => MaterialPage<void>(
    child: TrackingFormPage(
      key: key,
      tracking: tracking,
      selectedCategory: selectedCategory,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TrackingBloc>(),
      child: TrackingFormView(
        tracking: tracking,
        selectedCategory: selectedCategory,
      ),
    );
  }
}

class TrackingFormView extends StatefulWidget {
  const TrackingFormView({
    required this.selectedCategory,
    super.key,
    this.tracking,
  });

  final TrackingModel? tracking;
  final CategoryModel selectedCategory;

  @override
  State<TrackingFormView> createState() => _TrackingFormViewState();
}

class _TrackingFormViewState extends State<TrackingFormView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  @override
  void initState() {
    final tracking = widget.tracking;
    if (tracking != null) {
      setState(() {
        _titleController = TextEditingController(
          text: tracking.title,
        );
        _amountController = TextEditingController(
          text: tracking.amount.toString(),
        );
        _descriptionController = TextEditingController(
          text: tracking.description,
        );
        _selectedDate = DateTime.parse(tracking.date);
        if (tracking.type.isSaving && tracking.endDate != null) {
          _selectedEndDate = DateTime.parse(tracking.endDate ?? tracking.date);
        }
      });
    } else {
      final nextDay = _selectedDate.add(const Duration(days: 1));
      setState(() {
        _selectedEndDate = nextDay;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final nextDay = _selectedDate.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: nextDay,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  Future<void> _saveTracking() async {
    final title = _titleController.text.trim();
    final amount = num.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text.trim();

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid title and amount')),
      );
      return;
    }

    final tracking = TrackingModel(
      id: widget.tracking?.id ?? const Uuid().v4(),
      type: widget.selectedCategory.type,
      title: title,
      description: description,
      amount: amount,
      date: _selectedDate.toIso8601String().split('T').first,
      category: widget.selectedCategory,
      endDate: widget.selectedCategory.type.isSaving
          ? _selectedEndDate.toIso8601String().split('T').first
          : null,
    );

    if (widget.tracking != null) {
      context.read<TrackingBloc>().add(TrackingUpdate(tracking: tracking));
      context.pop();
      return;
    } else {
      context.read<TrackingBloc>().add(
        TrackingCreate(tracking: tracking, context: context),
      );
      // Show success notification
      final notificationShown = await NotificationService().showNotification(
        id:
            tracking.id.hashCode.abs() %
            1000000, // Use hash to create unique valid ID
        title: context.l10n.created,
        body: context.l10n.your_tracking_create_successfully(
          tracking.title,
        ),
        payload: tracking.toJson(),
      );
      if (!notificationShown) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to show notification'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    if (widget.selectedCategory.type.isSaving) {
      AppRouter.navigationBottomBarShell.goBranch(2);
      return;
    }
    AppRouter.navigationBottomBarShell.goBranch(1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUpdate = widget.tracking != null;
    final titleType = widget.selectedCategory.type.isExpense
        ? l10n.expense
        : widget.selectedCategory.type.isIncome
        ? l10n.income
        : l10n.saving;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isUpdate ? '${l10n.update} $titleType' : '${l10n.add} $titleType',
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              spacing: Spacing.normal,
              children: [
                ListTile(
                  leading: CustomImage(
                    color: widget.selectedCategory.color,
                    icon: widget.selectedCategory.icon,
                  ),
                  title: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return Text(
                        widget.selectedCategory.categoryTitle(
                          state.selectLanguage.languageCode,
                        ),
                      );
                    },
                  ),
                  // trailing: const Icon(Icons.chevron_right),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: Spacing.m,
                    horizontal: Spacing.normal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.normal,
                  ),
                  child: Column(
                    spacing: Spacing.normal,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: l10n.title,
                          hintText: l10n.enter_tracking_title,
                        ),
                      ),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: widget.selectedCategory.type.isSaving
                              ? l10n.goal_saving
                              : l10n.amount,
                          hintText: l10n.enter_amount,
                        ),
                      ),
                      InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(16),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.select_date,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                      if (widget.selectedCategory.type.isSaving)
                        InkWell(
                          onTap: _selectEndDate,
                          borderRadius: BorderRadius.circular(16),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: l10n.select_end_date,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_selectedEndDate.day}/${_selectedEndDate.month}/${_selectedEndDate.year}',
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l10n.descprition,
                          hintText: l10n.enter_descprition,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.normal,
                ),
                width: double.infinity,
                child: CustomButton(
                  onPress: _saveTracking,
                  child: Text(
                    isUpdate ? l10n.update : l10n.create,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
