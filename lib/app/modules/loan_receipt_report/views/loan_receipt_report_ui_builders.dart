part of 'loan_receipt_report_view.dart';

class _ReceiptsTab extends StatefulWidget {
  const _ReceiptsTab({
    required this.controller,
    required this.onSelect,
    this.locked = false,
    this.lockMessage,
  });

  final LoanReceiptReportController controller;
  final ValueChanged<LoanReceiptRecord> onSelect;
  final bool locked;
  final String? lockMessage;

  @override
  State<_ReceiptsTab> createState() => _ReceiptsTabState();
}

class _ReceiptsTabState extends State<_ReceiptsTab> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12),
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(8),
                  radius: const Radius.circular(4),
                ),
              ),
              child: _GradientScrollbar(
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 48,
                    ),
                    child: DataTable(
                columns: const [
                  DataColumn(label: Text('Receipt No')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Loan No')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Mobile No')),
                  DataColumn(label: Text('Loan Amount')),
                  DataColumn(label: Text('Due Period')),
                  DataColumn(label: Text('Due Amount')),
                  DataColumn(label: Text('Payment Mode')),
                  DataColumn(label: Text('Principal')),
                  DataColumn(label: Text('Interest')),
                  DataColumn(label: Text('OD Amount')),
                  DataColumn(label: Text('Extra Amount')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Receipt Amount')),
                  DataColumn(label: Text('Actions')),
                ],
                      rows: widget.controller.records
                            .map((record) {
                              void openEdit() => widget.onSelect(record);

                              Widget clickableText(String value) {
                                return InkWell(
                                  onTap: openEdit,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );
                              }

                              return DataRow(
                              cells: [
                                  DataCell(clickableText(record.receiptId)),
                                  DataCell(clickableText(record.formattedDate)),
                                  DataCell(clickableText(record.loanNo)),
                                  DataCell(clickableText(record.customerName)),
                                DataCell(Text(record.mobileNumber)),
                                  DataCell(Text(
                                      widget.controller.formatCurrency(record.loanAmount))),
                                DataCell(Text(record.duePeriod)),
                                  DataCell(Text(
                                      widget.controller.formatCurrency(record.dueAmount))),
                                DataCell(Text(record.paymentMode)),
                                  DataCell(Text(widget.controller
                                      .formatCurrency(record.principalAmount))),
                                  DataCell(Text(widget.controller
                                      .formatCurrency(record.interestAmount))),
                                  DataCell(Text(
                                      widget.controller.formatCurrency(record.odAmount))),
                                DataCell(Text(
                                    '${record.extraAmountBehaviour == ExtraAmountBehaviour.add ? 'Add' : 'Less'} ${widget.controller.formatCurrency(record.extraAmount)}')),
                                  DataCell(Text(
                                      widget.controller.formatCurrency(record.totalAmount))),
                                  DataCell(Text(
                                      widget.controller.formatCurrency(record.receiptAmount))),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'View details',
                                          onPressed: () =>
                                              _showDetails(context, record, widget.controller),
                                        icon: const Icon(Icons.remove_red_eye_outlined),
                                      ),
                                      IconButton(
                                        tooltip: 'Edit',
                                          onPressed: openEdit,
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete',
                                        onPressed: () => _confirmDelete(context, record),
                                          icon: const Icon(Icons.delete_outline,
                                              color: AppColors.danger),
                                      ),
                                      IconButton(
                                        tooltip: 'Print',
                                          onPressed: () =>
                                              _showPrintPreview(context, record, widget.controller),
                                        icon: const Icon(Icons.print_outlined),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              );
                            })
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.locked) return content;

    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: content),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.center,
            child: _LockMessage(message: widget.lockMessage),
          ),
        ),
      ],
    );
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    LoanReceiptRecord record,
  ) async {
    final parentState =
        context.findAncestorStateOfType<_LoanReceiptReportViewState>();
    parentState?._deleteRecord(record);
  }

  static void _showDetails(
    BuildContext context,
    LoanReceiptRecord record,
    LoanReceiptReportController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt: ${record.receiptId}'),
            Text('Loan No: ${record.loanNo}'),
            Text('Customer: ${record.customerName}'),
            const SizedBox(height: 12),
            Text(
              'Breakup:\nPrincipal: ${controller.formatCurrency(record.principalAmount)}\nInterest: ${controller.formatCurrency(record.interestAmount)}\nOD: ${controller.formatCurrency(record.odAmount)}\nExtra Days Interest: ${controller.formatCurrency(record.extraDayInterest)}',
            ),
            Text('Total: ${controller.formatCurrency(record.totalAmount)}'),
            Text('Receipt Amount: ${controller.formatCurrency(record.receiptAmount)}'),
            Text('Revised Due: ${record.formattedRevisedDate}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  static void _showPrintPreview(
    BuildContext context,
    LoanReceiptRecord record,
    LoanReceiptReportController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Receipt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: Jewel MS Branch'),
            Text('Receipt No: ${record.receiptId}'),
            Text('Date: ${record.formattedDate}'),
            const SizedBox(height: 12),
            Text('Loan No: ${record.loanNo}'),
            Text('Customer: ${record.customerName}'),
            Text('Loan Amount: ${controller.formatCurrency(record.loanAmount)}'),
            const Divider(),
            Text(
              'Principal: ${controller.formatCurrency(record.principalAmount)}\nInterest: ${controller.formatCurrency(record.interestAmount)}\nOD: ${controller.formatCurrency(record.odAmount)}\nExtra: ${controller.formatCurrency(record.extraAmount)} (${record.extraAmountBehaviour == ExtraAmountBehaviour.add ? 'Add' : 'Less'})',
            ),
            const Divider(),
            Text('Total: ${controller.formatCurrency(record.totalAmount)}'),
            Text('Receipt Amount: ${controller.formatCurrency(record.receiptAmount)}'),
            const SizedBox(height: 12),
            const Text('Acknowledgement: Signature / Seal'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Download'),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }
}

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.controller,
    required this.selected,
    required this.canModify,
    required this.paymentModeCtrl,
    required this.principalCtrl,
    required this.interestCtrl,
    required this.odCtrl,
    required this.receiptCtrl,
    required this.remarksCtrl,
    required this.onSave,
    required this.onCancel,
    required this.onDelete,
    required this.onPrint,
    this.locked = false,
    this.lockMessage,
  });

  final LoanReceiptReportController controller;
  final LoanReceiptRecord? selected;
  final bool Function(String) canModify;
  final TextEditingController paymentModeCtrl;
  final TextEditingController principalCtrl;
  final TextEditingController interestCtrl;
  final TextEditingController odCtrl;
  final TextEditingController receiptCtrl;
  final TextEditingController remarksCtrl;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onPrint;
  final bool locked;
  final String? lockMessage;

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return const Center(child: Text('Select a receipt from the list to edit.'));
    }
    final isEditable = canModify(selected!.receiptId);
    const labelStyle = TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );

    InputDecoration pillDecoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        );

    Widget buildField({
      required double width,
      required TextEditingController controller,
      required String label,
      TextInputType? keyboardType,
      bool readOnly = false,
      int maxLines = 1,
    }) {
      return SizedBox(
        width: width,
        child: SizedBox(
          height: maxLines == 1 ? 40 : null,
          child: AppTextField(
            controller: controller,
            label: label,
            keyboardType: keyboardType,
            readOnly: readOnly || !isEditable,
            maxLines: maxLines,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );
    }

    Widget readOnlyPill({
      required double width,
      required String label,
      required String value,
    }) {
      return SizedBox(
        width: width,
        height: 40,
        child: InputDecorator(
          decoration: pillDecoration(label),
          child: Text(value),
        ),
      );
    }

    final content = LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
      padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Editing ${selected!.receiptId} • ${selected!.customerName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Chip(
                label: Text(isEditable ? 'Editable' : 'Locked (latest only)'),
                backgroundColor: isEditable ? AppColors.surface : Colors.red.withOpacity(0.08),
                labelStyle: TextStyle(
                  color: isEditable ? AppColors.primary : AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              readOnlyPill(
                width: 220,
                label: 'Receipt No',
                value: selected!.receiptId,
              ),
              readOnlyPill(
                width: 220,
                label: 'Loan No',
                value: selected!.loanNo,
              ),
              readOnlyPill(
                width: 240,
                label: 'Customer',
                value: selected!.customerName,
              ),
              readOnlyPill(
                width: 200,
                label: 'Loan Amount',
                value: controller.formatCurrency(selected!.loanAmount),
              ),
              buildField(
                width: 200,
                  controller: paymentModeCtrl,
                label: 'Payment Mode',
                ),
              buildField(
                width: 160,
                  controller: principalCtrl,
                label: 'Principal Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 160,
                  controller: interestCtrl,
                label: 'Interest Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 160,
                  controller: odCtrl,
                label: 'OD Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 160,
                  controller: receiptCtrl,
                label: 'Receipt Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: AppTextField(
            controller: remarksCtrl,
              label: 'Remarks',
              maxLines: 3,
            readOnly: !isEditable,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
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
                TextButton.icon(
                  onPressed: isEditable ? onDelete : null,
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.danger),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.danger,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onPrint,
                  icon: const Icon(Icons.print_outlined),
                  label: const Text('Print'),
                ),
                ElevatedButton.icon(
              onPressed: isEditable ? onSave : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Update Receipt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
          ),
        ],
      ),
          ),
                  ],
                ),
              ),
      ),
    );

    if (!locked) return content;
    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: content),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.center,
            child: _LockMessage(
              message: lockMessage ??
                  'Please print, download, or cancel before leaving print preview.',
            ),
          ),
        ),
      ],
    );
  }
}

