import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/company_creation_controller.dart';

class EntryTab extends StatelessWidget {
  const EntryTab({
    super.key,
    required this.companyId,
    required this.loginId,
    required this.companyNameCtrl,
    required this.mobileCtrl,
    required this.gstCtrl,
    required this.altContactCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.pincodeCtrl,
    required this.adminUsernameCtrl,
    required this.accessPinCtrl,
    required this.confirmPinCtrl,
    required this.businessType,
    required this.onBusinessTypeChanged,
    required this.financialYear,
    required this.onFinancialYearChanged,
    required this.bankNameCtrl,
    required this.accountHolderCtrl,
    required this.accountNumberCtrl,
    required this.ifscCtrl,
    required this.branchCtrl,
    required this.upiCtrl,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.remarksCtrl,
    required this.businessTypes,
    required this.financialYears,
    required this.accountTypes,
    required this.defaultBank,
    required this.onDefaultBankChanged,
    required this.onSubmit,
  });

  final String companyId;
  final String loginId;
  final TextEditingController companyNameCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController gstCtrl;
  final TextEditingController altContactCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController adminUsernameCtrl;
  final TextEditingController accessPinCtrl;
  final TextEditingController confirmPinCtrl;
  final String businessType;
  final ValueChanged<String> onBusinessTypeChanged;
  final String financialYear;
  final ValueChanged<String> onFinancialYearChanged;
  final TextEditingController bankNameCtrl;
  final TextEditingController accountHolderCtrl;
  final TextEditingController accountNumberCtrl;
  final TextEditingController ifscCtrl;
  final TextEditingController branchCtrl;
  final TextEditingController upiCtrl;
  final String accountType;
  final ValueChanged<String> onAccountTypeChanged;
  final TextEditingController remarksCtrl;
  final List<String> businessTypes;
  final List<String> financialYears;
  final List<String> accountTypes;
  final bool defaultBank;
  final ValueChanged<bool?> onDefaultBankChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    InputDecoration fieldDecoration(String label, {String? helperText}) {
      OutlineInputBorder border(Color color) => OutlineInputBorder(
            // Match Customer Creation style: subtle rounded corners, not pill
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 1.1),
          );
      final subtle = AppColors.border.withOpacity(0.7);
      return InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        helperText: helperText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: border(subtle),
        enabledBorder: border(subtle),
        focusedBorder: border(AppColors.primary),
      );
    }

    Widget readOnlyBox(String label, String value, {double width = 200}) {
      return SizedBox(
        width: width,
        height: 40,
        child: InputDecorator(
          decoration: fieldDecoration(label),
          child: Text(
            value,
            style: textStyle,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              readOnlyBox('Company ID', companyId),
              readOnlyBox('Login ID', loginId),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: financialYear,
                  decoration: fieldDecoration('Financial Year'),
                  isExpanded: true,
                  style: textStyle,
                  items: financialYears
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onFinancialYearChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: businessType,
                  decoration: fieldDecoration('Business Type'),
                  isExpanded: true,
                  style: textStyle,
                  items: businessTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onBusinessTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: companyNameCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Company Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: mobileCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.phone,
                  decoration: fieldDecoration('Mobile Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: altContactCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.phone,
                  decoration: fieldDecoration('Alternate Contact (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: gstCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('GST Number (Optional)'),
                ),
              ),
              SizedBox(
                width: 410,
                height: 40,
                child: TextField(
                  controller: addressCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Address'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: cityCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('City'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: cityCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('State'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: pincodeCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.number,
                  decoration: fieldDecoration('Pincode'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: adminUsernameCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Admin Username'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accessPinCtrl,
                  style: textStyle,
                  obscureText: true,
                  decoration: fieldDecoration('Access PIN (4-6 digits)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: confirmPinCtrl,
                  style: textStyle,
                  obscureText: true,
                  decoration: fieldDecoration('Confirm Access PIN'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Bank Details (Optional but recommended)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: bankNameCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Bank Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: branchCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Branch Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: accountType,
                  decoration: fieldDecoration('Account Type'),
                  isExpanded: true,
                  style: textStyle,
                  items: accountTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onAccountTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: accountHolderCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('Account Holder Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accountNumberCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.number,
                  decoration: fieldDecoration('Account Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: ifscCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('IFSC Code'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: upiCtrl,
                  style: textStyle,
                  decoration: fieldDecoration('UPI ID (Optional)'),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: defaultBank,
            onChanged: onDefaultBankChanged,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Mark as default bank for payouts'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: remarksCtrl,
            style: textStyle,
            maxLines: 2,
            decoration: fieldDecoration('Notes / Remarks'),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Register Company'),
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

class GradientScrollbar extends StatefulWidget {
  const GradientScrollbar({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<GradientScrollbar> createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<GradientScrollbar> {
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
                  final maxScrollExtent =
                      widget.controller.position.maxScrollExtent;
                  final minScrollExtent =
                      widget.controller.position.minScrollExtent;
                  final scrollExtent = maxScrollExtent - minScrollExtent;

                  if (scrollExtent <= 0) {
                    return const SizedBox.shrink();
                  }

                  final viewportDimension =
                      widget.controller.position.viewportDimension;
                  final thumbExtent = (viewportDimension /
                          (scrollExtent + viewportDimension)) *
                      constraints.maxWidth;
                  final scrollOffset =
                      widget.controller.position.pixels - minScrollExtent;
                  final thumbOffset = (scrollOffset / scrollExtent) *
                      (constraints.maxWidth - thumbExtent);

                  return GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true;
                        _dragStartPosition = details.localPosition.dx;
                        _dragStartScrollOffset =
                            widget.controller.position.pixels;
                      });
                    },
                    onPanUpdate: (details) {
                      if (_isDragging) {
                        final delta =
                            details.localPosition.dx - _dragStartPosition;
                        final scrollDelta =
                            (delta / (constraints.maxWidth - thumbExtent)) *
                                scrollExtent;
                        final newScrollOffset =
                            (_dragStartScrollOffset + scrollDelta).clamp(
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
                            left: thumbOffset.clamp(
                                0.0, constraints.maxWidth - thumbExtent),
                            width: thumbExtent.clamp(20.0, constraints.maxWidth),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF8C6A2F),
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

class CompanyViewTab extends StatefulWidget {
  const CompanyViewTab({
    super.key,
    required this.controller,
    required this.searchCtrl,
    required this.cityCtrl,
    required this.adminCtrl,
    required this.businessType,
    required this.financialYear,
    required this.status,
    required this.onBusinessTypeChanged,
    required this.onFinancialYearChanged,
    required this.onStatusChanged,
    required this.businessTypes,
    required this.financialYears,
    required this.onEdit,
  });

  final CompanyCreationController controller;
  final TextEditingController searchCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController adminCtrl;
  final String businessType;
  final String financialYear;
  final String status;
  final ValueChanged<String> onBusinessTypeChanged;
  final ValueChanged<String> onFinancialYearChanged;
  final ValueChanged<String> onStatusChanged;
  final List<String> businessTypes;
  final List<String> financialYears;
  final ValueChanged<CompanyRecord> onEdit;

  @override
  State<CompanyViewTab> createState() => _CompanyViewTabState();
}

class _CompanyViewTabState extends State<CompanyViewTab> {
  late final ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    final filtered = widget.controller.filterCompanies(
      query: widget.searchCtrl.text,
      businessType: widget.businessType,
      financialYear: widget.financialYear,
      status: widget.status,
      adminUsername: widget.adminCtrl.text,
      city: widget.cityCtrl.text,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.searchCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Search Company / City',
                    labelStyle: labelStyle,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => (context as Element).markNeedsBuild(),
                ),
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: widget.cityCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'City Filter',
                    labelStyle: labelStyle,
                  ),
                  onChanged: (_) => (context as Element).markNeedsBuild(),
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: widget.businessType,
                  decoration: InputDecoration(
                    labelText: 'Business Type',
                    labelStyle: labelStyle,
                  ),
                  isExpanded: true,
                  style: textStyle,
                  items: widget.businessTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onBusinessTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: widget.financialYear,
                  decoration: InputDecoration(
                    labelText: 'Financial Year',
                    labelStyle: labelStyle,
                  ),
                  isExpanded: true,
                  style: textStyle,
                  items: widget.financialYears
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onFinancialYearChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 180,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: widget.status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: labelStyle,
                  ),
                  isExpanded: true,
                  style: textStyle,
                  items: const ['All', 'Active', 'Inactive']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onStatusChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: widget.adminCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Admin Username',
                    labelStyle: labelStyle,
                  ),
                  onChanged: (_) => (context as Element).markNeedsBuild(),
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
            child: GradientScrollbar(
              controller: _horizontalScrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 48,
                  ),
                  child: DataTable(
              columns: const [
                DataColumn(label: Text('Login ID')),
                DataColumn(label: Text('Company Name')),
                DataColumn(label: Text('Mobile')),
                DataColumn(label: Text('Business Type')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Admin Username')),
                DataColumn(label: Text('Financial Year')),
                DataColumn(label: Text('Default Bank')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Created Date')),
              ],
              rows: filtered
                  .map(
                    (company) => DataRow(
                      cells: [
                        DataCell(
                          InkWell(
                            onTap: () => widget.onEdit(company),
                            child: Text(
                              company.loginId,
                              style: textStyle.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(company.companyName, style: textStyle)),
                        DataCell(Text(company.mobileNumber, style: textStyle)),
                        DataCell(Text(company.businessType, style: textStyle)),
                        DataCell(Text(company.city, style: textStyle)),
                        DataCell(Text(company.adminUsername, style: textStyle)),
                        DataCell(Text(company.financialYear, style: textStyle)),
                        DataCell(Text(company.defaultBankLabel, style: textStyle)),
                        DataCell(
                          Text(
                            company.status,
                            style: textStyle.copyWith(
                              color: company.status == 'Active'
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            company.formattedCreatedDate,
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
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

class EditTab extends StatelessWidget {
  EditTab({
    super.key,
    required this.selected,
    required this.companyNameCtrl,
    required this.mobileCtrl,
    required this.altContactCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.pincodeCtrl,
    required this.adminUsernameCtrl,
    required this.pinCtrl,
    required this.confirmPinCtrl,
    required this.businessType,
    required this.onBusinessTypeChanged,
    required this.financialYear,
    required this.onFinancialYearChanged,
    required this.bankNameCtrl,
    required this.accountHolderCtrl,
    required this.accountNumberCtrl,
    required this.ifscCtrl,
    required this.branchCtrl,
    required this.upiCtrl,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.remarksCtrl,
    required this.status,
    required this.onStatusChanged,
    required this.businessTypes,
    required this.financialYears,
    required this.accountTypes,
    required this.defaultBank,
    required this.onDefaultBankChanged,
    required this.onSave,
    required this.onCancel,
    required this.reasonCtrl,
    required this.onDelete,
  });

  final CompanyRecord? selected;
  final TextEditingController companyNameCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController altContactCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController adminUsernameCtrl;
  final TextEditingController pinCtrl;
  final TextEditingController confirmPinCtrl;
  final String businessType;
  final ValueChanged<String> onBusinessTypeChanged;
  final String financialYear;
  final ValueChanged<String> onFinancialYearChanged;
  final TextEditingController bankNameCtrl;
  final TextEditingController accountHolderCtrl;
  final TextEditingController accountNumberCtrl;
  final TextEditingController ifscCtrl;
  final TextEditingController branchCtrl;
  final TextEditingController upiCtrl;
  final String accountType;
  final ValueChanged<String> onAccountTypeChanged;
  final TextEditingController remarksCtrl;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final List<String> businessTypes;
  final List<String> financialYears;
  final List<String> accountTypes;
  final bool defaultBank;
  final ValueChanged<bool?> onDefaultBankChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final TextEditingController reasonCtrl;
  final Future<void> Function(
    CompanyRecord record, {
    required bool hard,
    required String reason,
  }) onDelete;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    InputDecoration decoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      );
    }

    if (selected == null) {
      return const Center(child: Text('Select a company to edit'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selected!.companyName} (${selected!.companyId})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: financialYear,
                  decoration: decoration('Financial Year'),
                  isExpanded: true,
                  style: textStyle,
                  items: financialYears
                      .map(
                        (year) => DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onFinancialYearChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 300,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: businessType,
                  decoration: decoration('Business Type'),
                  isExpanded: true,
                  style: textStyle,
                  items: businessTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onBusinessTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 260,
                height: 48,
                child: TextField(
                  controller: companyNameCtrl,
                  style: textStyle,
                  decoration: decoration('Company Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: mobileCtrl,
                  style: textStyle,
                  decoration: decoration('Mobile Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: altContactCtrl,
                  style: textStyle,
                  decoration: decoration('Alternate Contact (Optional)'),
                ),
              ),
              SizedBox(
                width: 320,
                height: 48,
                child: TextField(
                  controller: addressCtrl,
                  style: textStyle,
                  decoration: decoration('Address'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: cityCtrl,
                  style: textStyle,
                  decoration: decoration('City'),
                ),
              ),
              SizedBox(
                width: 140,
                height: 48,
                child: TextField(
                  controller: pincodeCtrl,
                  style: textStyle,
                  decoration: decoration('Pincode'),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: adminUsernameCtrl,
                  style: textStyle,
                  decoration: decoration('Admin Username'),
                ),
              ),
              SizedBox(
                width: 180,
                height: 48,
                child: TextField(
                  controller: pinCtrl,
                  style: textStyle,
                  obscureText: true,
                  decoration: decoration('New Access PIN'),
                ),
              ),
              SizedBox(
                width: 180,
                height: 48,
                child: TextField(
                  controller: confirmPinCtrl,
                  style: textStyle,
                  obscureText: true,
                  decoration: decoration('Confirm PIN'),
                ),
              ),
              SizedBox(
                width: 180,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: decoration('Status'),
                  isExpanded: true,
                  style: textStyle,
                  items: const ['Active', 'Inactive']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onStatusChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Bank Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: bankNameCtrl,
                  style: textStyle,
                  decoration: decoration('Bank Name'),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: branchCtrl,
                  style: textStyle,
                  decoration: decoration('Branch Name'),
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: accountType,
                  decoration: decoration('Account Type'),
                  isExpanded: true,
                  style: textStyle,
                  items: accountTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onAccountTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: accountHolderCtrl,
                  style: textStyle,
                  decoration: decoration('Account Holder Name'),
                ),
              ),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: accountNumberCtrl,
                  style: textStyle,
                  decoration: decoration('Account Number'),
                ),
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: ifscCtrl,
                  style: textStyle,
                  decoration: decoration('IFSC Code'),
                ),
              ),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: upiCtrl,
                  style: textStyle,
                  decoration: decoration('UPI ID (Optional)'),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: defaultBank,
            onChanged: onDefaultBankChanged,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Mark as default bank'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: remarksCtrl,
            style: textStyle,
            maxLines: 2,
            decoration: decoration('Remarks'),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () async {
                    final result = await showDialog<_DeleteResult>(
                      context: context,
                      builder: (context) => _DeleteDialog(
                        record: selected!,
                        reasonCtrl: reasonCtrl,
                      ),
                    );
                    if (result == null) return;
                    await onDelete(
                      selected!,
                      hard: result.hardDelete,
                      reason: result.reason,
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
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

class _DeleteResult {
  _DeleteResult({required this.hardDelete, required this.reason});

  final bool hardDelete;
  final String reason;
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog({required this.record, required this.reasonCtrl});

  final CompanyRecord record;
  final TextEditingController reasonCtrl;

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  bool hardDelete = false;

  @override
  void initState() {
    super.initState();
    widget.reasonCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    return AlertDialog(
      title: const Text('Confirm Company Delete'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company: ${widget.record.companyName}'),
          Text('Admin: ${widget.record.adminUsername}'),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: hardDelete,
            onChanged: (value) => setState(() => hardDelete = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Hard Delete (irreversible)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.reasonCtrl,
            style: textStyle,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Reason / Notes',
              labelStyle: labelStyle,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Soft delete keeps the profile for audit. Hard delete removes it permanently.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: hardDelete ? AppColors.danger : AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              _DeleteResult(
                hardDelete: hardDelete,
                reason: widget.reasonCtrl.text.trim(),
              ),
            );
          },
          child: Text(hardDelete ? 'Hard Delete' : 'Soft Delete'),
        ),
      ],
    );
  }
}


