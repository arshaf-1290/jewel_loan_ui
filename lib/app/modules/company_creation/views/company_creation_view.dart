import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/company_creation_controller.dart';
import 'company_creation_ui_builders.dart';

class CompanyCreationView extends StatefulWidget {
  const CompanyCreationView({super.key});

  @override
  State<CompanyCreationView> createState() => _CompanyCreationViewState();
}

class _CompanyCreationViewState extends State<CompanyCreationView>
    with TickerProviderStateMixin {
  late final CompanyCreationController controller;
  late TabController tabController;
  bool _showEditTab = false;
  bool _editLocked = false;

  // Entry controllers
  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController gstCtrl = TextEditingController();
  final TextEditingController altContactCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController adminUsernameCtrl = TextEditingController();
  final TextEditingController accessPinCtrl = TextEditingController();
  final TextEditingController confirmPinCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController accountHolderCtrl = TextEditingController();
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController ifscCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();
  final TextEditingController upiCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  // View filters
  final TextEditingController viewSearchCtrl = TextEditingController();
  final TextEditingController viewCityCtrl = TextEditingController();
  final TextEditingController viewAdminCtrl = TextEditingController();

  // Edit controllers
  final TextEditingController editCompanyNameCtrl = TextEditingController();
  final TextEditingController editMobileCtrl = TextEditingController();
  final TextEditingController editAltContactCtrl = TextEditingController();
  final TextEditingController editAddressCtrl = TextEditingController();
  final TextEditingController editCityCtrl = TextEditingController();
  final TextEditingController editPincodeCtrl = TextEditingController();
  final TextEditingController editAdminUsernameCtrl = TextEditingController();
  final TextEditingController editPinCtrl = TextEditingController();
  final TextEditingController editConfirmPinCtrl = TextEditingController();
  final TextEditingController editBankNameCtrl = TextEditingController();
  final TextEditingController editAccountHolderCtrl = TextEditingController();
  final TextEditingController editAccountNumberCtrl = TextEditingController();
  final TextEditingController editIfscCtrl = TextEditingController();
  final TextEditingController editBranchCtrl = TextEditingController();
  final TextEditingController editUpiCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();

  final TextEditingController deleteReasonCtrl = TextEditingController();

  String _businessType = CompanyCreationController.businessTypes.first;
  late String _financialYear;
  String _accountType = CompanyCreationController.accountTypes[1];
  bool _defaultBank = true;
  late String _companyId;
  late String _loginId;

  // View filters state
  String _viewBusinessType = 'All';
  String _viewFinancialYear = 'All';
  String _viewStatus = 'All';

  // Edit state
  CompanyRecord? _selectedCompany;
  String _editBusinessType = CompanyCreationController.businessTypes.first;
  late String _editFinancialYear;
  String _editAccountType = CompanyCreationController.accountTypes[1];
  String _editStatus = 'Active';
  bool _editDefaultBank = false;

  @override
  void initState() {
    super.initState();
    controller = CompanyCreationController();
    _initTabController(initialIndex: 0);
    final now = DateTime.now();
    _financialYear = controller.financialYears.first;
    _editFinancialYear = _financialYear;
    _companyId = controller.generateCompanyId(now);
    _loginId = controller.generateLoginId(now);
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    companyNameCtrl.dispose();
    mobileCtrl.dispose();
    gstCtrl.dispose();
    altContactCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    pincodeCtrl.dispose();
    adminUsernameCtrl.dispose();
    accessPinCtrl.dispose();
    confirmPinCtrl.dispose();
    bankNameCtrl.dispose();
    accountHolderCtrl.dispose();
    accountNumberCtrl.dispose();
    ifscCtrl.dispose();
    branchCtrl.dispose();
    upiCtrl.dispose();
    remarksCtrl.dispose();
    viewSearchCtrl.dispose();
    viewCityCtrl.dispose();
    viewAdminCtrl.dispose();
    editCompanyNameCtrl.dispose();
    editMobileCtrl.dispose();
    editAltContactCtrl.dispose();
    editAddressCtrl.dispose();
    editCityCtrl.dispose();
    editPincodeCtrl.dispose();
    editAdminUsernameCtrl.dispose();
    editPinCtrl.dispose();
    editConfirmPinCtrl.dispose();
    editBankNameCtrl.dispose();
    editAccountHolderCtrl.dispose();
    editAccountNumberCtrl.dispose();
    editIfscCtrl.dispose();
    editBranchCtrl.dispose();
    editUpiCtrl.dispose();
    editRemarksCtrl.dispose();
    deleteReasonCtrl.dispose();
    super.dispose();
  }

  void _initTabController({int initialIndex = 0}) {
    final length = _showEditTab ? 3 : 2;
    tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: initialIndex.clamp(0, length - 1),
    );
    tabController.addListener(_onTabControllerChanged);
  }

  void _reinitializeTabController({int initialIndex = 0}) {
    tabController.dispose();
    _initTabController(initialIndex: initialIndex);
  }

  void _onTabControllerChanged() {
    if (tabController.indexIsChanging) return;

    if (_editLocked && _showEditTab &&
        tabController.index != tabController.length - 1) {
      final target = tabController.length - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_editLocked || !_showEditTab) return;
        tabController.animateTo(target);
        _showSnackBar(
          'Please update, delete, or cancel before leaving edit.',
        );
      });
    }

    setState(() {});
  }

  void _openEditWithCompany(CompanyRecord record) {
    if (!_showEditTab) {
      setState(() {
        _showEditTab = true;
        _editLocked = true;
      });
      _reinitializeTabController(initialIndex: 2);
    } else {
      setState(() {
        _editLocked = true;
      });
      tabController.animateTo(2);
    }
    _selectCompany(record);
  }

  void _cancelEdit() {
    if (!_showEditTab) return;
    setState(() {
      _editLocked = false;
      _showEditTab = false;
      _selectedCompany = null;
    });
    _reinitializeTabController(initialIndex: 1);
  }

  void _resetEntryForm() {
    companyNameCtrl.clear();
    mobileCtrl.clear();
    gstCtrl.clear();
    altContactCtrl.clear();
    addressCtrl.clear();
    cityCtrl.clear();
    pincodeCtrl.clear();
    adminUsernameCtrl.clear();
    accessPinCtrl.clear();
    confirmPinCtrl.clear();
    bankNameCtrl.clear();
    accountHolderCtrl.clear();
    accountNumberCtrl.clear();
    ifscCtrl.clear();
    branchCtrl.clear();
    upiCtrl.clear();
    remarksCtrl.clear();
    setState(() {
      _businessType = CompanyCreationController.businessTypes.first;
      _financialYear = controller.financialYears.first;
      _accountType = CompanyCreationController.accountTypes[1];
      _defaultBank = true;
      final now = DateTime.now();
      _companyId = controller.generateCompanyId(now);
      _loginId = controller.generateLoginId(now);
    });
  }

  bool _hasBankDetails({
    required TextEditingController bankCtrl,
    required TextEditingController accountHolder,
    required TextEditingController accountNumber,
    required TextEditingController ifsc,
    required TextEditingController branch,
  }) {
    return bankCtrl.text.trim().isNotEmpty &&
        accountHolder.text.trim().isNotEmpty &&
        accountNumber.text.trim().isNotEmpty &&
        ifsc.text.trim().isNotEmpty &&
        branch.text.trim().isNotEmpty;
  }

  CompanyBankDetails? _buildBankDetails({
    required TextEditingController bankCtrl,
    required TextEditingController accountHolder,
    required TextEditingController accountNumber,
    required TextEditingController ifsc,
    required TextEditingController branch,
    required TextEditingController upi,
    required String accountType,
  }) {
    if (!_hasBankDetails(
      bankCtrl: bankCtrl,
      accountHolder: accountHolder,
      accountNumber: accountNumber,
      ifsc: ifsc,
      branch: branch,
    )) {
      return null;
    }
    return CompanyBankDetails(
      bankName: bankCtrl.text.trim(),
      accountHolderName: accountHolder.text.trim(),
      accountNumber: accountNumber.text.trim(),
      ifscCode: ifsc.text.trim(),
      branchName: branch.text.trim(),
      accountType: accountType,
      upiId: upi.text.trim().isEmpty ? null : upi.text.trim(),
    );
  }

  void _handleEntrySubmit() {
    if (companyNameCtrl.text.trim().isEmpty ||
        mobileCtrl.text.trim().isEmpty ||
        adminUsernameCtrl.text.trim().isEmpty ||
        accessPinCtrl.text.trim().length < 4 ||
        confirmPinCtrl.text.trim().isEmpty) {
      _showSnackBar('Please fill the required fields and PIN.');
      return;
    }
    if (accessPinCtrl.text.trim() != confirmPinCtrl.text.trim()) {
      _showSnackBar('Access PIN and Confirm PIN must match.');
      return;
    }
    final now = DateTime.now();
    final bank = _buildBankDetails(
      bankCtrl: bankNameCtrl,
      accountHolder: accountHolderCtrl,
      accountNumber: accountNumberCtrl,
      ifsc: ifscCtrl,
      branch: branchCtrl,
      upi: upiCtrl,
      accountType: _accountType,
    );
    final record = CompanyRecord(
      companyId: _companyId,
      loginId: _loginId,
      companyName: companyNameCtrl.text.trim(),
      mobileNumber: mobileCtrl.text.trim(),
      alternateContact:
          altContactCtrl.text.trim().isEmpty ? null : altContactCtrl.text.trim(),
      gstNumber: gstCtrl.text.trim().isEmpty ? null : gstCtrl.text.trim(),
      businessType: _businessType,
      addressLine: addressCtrl.text.trim(),
      city: cityCtrl.text.trim(),
      pincode: pincodeCtrl.text.trim(),
      adminUsername: adminUsernameCtrl.text.trim(),
      accessPin: accessPinCtrl.text.trim(),
      financialYear: _financialYear,
      bankDetails: bank,
      isDefaultBank: bank != null && _defaultBank,
      createdDate: now,
      status: 'Active',
      remarks: remarksCtrl.text.trim().isEmpty ? null : remarksCtrl.text.trim(),
    );
    controller.addCompany(record);
    _showSnackBar('Company created successfully.');
    _resetEntryForm();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selectCompany(CompanyRecord record) {
    setState(() {
      _selectedCompany = record;
      editCompanyNameCtrl.text = record.companyName;
      editMobileCtrl.text = record.mobileNumber;
      editAltContactCtrl.text = record.alternateContact ?? '';
      editAddressCtrl.text = record.addressLine;
      editCityCtrl.text = record.city;
      editPincodeCtrl.text = record.pincode;
      editAdminUsernameCtrl.text = record.adminUsername;
      editRemarksCtrl.text = record.remarks ?? '';
      _editBusinessType = record.businessType;
      _editFinancialYear = record.financialYear;
      _editStatus = record.status;
      final bank = record.bankDetails;
      if (bank != null) {
        editBankNameCtrl.text = bank.bankName;
        editAccountHolderCtrl.text = bank.accountHolderName;
        editAccountNumberCtrl.text = bank.accountNumber;
        editIfscCtrl.text = bank.ifscCode;
        editBranchCtrl.text = bank.branchName;
        editUpiCtrl.text = bank.upiId ?? '';
        _editAccountType = bank.accountType;
      } else {
        editBankNameCtrl.clear();
        editAccountHolderCtrl.clear();
        editAccountNumberCtrl.clear();
        editIfscCtrl.clear();
        editBranchCtrl.clear();
        editUpiCtrl.clear();
        _editAccountType = CompanyCreationController.accountTypes[1];
      }
      _editDefaultBank = record.isDefaultBank;
      editPinCtrl.clear();
      editConfirmPinCtrl.clear();
    });
  }

  void _handleSaveEdit() {
    if (_selectedCompany == null) {
      _showSnackBar('Please select a company to edit.');
      return;
    }
    if (editCompanyNameCtrl.text.trim().isEmpty ||
        editMobileCtrl.text.trim().isEmpty ||
        editAdminUsernameCtrl.text.trim().isEmpty) {
      _showSnackBar('Company Name, Mobile and Admin Username are required.');
      return;
    }
    String accessPin = _selectedCompany!.accessPin;
    if (editPinCtrl.text.trim().isNotEmpty ||
        editConfirmPinCtrl.text.trim().isNotEmpty) {
      if (editPinCtrl.text.trim() != editConfirmPinCtrl.text.trim()) {
        _showSnackBar('Access PIN confirmation failed.');
        return;
      }
      if (editPinCtrl.text.trim().length < 4) {
        _showSnackBar('Access PIN must be at least 4 digits.');
        return;
      }
      accessPin = editPinCtrl.text.trim();
    }
    final bank = _buildBankDetails(
      bankCtrl: editBankNameCtrl,
      accountHolder: editAccountHolderCtrl,
      accountNumber: editAccountNumberCtrl,
      ifsc: editIfscCtrl,
      branch: editBranchCtrl,
      upi: editUpiCtrl,
      accountType: _editAccountType,
    );
    final updated = _selectedCompany!.copyWith(
      companyName: editCompanyNameCtrl.text.trim(),
      mobileNumber: editMobileCtrl.text.trim(),
      alternateContact: editAltContactCtrl.text.trim().isEmpty
          ? null
          : editAltContactCtrl.text.trim(),
      businessType: _editBusinessType,
      addressLine: editAddressCtrl.text.trim(),
      city: editCityCtrl.text.trim(),
      pincode: editPincodeCtrl.text.trim(),
      adminUsername: editAdminUsernameCtrl.text.trim(),
      accessPin: accessPin,
      financialYear: _editFinancialYear,
      bankDetails: bank,
      isDefaultBank: bank != null && _editDefaultBank,
      status: _editStatus,
      remarks:
          editRemarksCtrl.text.trim().isEmpty ? null : editRemarksCtrl.text.trim(),
      lastEditedBy: 'Super Admin',
      lastEditedAt: DateTime.now(),
    );
    controller.updateCompany(updated.companyId, updated);
    setState(() {
      _selectedCompany = updated;
      _editLocked = false;
      _showEditTab = false;
    });
    _showSnackBar('Company profile updated.');
    _reinitializeTabController(initialIndex: 1);
  }

  Future<void> _handleDelete(
    CompanyRecord record, {
    required bool hard,
    required String reason,
  }) async {
    if (hard) {
      controller.hardDelete(record.companyId);
      if (_selectedCompany?.companyId == record.companyId) {
        setState(() {
          _selectedCompany = null;
        });
      }
      _showSnackBar('Company permanently removed.');
    } else {
      controller.softDelete(record.companyId, reason);
      _showSnackBar('Company marked as inactive.');
    }
    setState(() {
      _editLocked = false;
      _showEditTab = false;
      _selectedCompany = null;
    });
    _reinitializeTabController(initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final financialYears = controller.financialYears;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border.withOpacity(0.6)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                      ),
                      TabBar(
                        controller: tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor:
                            AppColors.onSurface.withOpacity(0.6),
                        indicatorColor: AppColors.primary,
                        tabs: [
                          const Tab(text: 'Company Entry'),
                          const Tab(text: 'Company View'),
                          if (_showEditTab) const Tab(text: 'Company Edit'),
                        ],
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            EntryTab(
                              companyId: _companyId,
                              loginId: _loginId,
                              companyNameCtrl: companyNameCtrl,
                              mobileCtrl: mobileCtrl,
                              gstCtrl: gstCtrl,
                              altContactCtrl: altContactCtrl,
                              addressCtrl: addressCtrl,
                              cityCtrl: cityCtrl,
                              pincodeCtrl: pincodeCtrl,
                              adminUsernameCtrl: adminUsernameCtrl,
                              accessPinCtrl: accessPinCtrl,
                              confirmPinCtrl: confirmPinCtrl,
                              businessType: _businessType,
                              onBusinessTypeChanged: (value) =>
                                  setState(() => _businessType = value),
                              financialYear: _financialYear,
                              onFinancialYearChanged: (value) =>
                                  setState(() => _financialYear = value),
                              bankNameCtrl: bankNameCtrl,
                              accountHolderCtrl: accountHolderCtrl,
                              accountNumberCtrl: accountNumberCtrl,
                              ifscCtrl: ifscCtrl,
                              branchCtrl: branchCtrl,
                              upiCtrl: upiCtrl,
                              accountType: _accountType,
                              onAccountTypeChanged: (value) =>
                                  setState(() => _accountType = value),
                              remarksCtrl: remarksCtrl,
                              businessTypes: CompanyCreationController.businessTypes,
                              financialYears: financialYears,
                              accountTypes: CompanyCreationController.accountTypes,
                              defaultBank: _defaultBank,
                              onDefaultBankChanged: (value) =>
                                  setState(() => _defaultBank = value ?? false),
                              onSubmit: _handleEntrySubmit,
                            ),
                            CompanyViewTab(
                              controller: controller,
                              searchCtrl: viewSearchCtrl,
                              cityCtrl: viewCityCtrl,
                              adminCtrl: viewAdminCtrl,
                              businessType: _viewBusinessType,
                              financialYear: _viewFinancialYear,
                              status: _viewStatus,
                              onBusinessTypeChanged: (value) =>
                                  setState(() => _viewBusinessType = value),
                              onFinancialYearChanged: (value) =>
                                  setState(() => _viewFinancialYear = value),
                              onStatusChanged: (value) =>
                                  setState(() => _viewStatus = value),
                              businessTypes: const [
                                'All',
                                ...CompanyCreationController.businessTypes
                              ],
                              financialYears: ['All', ...financialYears],
                              onEdit: _openEditWithCompany,
                            ),
                            if (_showEditTab)
                              EditTab(
                              selected: _selectedCompany,
                              companyNameCtrl: editCompanyNameCtrl,
                              mobileCtrl: editMobileCtrl,
                              altContactCtrl: editAltContactCtrl,
                              addressCtrl: editAddressCtrl,
                              cityCtrl: editCityCtrl,
                              pincodeCtrl: editPincodeCtrl,
                              adminUsernameCtrl: editAdminUsernameCtrl,
                              pinCtrl: editPinCtrl,
                              confirmPinCtrl: editConfirmPinCtrl,
                              businessType: _editBusinessType,
                              onBusinessTypeChanged: (value) =>
                                  setState(() => _editBusinessType = value),
                              financialYear: _editFinancialYear,
                              onFinancialYearChanged: (value) =>
                                  setState(() => _editFinancialYear = value),
                              bankNameCtrl: editBankNameCtrl,
                              accountHolderCtrl: editAccountHolderCtrl,
                              accountNumberCtrl: editAccountNumberCtrl,
                              ifscCtrl: editIfscCtrl,
                              branchCtrl: editBranchCtrl,
                              upiCtrl: editUpiCtrl,
                              accountType: _editAccountType,
                              onAccountTypeChanged: (value) =>
                                  setState(() => _editAccountType = value),
                              remarksCtrl: editRemarksCtrl,
                              status: _editStatus,
                              onStatusChanged: (value) =>
                                  setState(() => _editStatus = value),
                              businessTypes: CompanyCreationController.businessTypes,
                              financialYears: financialYears,
                              accountTypes: CompanyCreationController.accountTypes,
                              defaultBank: _editDefaultBank,
                              onDefaultBankChanged: (value) =>
                                  setState(() => _editDefaultBank = value ?? false),
                              onSave: _handleSaveEdit,
                              onCancel: _cancelEdit,
                              reasonCtrl: deleteReasonCtrl,
                              onDelete: _handleDelete,
                            ),
                          ],
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

// Legacy widget implementations retained for reference only.
/*
class _EntryTab extends StatelessWidget {
  const _EntryTab({
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
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: color, width: 1.1),
          );
      final subtle = AppColors.border.withOpacity(0.7);
      return InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        helperText: helperText,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          //     TextField(
          //   controller: remarksCtrl,
          //   style: textStyle,
          //   maxLines: 2,
          //   decoration: fieldDecoration('Notes / Remarks'),
          // ),
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
                height: 40,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyViewTab extends StatelessWidget {
  const _CompanyViewTab({
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
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      color: AppColors.onSurface,
    );
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );
    final filtered = controller.filterCompanies(
      query: searchCtrl.text,
      businessType: businessType,
      financialYear: financialYear,
      status: status,
      adminUsername: adminCtrl.text,
      city: cityCtrl.text,
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
                  controller: searchCtrl,
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
                  controller: cityCtrl,
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
                  value: businessType,
                  decoration: InputDecoration(
                    labelText: 'Business Type',
                    labelStyle: labelStyle,
                  ),
                  isExpanded: true,
                  style: textStyle,
                  items: businessTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onBusinessTypeChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: financialYear,
                  decoration: InputDecoration(
                    labelText: 'Financial Year',
                    labelStyle: labelStyle,
                  ),
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
                width: 180,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: status,
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
                    if (value != null) onStatusChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: adminCtrl,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                            onTap: () => onEdit(company),
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
        ],
      ),
    );
  }
}

class _EditTab extends StatelessWidget {
  _EditTab({
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
                              decoration:
                                  decoration('Alternate Contact (Optional)'),
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
*/