class _PrintTab extends StatefulWidget {
  const _PrintTab({
    required this.controller,
    required this.records,
    this.locked = false,
    this.lockMessage,
    required this.onCancel,
    required this.onPrintComplete,
    required this.onDownloadComplete,
  });

  final LoanReceiptReportController controller;
  final List<LoanReceiptRecord> records;
  final bool locked;
  final String? lockMessage;
  final VoidCallback onCancel;
  final VoidCallback onPrintComplete;
  final VoidCallback onDownloadComplete;

  @override
  State<_PrintTab> createState() => _PrintTabState();
}

class _PrintTabState extends State<_PrintTab> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPrincipal = widget.records.fold<double>(
      0,
      (sum, record) => sum + record.principalAmount,
    );
    final totalInterest =
        widget.records.fold<double>(0, (sum, record) => sum + record.interestAmount);
    final totalOd = widget.records.fold<double>(0, (sum, record) => sum + record.odAmount);
    final totalReceipt = widget.records.fold<double>(0, (sum, record) => sum + record.receiptAmount);

    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Print Preview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
              OutlinedButton.icon(
                onPressed: widget.onDownloadComplete,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: widget.onPrintComplete,
                icon: const Icon(Icons.print),
                label: const Text('Print'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company: Jewel MS Head Office',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('Generated: ${DateFormat('dd-MMM-yyyy – hh:mm a').format(DateTime.now())}'),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Principal: ${widget.controller.formatCurrency(totalPrincipal)}'),
                          Text('Total Interest: ${widget.controller.formatCurrency(totalInterest)}'),
                          Text('Total OD: ${widget.controller.formatCurrency(totalOd)}'),
                          Text('Total Receipts: ${widget.controller.formatCurrency(totalReceipt)}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        'Remarks: EMI receipts include revised due date adjustments and additional interest where applicable.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      thumbColor: MaterialStateProperty.all(Colors.transparent),
                      thickness: MaterialStateProperty.all(8),
                      radius: const Radius.circular(4),
                    ),
                  ),
                  child: _GradientScrollbar(
                    controller: _horizontalScrollController,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 48,
                        ),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Receipt No')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Loan No')),
                            DataColumn(label: Text('Customer')),
                            DataColumn(label: Text('Principal')),
                            DataColumn(label: Text('Interest')),
                            DataColumn(label: Text('OD')),
                            DataColumn(label: Text('Receipt Amount')),
                          ],
                          rows: widget.records
                              .map(
                                (record) => DataRow(
                                  cells: [
                                    DataCell(Text(record.receiptId)),
                                    DataCell(Text(record.formattedDate)),
                                    DataCell(Text(record.loanNo)),
                                    DataCell(Text(record.customerName)),
                                    DataCell(Text(widget.controller.formatCurrency(record.principalAmount))),
                                    DataCell(Text(widget.controller.formatCurrency(record.interestAmount))),
                                    DataCell(Text(widget.controller.formatCurrency(record.odAmount))),
                                    DataCell(Text(widget.controller.formatCurrency(record.receiptAmount))),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('Authorized Signatory'),
                      SizedBox(height: 4),
                      Text('This is a system-generated receipt preview.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!widget.locked) return content;
    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: content),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.center,
            child: _LockMessage(message: widget.lockMessage),
          ),
        ),
      ],
    );
  }
}

