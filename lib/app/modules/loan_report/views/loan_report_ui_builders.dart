part of 'loan_report_view.dart';

class _ReportTab extends StatefulWidget {
  const _ReportTab({
    required this.controller,
    required this.entries,
    required this.fromDate,
    required this.toDate,
    required this.onChangeFrom,
    required this.onChangeTo,
    required this.loanTypes,
    required this.selectedLoanType,
    required this.onChangeLoanType,
    required this.recommenderCtrl,
    required this.guarantorCtrl,
    required this.customerCtrl,
    required this.loanNoCtrl,
    required this.onSearch,
    required this.onPrint,
    required this.onSelect,
    this.locked = false,
    this.lockMessage,
  });

  final LoanReportController controller;
  final List<LoanReportEntry> entries;
  final DateTime fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onChangeFrom;
  final ValueChanged<DateTime> onChangeTo;
  final List<String> loanTypes;
  final String selectedLoanType;
  final ValueChanged<String> onChangeLoanType;
  final TextEditingController recommenderCtrl;
  final TextEditingController guarantorCtrl;
  final TextEditingController customerCtrl;
  final TextEditingController loanNoCtrl;
  final VoidCallback onSearch;
  final VoidCallback onPrint;
  final ValueChanged<LoanReportEntry> onSelect;
  final bool locked;
  final String? lockMessage;

  @override
  State<_ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<_ReportTab> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );

    InputDecoration filterDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
    }

    Widget filterField(TextEditingController controller, String label,
        {TextInputType? keyboardType}) {
      return SizedBox(
        width: 200,
        child: SizedBox(
          height: 40,
          child: AppTextField(
            controller: controller,
            label: label,
            keyboardType: keyboardType,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );
    }

    Widget dateChip(String label, DateTime date, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: labelStyle,
              ),
              const SizedBox(height: 4),
              Text(DateFormat('dd-MMM-yyyy').format(date)),
            ],
          ),
        ),
      );
    }

    final viewContent = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    dateChip('From Date', widget.fromDate, () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: widget.fromDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) widget.onChangeFrom(date);
                    }),
                    dateChip('To Date', widget.toDate, () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: widget.toDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) widget.onChangeTo(date);
                    }),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        value: widget.selectedLoanType,
                        decoration: filterDecoration('Loan Type'),
                        isExpanded: true,
                        items: widget.loanTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) widget.onChangeLoanType(value);
                        },
                      ),
                    ),
                    filterField(widget.recommenderCtrl, 'Recommender'),
                    filterField(widget.guarantorCtrl, 'Guarantor'),
                    filterField(widget.customerCtrl, 'Customer'),
                    filterField(widget.loanNoCtrl, 'Loan No'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: widget.onSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
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
                    DataColumn(label: Text('Loan Date')),
                    DataColumn(label: Text('Loan No')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Mobile')),
                    DataColumn(label: Text('Loan Type')),
                    DataColumn(label: Text('Loan Amount')),
                    DataColumn(label: Text('Interest')),
                    DataColumn(label: Text('Due Amount')),
                    DataColumn(label: Text('OD Amount')),
                    DataColumn(label: Text('Advance Receipt')),
                    DataColumn(label: Text('Extra Days')),
                    DataColumn(label: Text('Revised Due Date')),
                    DataColumn(label: Text('Extra Interest')),
                  ],
                        rows: widget.entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text(entry.formattedLoanDate)),
                            DataCell(
                              InkWell(
                                onTap: !widget.locked
                                    ? () => widget.onSelect(entry)
                                    : null,
                                child: Text(
                                  entry.loanNo,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: !widget.locked
                                        ? AppColors.primary
                                        : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(entry.customerName)),
                            DataCell(Text(entry.mobileNumber)),
                            DataCell(Text(entry.loanType)),
                                  DataCell(Text(widget.controller.formatCurrency(entry.loanAmount))),
                            DataCell(Text(
                                '${entry.interestType} @ ${entry.interestPercent.toStringAsFixed(2)}%')),
                                  DataCell(Text(widget.controller.formatCurrency(entry.dueAmount))),
                                  DataCell(Text(widget.controller.formatCurrency(entry.odAmount))),
                                  DataCell(Text(widget.controller.formatCurrency(entry.advanceReceipt))),
                            DataCell(Text('${entry.extraDaysAdded}')),
                            DataCell(Text(entry.formattedRevisedDate)),
                                  DataCell(Text(widget.controller.formatCurrency(entry.extraInterest))),
                          ],
                        ),
                      )
                      .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.locked) {
      return viewContent;
    }

    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: viewContent),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.65),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.lockMessage ??
                        'Finish or cancel the print preview to continue.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
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
}

