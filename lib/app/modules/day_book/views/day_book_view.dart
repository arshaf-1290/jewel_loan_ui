import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/module_scaffold.dart';
import '../controllers/day_book_controller.dart';

class DayBookView extends StatefulWidget {
  const DayBookView({super.key});

  @override
  State<DayBookView> createState() => _DayBookViewState();
}

class _DayBookViewState extends State<DayBookView> {
  late final DayBookController _controller;
  final _dateFormat = DateFormat('dd-MM-yyyy');
  final _numberFormat = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    _controller = DayBookController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Day Book Data',
      subtitle: 'Daily summary of all vouchers with running totals',
      headerActions: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('View'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
          ),
          onPressed: () {},
          icon: const Icon(Icons.print_outlined),
          label: const Text('Print'),
        ),
      ],
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final entries = _controller.filteredEntries;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterBar(context),
              const SizedBox(height: 24),
              _buildTableCard(entries),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              label: 'Date',
              value:
                  '${_dateFormat.format(_controller.fromDate)} - ${_dateFormat.format(_controller.toDate)}',
              onTap: () async {
                await _controller.pickFromDate(context);
                await _controller.pickToDate(context);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDateField(
              label: 'From Date',
              value: _dateFormat.format(_controller.fromDate),
              onTap: () => _controller.pickFromDate(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDateField(
              label: 'To Date',
              value: _dateFormat.format(_controller.toDate),
              onTap: () => _controller.pickToDate(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Select Voucher Type',
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _controller.selectedVoucherType ?? 'All',
                    items: _controller.voucherTypes
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(v),
                          ),
                        )
                        .toList(),
                    onChanged: _controller.changeVoucherType,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _controller.resetFilters,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(labelText: label),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard(List<DayBookEntry> entries) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border.withOpacity(0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Day Book Data',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary.withOpacity(0.08),
                  ),
                  child: Text(
                    '${entries.length} records',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 1200),
                  child: _buildDataTable(entries),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<DayBookEntry> entries) {
    final rows = <DataRow>[];
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      rows.add(
        DataRow(
          cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(_dateFormat.format(e.date))),
            DataCell(Text(e.particulars)),
            DataCell(Text(e.voucherType)),
            DataCell(Text(_numberFormat.format(e.credit))),
            DataCell(Text(_numberFormat.format(e.debit))),
          ],
        ),
      );
    }

    // Total row
    rows.add(
      DataRow(
        cells: [
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(
            Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const DataCell(Text('')),
          DataCell(
            Text(
              _numberFormat.format(_controller.totalCredit),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          DataCell(
            Text(
              _numberFormat.format(_controller.totalDebit),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    return DataTable(
      columns: const [
        DataColumn(label: Text('S.No')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Particulars')),
        DataColumn(label: Text('Voucher Type')),
        DataColumn(label: Text('Credit')),
        DataColumn(label: Text('Debit')),
      ],
      rows: rows,
      columnSpacing: 32,
      dataRowHeight: 52,
      headingRowHeight: 56,
    );
  }
}


