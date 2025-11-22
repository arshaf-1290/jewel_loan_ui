import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/customer_creation_controller.dart';

class CustomerCreationView extends StatefulWidget {
  const CustomerCreationView({super.key});

  @override
  State<CustomerCreationView> createState() => _CustomerCreationViewState();
}

class _CustomerCreationViewState extends State<CustomerCreationView>
    with TickerProviderStateMixin {
  late final CustomerCreationController controller;
  late TabController tabController;

  final TextEditingController customerIdCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  String _gender = 'Male';
  DateTime _dob = DateTime(1990, 1, 1);
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController altMobileCtrl = TextEditingController();
  final TextEditingController address1Ctrl = TextEditingController();
  final TextEditingController address2Ctrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();

  String _idProofType = 'Aadhaar';
  final TextEditingController idProofNumberCtrl = TextEditingController();
  String _addressProofType = 'Aadhaar';
  final TextEditingController addressProofNumberCtrl = TextEditingController();

  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController accountHolderCtrl = TextEditingController();
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController ifscCtrl = TextEditingController();
  final TextEditingController branchCtrl = TextEditingController();
  final TextEditingController upiCtrl = TextEditingController();

  final TextEditingController referralNameCtrl = TextEditingController();
  final TextEditingController referralMobileCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  // Filters
  final TextEditingController searchCtrl = TextEditingController();
  String _filterCity = 'All';
  String _filterStatus = 'All';

  // Edit
  CustomerRecord? _editingRecord;
  final TextEditingController editMobileCtrl = TextEditingController();
  final TextEditingController editAltMobileCtrl = TextEditingController();
  final TextEditingController editAddress1Ctrl = TextEditingController();
  final TextEditingController editAddress2Ctrl = TextEditingController();
  final TextEditingController editCityCtrl = TextEditingController();
  final TextEditingController editStateCtrl = TextEditingController();
  final TextEditingController editPincodeCtrl = TextEditingController();
  final TextEditingController editBankNameCtrl = TextEditingController();
  final TextEditingController editAccountHolderCtrl = TextEditingController();
  final TextEditingController editAccountNumberCtrl = TextEditingController();
  final TextEditingController editIfscCtrl = TextEditingController();
  final TextEditingController editBranchCtrl = TextEditingController();
  final TextEditingController editUpiCtrl = TextEditingController();
  final TextEditingController editReferralNameCtrl = TextEditingController();
  final TextEditingController editReferralMobileCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();

  bool _showEditTab = false;
  bool _kycVerified = false;
  String _status = 'Active';
  String _editStatus = 'Active';

  final TextEditingController deleteReasonCtrl = TextEditingController();

  int get _tabCount => 2 + (_showEditTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? _tabCount - 1 : -1;

  @override
  void initState() {
    super.initState();
    controller = CustomerCreationController();
    tabController = TabController(length: _tabCount, vsync: this);
    _syncInitialId();
  }

  void _syncInitialId() {
    final nextId = controller.generateNextCustomerId(DateTime.now());
    customerIdCtrl.text = nextId;
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    customerIdCtrl.dispose();
    fullNameCtrl.dispose();
    mobileCtrl.dispose();
    altMobileCtrl.dispose();
    address1Ctrl.dispose();
    address2Ctrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    idProofNumberCtrl.dispose();
    addressProofNumberCtrl.dispose();
    bankNameCtrl.dispose();
    accountHolderCtrl.dispose();
    accountNumberCtrl.dispose();
    ifscCtrl.dispose();
    branchCtrl.dispose();
    upiCtrl.dispose();
    referralNameCtrl.dispose();
    referralMobileCtrl.dispose();
    remarksCtrl.dispose();
    searchCtrl.dispose();
    editMobileCtrl.dispose();
    editAltMobileCtrl.dispose();
    editAddress1Ctrl.dispose();
    editAddress2Ctrl.dispose();
    editCityCtrl.dispose();
    editStateCtrl.dispose();
    editPincodeCtrl.dispose();
    editBankNameCtrl.dispose();
    editAccountHolderCtrl.dispose();
    editAccountNumberCtrl.dispose();
    editIfscCtrl.dispose();
    editBranchCtrl.dispose();
    editUpiCtrl.dispose();
    editReferralNameCtrl.dispose();
    editReferralMobileCtrl.dispose();
    editRemarksCtrl.dispose();
    deleteReasonCtrl.dispose();
    super.dispose();
  }

  void _resetTabController(int targetIndex) {
    final old = tabController;
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: targetIndex.clamp(0, _tabCount - 1),
    );
    old.dispose();
  }

  void _handleTabTap(int index) {
    if (!_showEditTab) return;
    if (index == _editTabIndex) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Customer Entry and Customer View are locked while editing. Save or cancel to continue.',
        ),
      ),
    );
    tabController.animateTo(_editTabIndex);
  }

  void _resetEntryForm() {
    setState(() {
      fullNameCtrl.clear();
      _gender = 'Male';
      _dob = DateTime(1990, 1, 1);
      mobileCtrl.clear();
      altMobileCtrl.clear();
      address1Ctrl.clear();
      address2Ctrl.clear();
      cityCtrl.clear();
      stateCtrl.clear();
      pincodeCtrl.clear();
      _idProofType = 'Aadhaar';
      idProofNumberCtrl.clear();
      _addressProofType = 'Aadhaar';
      addressProofNumberCtrl.clear();
      bankNameCtrl.clear();
      accountHolderCtrl.clear();
      accountNumberCtrl.clear();
      ifscCtrl.clear();
      branchCtrl.clear();
      upiCtrl.clear();
      referralNameCtrl.clear();
      referralMobileCtrl.clear();
      remarksCtrl.clear();
      _kycVerified = false;
      _status = 'Active';
      _syncInitialId();
    });
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  void _handleEntrySubmit() {
    final id = customerIdCtrl.text.trim();
    final name = fullNameCtrl.text.trim();
    final mobile = mobileCtrl.text.trim();
    if (id.isEmpty || name.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill required fields marked *')),
      );
      return;
    }

    final record = CustomerRecord(
      customerId: id,
      fullName: name,
      gender: _gender,
      dob: _dob,
      mobile: mobile,
      altMobile: altMobileCtrl.text.trim().isEmpty
          ? null
          : altMobileCtrl.text.trim(),
      addressLine1: address1Ctrl.text.trim(),
      addressLine2:
          address2Ctrl.text.trim().isEmpty ? null : address2Ctrl.text.trim(),
      city: cityCtrl.text.trim(),
      state: stateCtrl.text.trim(),
      pincode: pincodeCtrl.text.trim(),
      idProofType: _idProofType,
      idProofNumber: idProofNumberCtrl.text.trim(),
      addressProofType: _addressProofType,
      addressProofNumber: addressProofNumberCtrl.text.trim().isEmpty
          ? null
          : addressProofNumberCtrl.text.trim(),
      bankName:
          bankNameCtrl.text.trim().isEmpty ? null : bankNameCtrl.text.trim(),
      accountHolderName: accountHolderCtrl.text.trim().isEmpty
          ? null
          : accountHolderCtrl.text.trim(),
      accountNumber: accountNumberCtrl.text.trim().isEmpty
          ? null
          : accountNumberCtrl.text.trim(),
      ifscCode:
          ifscCtrl.text.trim().isEmpty ? null : ifscCtrl.text.trim().toUpperCase(),
      branchName:
          branchCtrl.text.trim().isEmpty ? null : branchCtrl.text.trim(),
      upiId: upiCtrl.text.trim().isEmpty ? null : upiCtrl.text.trim(),
      referralName: referralNameCtrl.text.trim().isEmpty
          ? null
          : referralNameCtrl.text.trim(),
      referralMobile: referralMobileCtrl.text.trim().isEmpty
          ? null
          : referralMobileCtrl.text.trim(),
      remarks: remarksCtrl.text.trim().isEmpty
          ? null
          : remarksCtrl.text.trim(),
      kycVerified: _kycVerified,
      status: _status,
    );

    controller.addCustomer(record);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer saved successfully.')),
    );
    _resetEntryForm();
  }

  void _openEdit(CustomerRecord record) {
    setState(() {
      _editingRecord = record;
      _showEditTab = true;
      editMobileCtrl.text = record.mobile;
      editAltMobileCtrl.text = record.altMobile ?? '';
      editAddress1Ctrl.text = record.addressLine1;
      editAddress2Ctrl.text = record.addressLine2 ?? '';
      editCityCtrl.text = record.city;
      editStateCtrl.text = record.state;
      editPincodeCtrl.text = record.pincode;
      editBankNameCtrl.text = record.bankName ?? '';
      editAccountHolderCtrl.text = record.accountHolderName ?? '';
      editAccountNumberCtrl.text = record.accountNumber ?? '';
      editIfscCtrl.text = record.ifscCode ?? '';
      editBranchCtrl.text = record.branchName ?? '';
      editUpiCtrl.text = record.upiId ?? '';
      editReferralNameCtrl.text = record.referralName ?? '';
      editReferralMobileCtrl.text = record.referralMobile ?? '';
      editRemarksCtrl.text = record.remarks ?? '';
      _editStatus = record.status;
    });
    _resetTabController(_editTabIndex);
    tabController.animateTo(_editTabIndex);
  }

  void _handleEditSave() {
    final record = _editingRecord;
    if (record == null) return;
    final updated = record.copyWith(
      mobile: editMobileCtrl.text.trim(),
      altMobile: editAltMobileCtrl.text.trim().isEmpty
          ? null
          : editAltMobileCtrl.text.trim(),
      addressLine1: editAddress1Ctrl.text.trim(),
      addressLine2: editAddress2Ctrl.text.trim().isEmpty
          ? null
          : editAddress2Ctrl.text.trim(),
      city: editCityCtrl.text.trim(),
      state: editStateCtrl.text.trim(),
      pincode: editPincodeCtrl.text.trim(),
      bankName: editBankNameCtrl.text.trim().isEmpty
          ? null
          : editBankNameCtrl.text.trim(),
      accountHolderName: editAccountHolderCtrl.text.trim().isEmpty
          ? null
          : editAccountHolderCtrl.text.trim(),
      accountNumber: editAccountNumberCtrl.text.trim().isEmpty
          ? null
          : editAccountNumberCtrl.text.trim(),
      ifscCode: editIfscCtrl.text.trim().isEmpty
          ? null
          : editIfscCtrl.text.trim().toUpperCase(),
      branchName: editBranchCtrl.text.trim().isEmpty
          ? null
          : editBranchCtrl.text.trim(),
      upiId:
          editUpiCtrl.text.trim().isEmpty ? null : editUpiCtrl.text.trim(),
      referralName: editReferralNameCtrl.text.trim().isEmpty
          ? null
          : editReferralNameCtrl.text.trim(),
      referralMobile: editReferralMobileCtrl.text.trim().isEmpty
          ? null
          : editReferralMobileCtrl.text.trim(),
      remarks: editRemarksCtrl.text.trim().isEmpty
          ? null
          : editRemarksCtrl.text.trim(),
      status: _editStatus,
    );
    controller.updateCustomer(record.customerId, updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer updated successfully.')),
    );
  }

  void _cancelEdit() {
    if (!_showEditTab) return;
    setState(() {
      _editingRecord = null;
      _showEditTab = false;
    });
    _resetTabController(1);
  }

  Future<void> _handleDelete(CustomerRecord record) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer ID: ${record.customerId}'),
              Text('Name: ${record.fullName}'),
              const SizedBox(height: 12),
              const Text(
                'Soft delete will mark the customer as Inactive but keep all linked records.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deleteReasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reason for delete',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Soft Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final reason = deleteReasonCtrl.text.trim();
      if (reason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reason is required to delete.')),
        );
        return;
      }
      controller.softDelete(record.customerId, reason);
      if (_editingRecord?.customerId == record.customerId) {
        _cancelEdit();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer marked as inactive.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final customers = controller.customers;
          final total = customers.length;
          final active =
              customers.where((c) => c.status == 'Active').length;
          final inactive = total - active;

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
                        blurRadius: 16,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Customer Creation',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            _HeaderCount(label: 'Total', value: '$total'),
                            const SizedBox(width: 24),
                            _HeaderCount(label: 'Active', value: '$active'),
                            const SizedBox(width: 24),
                            _HeaderCount(label: 'Inactive', value: '$inactive'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            controller: tabController,
                            onTap: _handleTabTap,
                            labelColor: AppColors.primary,
                            unselectedLabelColor:
                                AppColors.onSurface.withOpacity(0.6),
                            indicatorColor: AppColors.primary,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            tabs: [
                              const Tab(text: 'Customer Entry'),
                              const Tab(text: 'Customer View'),
                              if (_showEditTab)
                                const Tab(text: 'Customer Edit'),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _CustomerEntryTab(
                              customerIdCtrl: customerIdCtrl,
                              fullNameCtrl: fullNameCtrl,
                              gender: _gender,
                              onGenderChanged: (value) =>
                                  setState(() => _gender = value),
                              dob: _dob,
                              onPickDob: _pickDob,
                              mobileCtrl: mobileCtrl,
                              altMobileCtrl: altMobileCtrl,
                              address1Ctrl: address1Ctrl,
                              address2Ctrl: address2Ctrl,
                              cityCtrl: cityCtrl,
                              stateCtrl: stateCtrl,
                              pincodeCtrl: pincodeCtrl,
                              idProofType: _idProofType,
                              onIdProofChanged: (value) =>
                                  setState(() => _idProofType = value),
                              idProofNumberCtrl: idProofNumberCtrl,
                              addressProofType: _addressProofType,
                              onAddressProofChanged: (value) =>
                                  setState(() => _addressProofType = value),
                              addressProofNumberCtrl: addressProofNumberCtrl,
                              bankNameCtrl: bankNameCtrl,
                              accountHolderCtrl: accountHolderCtrl,
                              accountNumberCtrl: accountNumberCtrl,
                              ifscCtrl: ifscCtrl,
                              branchCtrl: branchCtrl,
                              upiCtrl: upiCtrl,
                              referralNameCtrl: referralNameCtrl,
                              referralMobileCtrl: referralMobileCtrl,
                              remarksCtrl: remarksCtrl,
                              kycVerified: _kycVerified,
                              onKycChanged: (value) =>
                                  setState(() => _kycVerified = value),
                              status: _status,
                              onStatusChanged: (value) =>
                                  setState(() => _status = value),
                              onSubmit: _handleEntrySubmit,
                            ),
                            _CustomerViewTab(
                              controller: controller,
                              searchCtrl: searchCtrl,
                              filterCity: _filterCity,
                              onCityChanged: (value) =>
                                  setState(() => _filterCity = value),
                              filterStatus: _filterStatus,
                              onStatusChanged: (value) =>
                                  setState(() => _filterStatus = value),
                              onSelectRecord: _openEdit,
                            ),
                            if (_showEditTab)
                              _CustomerEditTab(
                                editingRecord: _editingRecord,
                                mobileCtrl: editMobileCtrl,
                                altMobileCtrl: editAltMobileCtrl,
                                address1Ctrl: editAddress1Ctrl,
                                address2Ctrl: editAddress2Ctrl,
                                cityCtrl: editCityCtrl,
                                stateCtrl: editStateCtrl,
                                pincodeCtrl: editPincodeCtrl,
                                bankNameCtrl: editBankNameCtrl,
                                accountHolderCtrl: editAccountHolderCtrl,
                                accountNumberCtrl: editAccountNumberCtrl,
                                ifscCtrl: editIfscCtrl,
                                branchCtrl: editBranchCtrl,
                                upiCtrl: editUpiCtrl,
                                referralNameCtrl: editReferralNameCtrl,
                                referralMobileCtrl: editReferralMobileCtrl,
                                remarksCtrl: editRemarksCtrl,
                                status: _editStatus,
                                onStatusChanged: (value) =>
                                    setState(() => _editStatus = value),
                                onSave: _handleEditSave,
                                onCancel: _cancelEdit,
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

class _CustomerEntryTab extends StatelessWidget {
  const _CustomerEntryTab({
    required this.customerIdCtrl,
    required this.fullNameCtrl,
    required this.gender,
    required this.onGenderChanged,
    required this.dob,
    required this.onPickDob,
    required this.mobileCtrl,
    required this.altMobileCtrl,
    required this.address1Ctrl,
    required this.address2Ctrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.pincodeCtrl,
    required this.idProofType,
    required this.onIdProofChanged,
    required this.idProofNumberCtrl,
    required this.addressProofType,
    required this.onAddressProofChanged,
    required this.addressProofNumberCtrl,
    required this.bankNameCtrl,
    required this.accountHolderCtrl,
    required this.accountNumberCtrl,
    required this.ifscCtrl,
    required this.branchCtrl,
    required this.upiCtrl,
    required this.referralNameCtrl,
    required this.referralMobileCtrl,
    required this.remarksCtrl,
    required this.kycVerified,
    required this.onKycChanged,
    required this.status,
    required this.onStatusChanged,
    required this.onSubmit,
  });

  final TextEditingController customerIdCtrl;
  final TextEditingController fullNameCtrl;
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final DateTime dob;
  final VoidCallback onPickDob;
  final TextEditingController mobileCtrl;
  final TextEditingController altMobileCtrl;
  final TextEditingController address1Ctrl;
  final TextEditingController address2Ctrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController pincodeCtrl;
  final String idProofType;
  final ValueChanged<String> onIdProofChanged;
  final TextEditingController idProofNumberCtrl;
  final String addressProofType;
  final ValueChanged<String> onAddressProofChanged;
  final TextEditingController addressProofNumberCtrl;
  final TextEditingController bankNameCtrl;
  final TextEditingController accountHolderCtrl;
  final TextEditingController accountNumberCtrl;
  final TextEditingController ifscCtrl;
  final TextEditingController branchCtrl;
  final TextEditingController upiCtrl;
  final TextEditingController referralNameCtrl;
  final TextEditingController referralMobileCtrl;
  final TextEditingController remarksCtrl;
  final bool kycVerified;
  final ValueChanged<bool> onKycChanged;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onSubmit;

  static const _genders = ['Male', 'Female', 'Other'];
  static const _idProofTypes = ['Aadhaar', 'PAN', 'Voter ID', 'Passport'];
  static const _addressProofTypes = [
    'Aadhaar',
    'Rental Agreement',
    'EB Bill',
    'Other'
  ];
  static const _statusOptions = ['Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 11,
      color: AppColors.onSurface.withOpacity(0.6),
    );

    InputDecoration decoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: customerIdCtrl,
                  readOnly: true,
                  decoration: decoration('Customer ID'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: fullNameCtrl,
                  decoration: decoration('Full Name *'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: gender,
                  items: _genders
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onGenderChanged(value);
                  },
                  decoration: decoration('Gender'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: InkWell(
                  onTap: onPickDob,
                  child: InputDecorator(
                    decoration: decoration('Date of Birth'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd-MMM-yyyy').format(dob)),
                        const Icon(Icons.calendar_today_outlined, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: mobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: decoration('Mobile Number *'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: altMobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: decoration('Alternate Number (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: address1Ctrl,
                  decoration: decoration('Address Line 1'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: address2Ctrl,
                  decoration: decoration('Address Line 2 (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: cityCtrl,
                  decoration: decoration('City / District'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: stateCtrl,
                  decoration: decoration('State'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: pincodeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: decoration('Pincode'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'KYC Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: idProofType,
                  decoration: decoration('ID Proof Type'),
                  items: _idProofTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onIdProofChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: idProofNumberCtrl,
                  decoration: decoration('ID Proof Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: addressProofType,
                  decoration: decoration('Address Proof'),
                  items: _addressProofTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onAddressProofChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: addressProofNumberCtrl,
                  decoration: decoration('Address Proof Number'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Bank Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: bankNameCtrl,
                  decoration: decoration('Bank Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accountHolderCtrl,
                  decoration: decoration('Account Holder Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accountNumberCtrl,
                  decoration: decoration('Account Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: ifscCtrl,
                  decoration: decoration('IFSC Code'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: branchCtrl,
                  decoration: decoration('Branch Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: upiCtrl,
                  decoration: decoration('UPI ID (Optional)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Referral & Remarks',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: referralNameCtrl,
                  decoration: decoration('Referral Name (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: referralMobileCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: decoration('Referral Mobile (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: decoration('Status'),
                  items: _statusOptions
                      .map(
                        (s) => DropdownMenuItem(value: s, child: Text(s)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onStatusChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: kycVerified,
                onChanged: (value) {
                  if (value != null) onKycChanged(value);
                },
              ),
              const Text('KYC Verified'),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: remarksCtrl,
            maxLines: 2,
            decoration: decoration('Remarks (Internal)'),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Save Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerViewTab extends StatelessWidget {
  const _CustomerViewTab({
    required this.controller,
    required this.searchCtrl,
    required this.filterCity,
    required this.onCityChanged,
    required this.filterStatus,
    required this.onStatusChanged,
    required this.onSelectRecord,
  });

  final CustomerCreationController controller;
  final TextEditingController searchCtrl;
  final String filterCity;
  final ValueChanged<String> onCityChanged;
  final String filterStatus;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<CustomerRecord> onSelectRecord;

  static const _statusOptions = ['All', 'Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    final all = controller.customers;
    final cities = {
      'All',
      ...all.map((c) => c.city).where((c) => c.isNotEmpty),
    };
    final filtered = controller.filter(
      query: searchCtrl.text,
      city: filterCity,
      status: filterStatus,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: searchCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Search name / ID / mobile',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => (context as Element).markNeedsBuild(),
                ),
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: DropdownButtonFormField<String>(
                  value: filterCity,
                  decoration: const InputDecoration(labelText: 'City'),
                  items: cities
                      .map(
                        (city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onCityChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: DropdownButtonFormField<String>(
                  value: filterStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: _statusOptions
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
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
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final record = filtered[index];
              final subtitle =
                  '${record.city}, ${record.state} • ${record.mobile}';
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => onSelectRecord(record),
                  title: Text(
                    record.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(subtitle),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        record.customerId,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: record.status == 'Active'
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomerEditTab extends StatelessWidget {
  const _CustomerEditTab({
    required this.editingRecord,
    required this.mobileCtrl,
    required this.altMobileCtrl,
    required this.address1Ctrl,
    required this.address2Ctrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.pincodeCtrl,
    required this.bankNameCtrl,
    required this.accountHolderCtrl,
    required this.accountNumberCtrl,
    required this.ifscCtrl,
    required this.branchCtrl,
    required this.upiCtrl,
    required this.referralNameCtrl,
    required this.referralMobileCtrl,
    required this.remarksCtrl,
    required this.status,
    required this.onStatusChanged,
    required this.onSave,
    required this.onCancel,
    required this.onDelete,
  });

  final CustomerRecord? editingRecord;
  final TextEditingController mobileCtrl;
  final TextEditingController altMobileCtrl;
  final TextEditingController address1Ctrl;
  final TextEditingController address2Ctrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController pincodeCtrl;
  final TextEditingController bankNameCtrl;
  final TextEditingController accountHolderCtrl;
  final TextEditingController accountNumberCtrl;
  final TextEditingController ifscCtrl;
  final TextEditingController branchCtrl;
  final TextEditingController upiCtrl;
  final TextEditingController referralNameCtrl;
  final TextEditingController referralMobileCtrl;
  final TextEditingController remarksCtrl;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final ValueChanged<CustomerRecord> onDelete;

  static const _statusOptions = ['Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    if (editingRecord == null) {
      return const Center(
        child: Text('Select a customer from Customer View to edit.'),
      );
    }

    final record = editingRecord!;

    InputDecoration decoration(String label) => InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.fullName} (${record.customerId})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'City: ${record.city}, ${record.state}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.danger,
                onPressed: () => onDelete(record),
                tooltip: 'Soft Delete',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: mobileCtrl,
                  decoration: decoration('Mobile Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: altMobileCtrl,
                  decoration: decoration('Alternate Number (Optional)'),
                ),
              ),
              SizedBox(
                width: 260,
                height: 40,
                child: TextField(
                  controller: address1Ctrl,
                  decoration: decoration('Address Line 1'),
                ),
              ),
              SizedBox(
                width: 260,
                height: 40,
                child: TextField(
                  controller: address2Ctrl,
                  decoration: decoration('Address Line 2 (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: cityCtrl,
                  decoration: decoration('City / District'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: stateCtrl,
                  decoration: decoration('State'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: pincodeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: decoration('Pincode'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: decoration('Status'),
                  items: _statusOptions
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
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
          const SizedBox(height: 20),
          Text(
            'Bank & Referral',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: bankNameCtrl,
                  decoration: decoration('Bank Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accountHolderCtrl,
                  decoration: decoration('Account Holder Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: accountNumberCtrl,
                  decoration: decoration('Account Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: ifscCtrl,
                  decoration: decoration('IFSC Code'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: branchCtrl,
                  decoration: decoration('Branch Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: upiCtrl,
                  decoration: decoration('UPI ID (Optional)'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: referralNameCtrl,
                  decoration: decoration('Referral Name'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 40,
                child: TextField(
                  controller: referralMobileCtrl,
                  decoration: decoration('Referral Mobile'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: remarksCtrl,
            maxLines: 3,
            decoration: decoration('Remarks (Internal)'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Update Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