class _EntryTab extends StatelessWidget {
  const _EntryTab({
    required this.controller,
    required this.entryDate,
    required this.onPickDate,
    required this.loanTypes,
    required this.loanType,
    required this.onLoanTypeChanged,
    required this.interestType,
    required this.onInterestTypeChanged,
    required this.loanNoCtrl,
    required this.customerCtrl,
    required this.mobileCtrl,
    required this.loanAmountCtrl,
    required this.interestPercentCtrl,
    required this.dueAmountCtrl,
    required this.odPercentCtrl,
    required this.odAmountCtrl,
    required this.advanceReceiptCtrl,
    required this.docAmountCtrl,
    required this.remarksCtrl,
    required this.recommenderCtrl,
    required this.guarantorCtrl,
    required this.extraDays,
    required this.onExtraDaysChanged,
    required this.revisedDueDate,
    required this.onPickRevisedDate,
    required this.extraInterestCtrl,
    required this.showAdvanced,
    required this.onToggleAdvanced,
    required this.onSubmit,
  });

  final LoanReportController controller;
  final DateTime entryDate;
  final VoidCallback onPickDate;
  final List<String> loanTypes;
  final String loanType;
  final ValueChanged<String> onLoanTypeChanged;
  final String interestType;
  final ValueChanged<String> onInterestTypeChanged;
  final TextEditingController loanNoCtrl;
  final TextEditingController customerCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController loanAmountCtrl;
  final TextEditingController interestPercentCtrl;
  final TextEditingController dueAmountCtrl;
  final TextEditingController odPercentCtrl;
  final TextEditingController odAmountCtrl;
  final TextEditingController advanceReceiptCtrl;
  final TextEditingController docAmountCtrl;
  final TextEditingController remarksCtrl;
  final TextEditingController recommenderCtrl;
  final TextEditingController guarantorCtrl;
  final int extraDays;
  final ValueChanged<int> onExtraDaysChanged;
  final DateTime? revisedDueDate;
  final VoidCallback onPickRevisedDate;
  final TextEditingController extraInterestCtrl;
  final bool showAdvanced;
  final VoidCallback onToggleAdvanced;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;
    const labelStyle = TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );
    const valueStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
      fontWeight: FontWeight.w500,
    );

    InputDecoration fieldDecoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

    Widget dateField(String label, DateTime? date, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: fieldDecoration(label),
          child: Text(
            date == null ? 'Select' : DateFormat('dd-MMM-yyyy').format(date),
          ),
        ),
      );
    }

    Widget buildTextField({
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
            readOnly: readOnly,
            maxLines: maxLines,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: 200,
                height: 48,
                child: dateField('Loan Date', entryDate, onPickDate),
              ),
              buildTextField(
                width: 200,
                controller: loanNoCtrl,
                label: 'Loan No',
              ),
              buildTextField(
                width: 200,
                controller: customerCtrl,
                label: 'Customer Name',
              ),
              buildTextField(
                width: 200,
                controller: mobileCtrl,
                label: 'Mobile No',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: loanType,
                  decoration: fieldDecoration('Loan Type'),
                  isExpanded: true,
                  items: loanTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onLoanTypeChanged(value);
                  },
                ),
              ),
              buildTextField(
                width: 200,
                controller: loanAmountCtrl,
                label: 'Loan Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: interestType,
                  decoration: fieldDecoration('Interest Type'),
                  isExpanded: true,
                  items: const ['Monthly', 'Daily', 'Yearly']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onInterestTypeChanged(value);
                  },
                ),
              ),
              buildTextField(
                width: 180,
                controller: interestPercentCtrl,
                label: 'Interest %',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildTextField(
                width: 200,
                controller: dueAmountCtrl,
                label: 'Due Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildTextField(
                width: 160,
                controller: odPercentCtrl,
                label: 'OD %',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildTextField(
                width: 200,
                controller: odAmountCtrl,
                label: 'OD Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildTextField(
                width: 200,
                controller: advanceReceiptCtrl,
                label: 'Advance Receipt',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildTextField(
                width: 200,
                controller: docAmountCtrl,
                label: 'Document Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: AppTextField(
                    controller: remarksCtrl,
                    label: 'Remarks',
                    maxLines: 3,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: showAdvanced ? 'Hide advanced' : 'Show advanced',
                onPressed: onToggleAdvanced,
                icon: Icon(showAdvanced ? Icons.visibility_off : Icons.visibility),
              ),
            ],
          ),
          if (showAdvanced) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                buildTextField(
                  width: 200,
                  controller: recommenderCtrl,
                  label: 'Recommender',
                ),
                buildTextField(
                  width: 200,
                  controller: guarantorCtrl,
                  label: 'Guarantor',
                ),
                SizedBox(
                  width: 160,
                  height: 48,
                  child: InputDecorator(
                    decoration: fieldDecoration('Extra Days Added'),
                    child: Text('$extraDays', style: valueStyle),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: extraDays.toDouble(),
                    min: 0,
                    max: 30,
                    divisions: 30,
                    label: '$extraDays days',
                    onChanged: (value) => onExtraDaysChanged(value.toInt()),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 48,
                  child: dateField(
                    'Revised Due Date',
                    revisedDueDate,
                    onPickRevisedDate,
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 48,
                  child: AppTextField(
                    controller: extraInterestCtrl,
                    label: 'Extra Interest',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.selected,
    required this.loanTypes,
    required this.loanType,
    required this.onSelectLoanType,
    required this.interestType,
    required this.onSelectInterestType,
    required this.loanAmountCtrl,
    required this.interestPercentCtrl,
    required this.dueAmountCtrl,
    required this.odPercentCtrl,
    required this.odAmountCtrl,
    required this.advanceCtrl,
    required this.docCtrl,
    required this.remarksCtrl,
    required this.onUpdate,
    required this.onCancel,
    required this.onDelete,
    required this.onPrint,
    this.locked = false,
  });

  final LoanReportEntry? selected;
  final List<String> loanTypes;
  final String loanType;
  final ValueChanged<String> onSelectLoanType;
  final String interestType;
  final ValueChanged<String> onSelectInterestType;
  final TextEditingController loanAmountCtrl;
  final TextEditingController interestPercentCtrl;
  final TextEditingController dueAmountCtrl;
  final TextEditingController odPercentCtrl;
  final TextEditingController odAmountCtrl;
  final TextEditingController advanceCtrl;
  final TextEditingController docCtrl;
  final TextEditingController remarksCtrl;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onPrint;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );

    InputDecoration pillDecoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            maxLines: maxLines,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );
    }

    if (selected == null) {
      return const Center(child: Text('Select a loan to edit'));
    }

    final formContent = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selected!.customerName} (${selected!.loanNo})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: InputDecorator(
                  decoration: pillDecoration('Loan Date'),
                  child: Text(selected!.formattedLoanDate),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: InputDecorator(
                  decoration: pillDecoration('Loan No'),
                  child: Text(selected!.loanNo),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: loanType,
                  decoration: pillDecoration('Loan Type'),
                  items: loanTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onSelectLoanType(value);
                  },
                ),
              ),
               SizedBox(
                width: 200,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: interestType,
                  decoration: pillDecoration('Interest Type'),
                  items: const ['Monthly', 'Daily', 'Yearly']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onSelectInterestType(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: InputDecorator(
                  decoration: pillDecoration('Customer Name'),
                  child: Text(selected!.customerName),
                ),
              ),
              buildField(
                width: 200,
                controller: loanAmountCtrl,
                label: 'Loan Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: interestPercentCtrl,
                label: 'Interest %',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: dueAmountCtrl,
                label: 'Due Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: odPercentCtrl,
                label: 'OD %',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: odAmountCtrl,
                label: 'OD Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: advanceCtrl,
                label: 'Advance Receipt',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              buildField(
                width: 200,
                controller: docCtrl,
                label: 'Document Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                width: 848,
                child: AppTextField(
                  controller: remarksCtrl,
                  label: 'Remarks',
                  maxLines: 2,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
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
                  onPressed: onUpdate,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!locked) {
      return formContent;
    }

    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: formContent),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.65),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Finish or cancel the print preview to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
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
}

