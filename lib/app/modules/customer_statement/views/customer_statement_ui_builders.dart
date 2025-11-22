part of 'customer_statement_view.dart';

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
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

class _StatementTab extends StatelessWidget {
  const _StatementTab({
    required this.statement,
    required this.onSelectLoan,
    this.locked = false,
    this.lockMessage,
  });

  final CustomerStatement statement;
  final ValueChanged<CustomerStatementLoan> onSelectLoan;
  final bool locked;
  final String? lockMessage;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _FilterField(
                label: 'Customer',
                initialValue: statement.customerName,
              ),
              _FilterField(
                label: 'Mobile',
                initialValue: statement.mobileNumber,
              ),
              _FilterField(
                label: 'City / Address',
                initialValue: statement.address,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Loan No')),
                    DataColumn(label: Text('Loan Date')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Mobile')),
                    DataColumn(label: Text('City')),
                    DataColumn(label: Text('Loan Amount (₹)')),
                    DataColumn(label: Text('Interest %')),
                    DataColumn(label: Text('Paid (₹)')),
                    DataColumn(label: Text('Pending (₹)')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: statement.loans
                      .map(
                        (loan) {
                          final customerName = statement.customerName;
                          final mobile = statement.mobileNumber;
                          final city = _cityFromAddress(statement.address);
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(loan.loanNo),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(loan.formattedLoanDate),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(customerName),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(mobile),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(city),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(loan.loanAmount.toStringAsFixed(2)),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text('${loan.interestPercent.toStringAsFixed(2)}%'),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(loan.paidAmount.toStringAsFixed(2)),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(loan.pendingAmount.toStringAsFixed(2)),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(loan.formattedDueDate),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Text(
                                  loan.status,
                                  style: TextStyle(
                                    color: loan.status == 'Overdue'
                                        ? AppColors.danger
                                        : AppColors.primary,
                                  ),
                                ),
                                onTap: () => onSelectLoan(loan),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Edit',
                                      onPressed: () => onSelectLoan(loan),
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Print',
                                      onPressed: () => _printLoan(context, loan),
                                      icon: const Icon(Icons.print_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!locked) return content;

    return Stack(
      children: [
        AbsorbPointer(child: content),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.75),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: AppColors.primary, size: 36),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    lockMessage ??
                        'Statement is locked while editing. Save, print, or cancel to continue.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static void _printLoan(BuildContext context, CustomerStatementLoan loan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Print Loan ${loan.loanNo}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Loan Amount: ₹${loan.loanAmount.toStringAsFixed(2)}'),
            Text('Pending: ₹${loan.pendingAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            const Text('This will generate a printable PDF with loan breakdown.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  static String _cityFromAddress(String address) {
    final parts = address.split(',');
    if (parts.isEmpty) return address;
    return parts.last.trim().isEmpty ? address : parts.last.trim();
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.initialValue,
  });

  final String label;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 44,
      child: TextField(
        controller: TextEditingController(text: initialValue),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.search, size: 18),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.selected,
    required this.paidCtrl,
    required this.pendingCtrl,
    required this.statusCtrl,
    required this.onSave,
    required this.onCancel,
    required this.onPrint,
  });

  final CustomerStatementLoan? selected;
  final TextEditingController paidCtrl;
  final TextEditingController pendingCtrl;
  final TextEditingController statusCtrl;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return const Center(child: Text('Select a loan from the statement to edit.'));
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editing Loan ${selected!.loanNo}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  readOnly: true,
                  controller:
                      TextEditingController(text: selected!.loanAmount.toStringAsFixed(2)),
                  decoration: const InputDecoration(labelText: 'Loan Amount'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: paidCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Paid Amount'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: pendingCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Pending Amount'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: statusCtrl,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
                OutlinedButton.icon(
                  onPressed: onPrint,
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                ),
                ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Update Loan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrintTab extends StatelessWidget {
  const _PrintTab({
    required this.statement,
    required this.onCancel,
  });

  final CustomerStatement statement;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print),
                label: const Text('Print Statement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Statement Preview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text('Customer: ${statement.customerName}'),
                Text('Mobile: ${statement.mobileNumber}'),
                Text('Address: ${statement.address}'),
                const Divider(height: 32),
                ...statement.loans.map(
                  (loan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${loan.loanNo} (${loan.formattedLoanDate})'),
                        Text('Pending: ₹${loan.pendingAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 32),
                Text('Totals:'),
                Text('Loan Amount: ₹${statement.totalLoanAmount.toStringAsFixed(2)}'),
                Text('Paid: ₹${statement.totalPaid.toStringAsFixed(2)}'),
                Text('Pending: ₹${statement.totalPending.toStringAsFixed(2)}'),
                Text('Overdue: ₹${statement.totalOverdue.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

