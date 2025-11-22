import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/balance_sheet_controller.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class BalanceSheetView extends StatelessWidget {
  const BalanceSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BalanceSheetController();
    final rows = _mergeRows(controller.liabilities, controller.assets);
    final totals = _BalanceTotals.fromRows(rows);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _BalanceSheetCard(
              selectedDate: DateTime(2025, 11, 12),
              rows: rows,
            ),
          ),
          const SizedBox(height: 24),
          _BalanceSummaryBar(totals: totals),
        ],
      ),
    );
  }
}

class _BalanceSheetCard extends StatelessWidget {
  const _BalanceSheetCard({required this.selectedDate, required this.rows});

  final DateTime selectedDate;
  final List<_BalanceRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF6),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x208C6A2F),
            blurRadius: 26,
            offset: Offset(0, 18),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FiltersRow(selectedDate: selectedDate),
            const SizedBox(height: 24),
            Expanded(child: _BalanceTable(rows: rows)),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x148C6A2F),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            formatted,
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
        _PrimaryActionButton(
          label: 'Print',
          icon: Icons.print_outlined,
          backgroundColor: const Color(0xFF6B4B1F),
          onPressed: () {},
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

class _BalanceTable extends StatelessWidget {
  const _BalanceTable({required this.rows});

  final List<_BalanceRow> rows;

  @override
  Widget build(BuildContext context) {
    final headerStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      color: Color(0xFF3A2E21),
      fontSize: 14,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border.withOpacity(0.7)),
        ),
        child: ListView.builder(
          itemCount: rows.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                color: AppColors.primary.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Liabilities', style: headerStyle),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Amount', style: headerStyle),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 3,
                      child: Text('Assets', style: headerStyle),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Amount', style: headerStyle),
                      ),
                    ),
                  ],
                ),
              );
            }

            final row = rows[index - 1];
            final bool isEven = (index % 2 == 0);
            return Container(
              color: isEven ? Colors.white : const Color(0xFFFFF5E6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      row.liabilityName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A2E21),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        row.liabilityAmount ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B4B1F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 3,
                    child: Text(
                      row.assetName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E5E2E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        row.assetAmount ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E5E2E),
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
    );
  }
}

class _BalanceSummaryBar extends StatelessWidget {
  const _BalanceSummaryBar({required this.totals});

  final _BalanceTotals totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        // Use the same gold tone as Trial Balance & Profit & Loss footer
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
              label: 'Total Assets',
              value: totals.assetsFormatted,
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Total Liabilities',
              value: totals.liabilitiesFormatted,
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Total Equity',
              value: totals.equityFormatted,
            ),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryTile(
              label: 'Balance',
              value: totals.balanceFormatted,
              highlight: true,
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
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

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
                color: highlight ? const Color(0xFFFFD36B) : Colors.white,
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

class _BalanceRow {
  const _BalanceRow({
    this.liabilityName,
    this.liabilityAmount,
    this.assetName,
    this.assetAmount,
  });

  final String? liabilityName;
  final String? liabilityAmount;
  final String? assetName;
  final String? assetAmount;
}

class _BalanceTotals {
  const _BalanceTotals({required this.assets, required this.liabilities});

  final double assets;
  final double liabilities;

  double get equity => liabilities == 0 ? 0 : assets - liabilities;
  double get balance => assets - liabilities;

  String get assetsFormatted => _formatCurrency(assets);
  String get liabilitiesFormatted => _formatCurrency(liabilities);
  String get equityFormatted => _formatCurrency(equity);
  String get balanceFormatted => _formatCurrency(balance);

  factory _BalanceTotals.fromRows(List<_BalanceRow> rows) {
    double assetsSum = 0;
    double liabilitiesSum = 0;
    for (final row in rows) {
      if (row.assetAmount != null && row.assetAmount!.isNotEmpty) {
        assetsSum += _parseAmount(row.assetAmount!);
      }
      if (row.liabilityAmount != null && row.liabilityAmount!.isNotEmpty) {
        liabilitiesSum += _parseAmount(row.liabilityAmount!);
      }
    }
    return _BalanceTotals(assets: assetsSum, liabilities: liabilitiesSum);
  }
}

List<_BalanceRow> _mergeRows(
  List<Map<String, dynamic>> liabilities,
  List<Map<String, dynamic>> assets,
) {
  final maxLength = liabilities.length > assets.length
      ? liabilities.length
      : assets.length;
  final List<_BalanceRow> rows = [];
  for (var i = 0; i < maxLength; i++) {
    final liability = i < liabilities.length ? liabilities[i] : null;
    final asset = i < assets.length ? assets[i] : null;
    rows.add(
      _BalanceRow(
        liabilityName: liability?['head'] as String?,
        liabilityAmount: liability?['amount'] as String?,
        assetName: asset?['head'] as String?,
        assetAmount: asset?['amount'] as String?,
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
