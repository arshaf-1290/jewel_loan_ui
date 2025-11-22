import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/pending_report_controller.dart';

class PendingReportView extends StatefulWidget {
  const PendingReportView({super.key});

  @override
  State<PendingReportView> createState() => _PendingReportViewState();
}

class _PendingReportViewState extends State<PendingReportView> {
  late final PendingReportController controller;

  DateTime? _fromDate;
  DateTime? _toDate;
  String _loanType = 'All';

  final ScrollController _horizontalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = PendingReportController();
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _fromDate = picked);
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _toDate = picked);
    }
  }

  List<PendingReportEntry> get _filtered =>
      controller.filter(from: _fromDate, to: _toDate, loanType: _loanType);

  @override
  Widget build(BuildContext context) {
    final entries = _filtered;
    final totalLoan = controller.sumLoanAmount(entries);
    final totalPending = controller.sumPendingAmount(entries);
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.border.withOpacity(0.6),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                        child: Row(
                          children: [
                            const Text(
                              'Pending Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            _HeaderCount(
                              label: 'Loans',
                              value: '${entries.length}',
                            ),
                            const SizedBox(width: 24),
                            _HeaderCount(
                              label: 'Loan Amount',
                              value: currency.format(totalLoan),
                            ),
                            const SizedBox(width: 24),
                            _HeaderCount(
                              label: 'Pending Amount',
                              value: currency.format(totalPending),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _DateBox(
                              label: 'From Date',
                              dateText: _fromDate == null
                                  ? 'Any'
                                  : DateFormat('dd-MMM-yyyy').format(_fromDate!),
                              onTap: _pickFromDate,
                            ),
                            _DateBox(
                              label: 'To Date',
                              dateText: _toDate == null
                                  ? 'Any'
                                  : DateFormat('dd-MMM-yyyy').format(_toDate!),
                              onTap: _pickToDate,
                            ),
                            SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<String>(
                                value: _loanType,
                                decoration: const InputDecoration(
                                  labelText: 'Loan Type',
                                ),
                                items: const [
                                  'All',
                                  'Monthly Flex',
                                  'Yearly Flex',
                                ]
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _loanType = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Scrollbar(
                            controller: _horizontalScroll,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _horizontalScroll,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 48,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(label: Text('Loan No')),
                                    DataColumn(label: Text('Customer Name')),
                                    DataColumn(label: Text('Mobile')),
                                    DataColumn(label: Text('Loan Date')),
                                    DataColumn(label: Text('Loan Amount')),
                                    DataColumn(label: Text('Pending Amount')),
                                    DataColumn(label: Text('Due Date')),
                                    DataColumn(label: Text('Loan Type')),
                                  ],
                                  rows: [
                                    ...entries.map(
                                      (entry) => DataRow(
                                        cells: [
                                          DataCell(Text(entry.loanNo)),
                                          DataCell(Text(entry.customerName)),
                                          DataCell(Text(entry.mobile)),
                                          DataCell(Text(entry.formattedLoanDate)),
                                          DataCell(
                                            Text(currency
                                                .format(entry.loanAmount)),
                                          ),
                                          DataCell(
                                            Text(currency
                                                .format(entry.pendingAmount)),
                                          ),
                                          DataCell(Text(entry.formattedDueDate)),
                                          DataCell(Text(entry.loanType)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderCount extends StatelessWidget {
  const _HeaderCount({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface.withOpacity(0.7),
              ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.dateText,
    required this.onTap,
  });

  final String label;
  final String dateText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 48,
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date',
            border: OutlineInputBorder(),
            isDense: true,
          ).copyWith(labelText: label),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateText),
              const Icon(Icons.calendar_today_outlined, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}