class _LockMessage extends StatelessWidget {
  const _LockMessage({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_outline, color: AppColors.primary, size: 36),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            message ??
                'Please update, delete, or cancel before leaving edit mode.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientScrollbar extends StatefulWidget {
  const _GradientScrollbar({
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<_GradientScrollbar> createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<_GradientScrollbar> {
  bool _isDragging = false;
  double _dragStartPosition = 0.0;
  double _dragStartScrollOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!widget.controller.hasClients) {
                return const SizedBox.shrink();
              }
              
              return AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final maxScrollExtent = widget.controller.position.maxScrollExtent;
                  final minScrollExtent = widget.controller.position.minScrollExtent;
                  final scrollExtent = maxScrollExtent - minScrollExtent;
                  
                  if (scrollExtent <= 0) {
                    return const SizedBox.shrink();
                  }
                  
                  final viewportDimension = widget.controller.position.viewportDimension;
                  final thumbExtent = (viewportDimension / (scrollExtent + viewportDimension)) * constraints.maxWidth;
                  final scrollOffset = widget.controller.position.pixels - minScrollExtent;
                  final thumbOffset = (scrollOffset / scrollExtent) * (constraints.maxWidth - thumbExtent);
                  
                  return GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragStartPosition = details.localPosition.dx;
                        _dragStartScrollOffset = widget.controller.position.pixels;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final delta = details.localPosition.dx - _dragStartPosition;
                        final scrollDelta = (delta / (constraints.maxWidth - thumbExtent)) * scrollExtent;
                        final newScrollOffset = (_dragStartScrollOffset + scrollDelta).clamp(
                          minScrollExtent,
                          maxScrollExtent,
                        );
                        widget.controller.jumpTo(newScrollOffset);
                      }
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Stack(
                        children: [
                          Positioned(
                            left: thumbOffset.clamp(0.0, constraints.maxWidth - thumbExtent),
                            width: thumbExtent.clamp(20.0, constraints.maxWidth),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF8C6A2F), // Brown color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

