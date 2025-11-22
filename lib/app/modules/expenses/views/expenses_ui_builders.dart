import 'package:flutter/material.dart';

import '../../../core/widgets/app_paginated_table.dart';
import '../controllers/expenses_controller.dart';

class ExpenseForm extends StatelessWidget {
  const ExpenseForm({
    super.key,
    required this.controller,
    this.showClearAndSave = true,
    this.primaryButtonLabel = 'Save',
    this.onPrimaryPressed,
    this.onCancel,
    this.showDelete = false,
    this.onDelete,
  });

  final ExpensesController controller;
  final bool showClearAndSave;
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onCancel;
  final bool showDelete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('New Expense',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 16),
        // Row 1: Voucher, Date, From Account
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.voucherController,
                  decoration:
                      const InputDecoration(labelText: 'Voucher Number'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => InkWell(
                    onTap: () => controller.pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date'),
                      child: Text(controller.expenseDate
                          .toString()
                          .split(' ')
                          .first),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => DropdownButtonFormField<String>(
                    value: controller.selectedFromAccount,
                    decoration:
                        const InputDecoration(labelText: 'Expense From'),
                    items: controller.fromAccounts
                        .map(
                          (acc) => DropdownMenuItem(
                            value: acc,
                            child: Text(acc),
                          ),
                        )
                        .toList(),
                    onChanged: controller.changeFromAccount,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2: Expense To, Amount, Expense Type
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => DropdownButtonFormField<String>(
                    value: controller.selectedType,
                    decoration:
                        const InputDecoration(labelText: 'Expense To'),
                    items: controller.expenseTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: controller.changeType,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) => DropdownButtonFormField<String>(
                    value: controller.selectedCategory,
                    decoration:
                        const InputDecoration(labelText: 'Expense Type'),
                    items: controller.expenseCategories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ),
                        )
                        .toList(),
                    onChanged: controller.changeCategory,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.notesController,
          maxLines: 3,
          decoration:
              const InputDecoration(labelText: 'Notes / Description'),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showClearAndSave)
                OutlinedButton.icon(
                  onPressed: controller.clearForm,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              if (showClearAndSave) const SizedBox(width: 16),
              if (onCancel != null) ...[
                OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
              ],
              if (showDelete && onDelete != null) ...[
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Delete'),
                ),
                const SizedBox(width: 16),
              ],
              ElevatedButton.icon(
                onPressed: onPrimaryPressed ?? controller.addExpense,
                icon: const Icon(Icons.save_outlined),
                label: Text(primaryButtonLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpenseTable extends StatelessWidget {
  const ExpenseTable({
    super.key,
    required this.controller,
    this.onRowTap,
  });

  final ExpensesController controller;
  final void Function(int index, Map<String, dynamic> row)? onRowTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expense Ledger',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) => AppPaginatedTable(
            columns: const [
              AppTableColumn(label: 'Date', key: 'date'),
              AppTableColumn(label: 'From', key: 'from'),
              AppTableColumn(label: 'Expense To', key: 'type'),
              AppTableColumn(label: 'Category', key: 'category'),
              AppTableColumn(label: 'Amount', key: 'amount', numeric: true),
              AppTableColumn(label: 'Notes', key: 'notes'),
            ],
            rows: controller.expenses,
            onRowTap: onRowTap,
          ),
        ),
      ],
    );
  }
}

class ExpenseEditTab extends StatelessWidget {
  const ExpenseEditTab({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onDelete,
  });

  final ExpensesController controller;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Edit Expense',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: ExpenseForm(
              controller: controller,
              showClearAndSave: false,
              primaryButtonLabel: 'Save',
              onPrimaryPressed: controller.addExpense,
              onCancel: onCancel,
              showDelete: true,
              onDelete: onDelete,
            ),
          ),
        ),
      ],
    );
  }
}