class _PrintTab extends StatefulWidget {
  const _PrintTab({
    required this.fromDate,
    required this.toDate,
    required this.loanType,
    required this.recommender,
    required this.guarantor,
    required this.customer,
    required this.loanNo,
    required this.entries,
    required this.controller,
    required this.onPrint,
    required this.onDownload,
    required this.onCancel,
    required this.isPrinting,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final String loanType;
  final String recommender;
  final String guarantor;
  final String customer;
  final String loanNo;
  final List<LoanReportEntry> entries;
  final LoanReportController controller;
  final VoidCallback onPrint;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final bool isPrinting;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Print Preview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: widget.isPrinting ? null : widget.onCancel,
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: widget.isPrinting ? null : widget.onDownload,
                icon: widget.isPrinting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: const Text('Download'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: widget.isPrinting ? null : widget.onPrint,
                icon: widget.isPrinting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.print),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter Summary',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _SummaryChip(
                      label: 'Date Range',
                      value:
                          '${DateFormat('dd-MMM-yyyy').format(widget.fromDate)} → ${DateFormat('dd-MMM-yyyy').format(widget.toDate)}',
                    ),
                    _SummaryChip(label: 'Loan Type', value: widget.loanType),
                    if (widget.recommender.isNotEmpty)
                      _SummaryChip(label: 'Recommender', value: widget.recommender),
                    if (widget.guarantor.isNotEmpty)
                      _SummaryChip(label: 'Guarantor', value: widget.guarantor),
                    if (widget.customer.isNotEmpty)
                      _SummaryChip(label: 'Customer', value: widget.customer),
                    if (widget.loanNo.isNotEmpty)
                      _SummaryChip(label: 'Loan No', value: widget.loanNo),
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
                      DataColumn(label: Text('Loan No')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Loan Type')),
                      DataColumn(label: Text('Loan Amount')),
                      DataColumn(label: Text('Due Amount')),
                      DataColumn(label: Text('OD Amount')),
                    ],
                          rows: widget.entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text(entry.loanNo)),
                              DataCell(Text(entry.customerName)),
                              DataCell(Text(entry.loanType)),
                              DataCell(
                                        Text(widget.controller.formatCurrency(entry.loanAmount))),
                              DataCell(
                                        Text(widget.controller.formatCurrency(entry.dueAmount))),
                              DataCell(
                                        Text(widget.controller.formatCurrency(entry.odAmount))),
                            ],
                          ),
                        )
                        .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Loan: ${widget.controller.formatCurrency(widget.controller.sumLoanAmount(widget.entries))}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Total Due: ${widget.controller.formatCurrency(widget.controller.sumDueAmount(widget.entries))}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Total OD: ${widget.controller.formatCurrency(widget.controller.sumOdAmount(widget.entries))}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Generated on ${DateFormat('dd-MMM-yyyy – hh:mm a').format(DateTime.now())}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Powered by Jewel MS',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
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


