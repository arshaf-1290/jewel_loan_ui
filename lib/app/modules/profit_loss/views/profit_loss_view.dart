import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/profit_loss_controller.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class ProfitLossView extends StatelessWidget {
  const ProfitLossView({super.key});

  @override
  Widget build(BuildContext context) {
    const controller = ProfitLossController();
    final rows = _mergeIncomeExpense(controller.income, controller.expense);
    final totals = _ProfitLossTotals.fromRows(rows);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FiltersRow(selectedDate: DateTime(2025, 11, 12)),
          const SizedBox(height: 24),
          Expanded(child: _ProfitLossTableCard(rows: rows)),
          const SizedBox(height: 24),
          _SummaryFooter(totals: totals),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.18),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Select Date:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3A2E21),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x108C6A2F),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF3A2E21),
            ),
          ),
        ),
        const Spacer(),
        _PrimaryActionButton(
          label: 'Refresh',
          icon: Icons.refresh,
          backgroundColor: AppColors.primary,
          onPressed: () {},
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.picture_as_pdf_outlined,
            color: Color(0xFF6B4B1F),
          ),
          label: const Text(
            'Preview PDF',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B4B1F),
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined, color: Color(0xFF6B4B1F)),
          label: const Text(
            'Share PDF',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B4B1F),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label),
    );
  }
}

class _ProfitLossTableCard extends StatelessWidget {
  const _ProfitLossTableCard({required this.rows});

  final List<_PLRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Income',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A2E21),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3A2E21),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Expense',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A2E21),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3A2E21),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE2E8F4),
                ),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  final isEven = index.isEven;
                  return Container(
                    color: isEven ? Colors.white : AppColors.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            row.incomeHead ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3A2E21),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              row.incomeAmount ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B4B1F),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            row.expenseHead ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3A2E21),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              row.expenseAmount ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B4B1F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryFooter extends StatelessWidget {
  const _SummaryFooter({required this.totals});

  final _ProfitLossTotals totals;

  @override
  Widget build(BuildContext context) {
    final isLoss = totals.net < 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A8C6A2F),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              label: 'Total Income',
              value: totals.incomeFormatted,
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Total Expenses',
              value: totals.expenseFormatted,
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: isLoss ? 'Net Loss' : 'Net Profit',
              value: totals.netFormatted,
              valueColor: isLoss ? const Color(0xFFFFC857) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white24,
    );
  }
}

class _PLRow {
  const _PLRow({
    this.incomeHead,
    this.incomeAmount,
    this.expenseHead,
    this.expenseAmount,
  });

  final String? incomeHead;
  final String? incomeAmount;
  final String? expenseHead;
  final String? expenseAmount;
}

class _ProfitLossTotals {
  const _ProfitLossTotals({required this.income, required this.expense});

  final double income;
  final double expense;

  double get net => income - expense;

  String get incomeFormatted => _formatCurrency(income);
  String get expenseFormatted => _formatCurrency(expense);
  String get netFormatted => _formatCurrency(net.abs());

  factory _ProfitLossTotals.fromRows(List<_PLRow> rows) {
    double incomeSum = 0;
    double expenseSum = 0;
    for (final row in rows) {
      if (row.incomeAmount != null && row.incomeAmount!.isNotEmpty) {
        incomeSum += _parseAmount(row.incomeAmount!);
      }
      if (row.expenseAmount != null && row.expenseAmount!.isNotEmpty) {
        expenseSum += _parseAmount(row.expenseAmount!);
      }
    }
    return _ProfitLossTotals(income: incomeSum, expense: expenseSum);
  }
}

List<_PLRow> _mergeIncomeExpense(
  List<Map<String, dynamic>> income,
  List<Map<String, dynamic>> expense,
) {
  final int maxLength = income.length > expense.length
      ? income.length
      : expense.length;
  final List<_PLRow> rows = [];
  for (var i = 0; i < maxLength; i++) {
    final inc = i < income.length ? income[i] : null;
    final exp = i < expense.length ? expense[i] : null;
    rows.add(
      _PLRow(
        incomeHead: inc?['head'] as String?,
        incomeAmount: inc?['amount'] as String?,
        expenseHead: exp?['head'] as String?,
        expenseAmount: exp?['amount'] as String?,
      ),
    );
  }
  return rows;
}

double _parseAmount(String value) {
  final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
  if (cleaned.isEmpty) return 0;
  return double.tryParse(cleaned) ?? 0;
}

String _formatCurrency(double value) {
  final formatter = NumberFormat('#,##,##0.00', 'en_IN');
  return formatter.format(value);
}
