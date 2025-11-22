import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/staff_creation_controller.dart';

class StaffCreationView extends StatefulWidget {
  const StaffCreationView({super.key});

  @override
  State<StaffCreationView> createState() => _StaffCreationViewState();
}

class _StaffCreationViewState extends State<StaffCreationView>
    with TickerProviderStateMixin {
  late final StaffCreationController controller;
  late TabController tabController;

  final TextEditingController staffIdCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  DateTime _dob = DateTime(1990, 1, 1);
  DateTime _doj = DateTime.now();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController altMobileCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController remarksCtrl = TextEditingController();

  String _employmentRole = 'Loan Officer';
  String _accountStatus = 'Active';
  final Set<String> _accessLevels = {'Loan Receipt', 'Loan Creation'};

  // Filters
  final TextEditingController searchCtrl = TextEditingController();
  String _filterRole = 'All';
  String _filterStatus = 'All';
  DateTimeRange? _joiningRange;

  // Edit
  StaffRecord? _editingRecord;
  final TextEditingController editMobileCtrl = TextEditingController();
  final TextEditingController editAltCtrl = TextEditingController();
  final TextEditingController editAddressCtrl = TextEditingController();
  final TextEditingController editRemarksCtrl = TextEditingController();
  String _editRole = 'Loan Officer';
  String _editStatus = 'Active';
  final Set<String> _editAccessLevels = {};
  bool _showEditTab = false;
  String get _lockMessage =>
      'Staff Entry and Staff View are locked while editing. Please update or cancel to continue.';

  // Delete reason
  final TextEditingController deleteReasonCtrl = TextEditingController();

  static const _roles = [
    'Admin',
    'Manager',
    'Accountant',
    'Loan Officer',
    'Staff',
    'Agent',
  ];

  static const _accessOptions = [
    'Sales',
    'Purchase',
    'Loan',
    'Loan Receipt',
    'Accounts',
    'Stock',
    'Reports',
    'Item Creation',
    'Customer Creation',
    'Staff Creation',
    'Loan Creation',
    'Daily Metal Rate Creation',
    'Company Creation',
  ];

  static const _statusOptions = ['Active', 'Inactive'];

  int get _tabCount => 2 + (_showEditTab ? 1 : 0);
  int get _editTabIndex => _showEditTab ? _tabCount - 1 : -1;

  void _initTabController() {
    tabController =
        TabController(length: _tabCount, vsync: this, initialIndex: 0);
  }

  void _resetTabController(int targetIndex) {
    final oldController = tabController;
    tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: targetIndex.clamp(0, _tabCount - 1),
    );
    oldController.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = StaffCreationController();
    _initTabController();
    _syncInitialIds();
  }

  void _syncInitialIds() {
    final nextId = controller.generateNextStaffId(_doj);
    staffIdCtrl.text = nextId;
    usernameCtrl.text = controller.generateUsername(fullNameCtrl.text);
    passwordCtrl.text = _generatePassword();
  }

  @override
  void dispose() {
    tabController.dispose();
    controller.dispose();
    staffIdCtrl.dispose();
    fullNameCtrl.dispose();
    mobileCtrl.dispose();
    altMobileCtrl.dispose();
    addressCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    remarksCtrl.dispose();
    searchCtrl.dispose();
    editMobileCtrl.dispose();
    editAltCtrl.dispose();
    editAddressCtrl.dispose();
    editRemarksCtrl.dispose();
    deleteReasonCtrl.dispose();
    super.dispose();
  }

  String _generatePassword() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789@#';
    final rand = Random();
    return List.generate(
      10,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  Future<void> _pickDateOfJoining() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _doj,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _doj = picked;
        staffIdCtrl.text = controller.generateNextStaffId(_doj);
      });
    }
  }

  Future<void> _pickJoiningRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _joiningRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _joiningRange = picked);
    }
  }

  void _resetEntryForm() {
    setState(() {
      fullNameCtrl.clear();
      mobileCtrl.clear();
      altMobileCtrl.clear();
      addressCtrl.clear();
      remarksCtrl.clear();
      usernameCtrl.clear();
      passwordCtrl.text = _generatePassword();
      _employmentRole = 'Loan Officer';
      _accountStatus = 'Active';
      _accessLevels
        ..clear()
        ..addAll(['Loan Receipt', 'Loan Creation']);
      _dob = DateTime(1990, 1, 1);
      _doj = DateTime.now();
      staffIdCtrl.text = controller.generateNextStaffId(_doj);
    });
  }

  void _prefillFromName(String value) {
    final username = controller.generateUsername(value);
    setState(() {
      usernameCtrl.text = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
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
                        blurRadius: 16,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                            indicatorPadding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 180),
                            tabs: [
                              const Tab(text: 'Staff Entry'),
                              const Tab(text: 'Staff View'),
                              if (_showEditTab) const Tab(text: 'Staff Edit'),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            _buildLockedWrapper(
                              message: _lockMessage,
                              child: _EntryTab(
                                staffIdCtrl: staffIdCtrl,
                                fullNameCtrl: fullNameCtrl,
                                onNameChanged: _prefillFromName,
                                dob: _dob,
                                onPickDob: _pickDateOfBirth,
                                mobileCtrl: mobileCtrl,
                                altMobileCtrl: altMobileCtrl,
                                addressCtrl: addressCtrl,
                                employmentRole: _employmentRole,
                                onRoleChanged: (role) =>
                                    setState(() => _employmentRole = role),
                                dateOfJoining: _doj,
                                onPickDoj: _pickDateOfJoining,
                                usernameCtrl: usernameCtrl,
                                passwordCtrl: passwordCtrl,
                                onGeneratePassword: () => setState(() {
                                  passwordCtrl.text = _generatePassword();
                                }),
                                accountStatus: _accountStatus,
                                onStatusChanged: (status) =>
                                    setState(() => _accountStatus = status),
                                accessLevels: _accessLevels,
                                onAccessLevelToggle: (value) => setState(() {
                                  if (_accessLevels.contains(value)) {
                                    _accessLevels.remove(value);
                                  } else {
                                    _accessLevels.add(value);
                                  }
                                }),
                                remarksCtrl: remarksCtrl,
                                onSubmit: _handleEntrySubmit,
                              ),
                            ),
                            _buildLockedWrapper(
                              message: _lockMessage,
                              child: _ViewTab(
                                controller: controller,
                                searchCtrl: searchCtrl,
                                filterRole: _filterRole,
                                onRoleChanged: (value) =>
                                    setState(() => _filterRole = value),
                                filterStatus: _filterStatus,
                                onStatusChanged: (value) =>
                                    setState(() => _filterStatus = value),
                                joiningRange: _joiningRange,
                                onPickJoiningRange: _pickJoiningRange,
                                onSelectRecord: _openEditFromView,
                              ),
                            ),
                            if (_showEditTab)
                              _EditTab(
                                controller: controller,
                                editingRecord: _editingRecord,
                                onSave: _handleEditSave,
                                onDelete: _handleDelete,
                                onCancel: _cancelEditMode,
                                mobileCtrl: editMobileCtrl,
                                altCtrl: editAltCtrl,
                                addressCtrl: editAddressCtrl,
                                remarksCtrl: editRemarksCtrl,
                                selectedRole: _editRole,
                                onRoleChanged: (value) =>
                                    setState(() => _editRole = value),
                                selectedStatus: _editStatus,
                                onStatusChanged: (value) =>
                                    setState(() => _editStatus = value),
                                accessLevels: _editAccessLevels,
                                onToggleAccess: (value) => setState(() {
                                  if (_editAccessLevels.contains(value)) {
                                    _editAccessLevels.remove(value);
                                  } else {
                                    _editAccessLevels.add(value);
                                  }
                                }),
                                reasonCtrl: deleteReasonCtrl,
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

  void _handleEntrySubmit() {
    if (staffIdCtrl.text.isEmpty ||
        fullNameCtrl.text.trim().isEmpty ||
        mobileCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill required fields (Staff ID, Full Name, Mobile).',
          ),
        ),
      );
      return;
    }

    controller.addStaff(
      StaffRecord(
        staffId: staffIdCtrl.text.trim(),
        fullName: fullNameCtrl.text.trim(),
        dateOfBirth: _dob,
        mobile: mobileCtrl.text.trim(),
        alternateNumber: altMobileCtrl.text.trim().isEmpty
            ? null
            : altMobileCtrl.text.trim(),
        address: addressCtrl.text.trim().isEmpty
            ? null
            : addressCtrl.text.trim(),
        role: _employmentRole,
        dateOfJoining: _doj,
        username: usernameCtrl.text.trim().isEmpty
            ? controller.generateUsername(fullNameCtrl.text)
            : usernameCtrl.text.trim(),
        password: passwordCtrl.text.trim().isEmpty
            ? _generatePassword()
            : passwordCtrl.text.trim(),
        accessLevels: _accessLevels.toList()..sort(),
        accountStatus: _accountStatus,
        notes: remarksCtrl.text.trim().isEmpty ? null : remarksCtrl.text.trim(),
        createdBy: 'Admin',
        createdAt: DateTime.now(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Staff record created successfully.')),
    );

    _resetEntryForm();
  }

  void _prepareEdit(StaffRecord record) {
    setState(() {
      _editingRecord = record;
      editMobileCtrl.text = record.mobile;
      editAltCtrl.text = record.alternateNumber ?? '';
      editAddressCtrl.text = record.address ?? '';
      editRemarksCtrl.text = record.notes ?? '';
      _editRole = record.role;
      _editStatus = record.accountStatus;
      _editAccessLevels
        ..clear()
        ..addAll(record.accessLevels);
    });
  }

  void _openEditFromView(StaffRecord record) {
    _prepareEdit(record);
    if (!_showEditTab) {
      setState(() {
        _showEditTab = true;
        _resetTabController(_tabCount - 1);
      });
    } else {
      _animateToEditTab();
    }
  }

  void _animateToEditTab() {
    final targetIndex = _editTabIndex;
    if (targetIndex >= 0 && targetIndex < tabController.length) {
      tabController.animateTo(targetIndex);
    }
  }

  void _handleEditSave() {
    final record = _editingRecord;
    if (record == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a staff record to edit.')),
      );
      return;
    }

    controller.updateStaff(
      record.staffId,
      record.copyWith(
        mobile: editMobileCtrl.text.trim(),
        alternateNumber: editAltCtrl.text.trim().isEmpty
            ? null
            : editAltCtrl.text.trim(),
        address: editAddressCtrl.text.trim().isEmpty
            ? null
            : editAddressCtrl.text.trim(),
        role: _editRole,
        accessLevels: _editAccessLevels.toList()..sort(),
        accountStatus: _editStatus,
        notes: editRemarksCtrl.text.trim().isEmpty
            ? null
            : editRemarksCtrl.text.trim(),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Staff record updated.')));
  }

  void _cancelEditMode() {
    if (!_showEditTab) return;
    setState(() {
      _editingRecord = null;
      _showEditTab = false;
      _resetTabController(1);
    });
  }

  void _handleDelete(StaffRecord record) {
    _cancelEditMode();
  }

  void _handleTabTap(int index) {
    if (!_showEditTab) return;
    if (index == _editTabIndex) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_lockMessage)),
    );
    _animateToEditTab();
  }

  Widget _buildLockedWrapper({
    required Widget child,
    required String message,
  }) {
    if (!_showEditTab) return child;
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: true,
          child: child,
        ),
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
                    message,
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
}

class _EntryTab extends StatelessWidget {
  const _EntryTab({
    required this.staffIdCtrl,
    required this.fullNameCtrl,
    required this.onNameChanged,
    required this.dob,
    required this.onPickDob,
    required this.mobileCtrl,
    required this.altMobileCtrl,
    required this.addressCtrl,
    required this.employmentRole,
    required this.onRoleChanged,
    required this.dateOfJoining,
    required this.onPickDoj,
    required this.usernameCtrl,
    required this.passwordCtrl,
    required this.onGeneratePassword,
    required this.accountStatus,
    required this.onStatusChanged,
    required this.accessLevels,
    required this.onAccessLevelToggle,
    required this.remarksCtrl,
    required this.onSubmit,
  });

  final TextEditingController staffIdCtrl;
  final TextEditingController fullNameCtrl;
  final ValueChanged<String> onNameChanged;
  final DateTime dob;
  final VoidCallback onPickDob;
  final TextEditingController mobileCtrl;
  final TextEditingController altMobileCtrl;
  final TextEditingController addressCtrl;
  final String employmentRole;
  final ValueChanged<String> onRoleChanged;
  final DateTime dateOfJoining;
  final VoidCallback onPickDoj;
  final TextEditingController usernameCtrl;
  final TextEditingController passwordCtrl;
  final VoidCallback onGeneratePassword;
  final String accountStatus;
  final ValueChanged<String> onStatusChanged;
  final Set<String> accessLevels;
  final ValueChanged<String> onAccessLevelToggle;
  final TextEditingController remarksCtrl;
  final VoidCallback onSubmit;

  static const _roles = _StaffCreationViewState._roles;
  static const _statusOptions = _StaffCreationViewState._statusOptions;
  static const _accessOptions = _StaffCreationViewState._accessOptions;

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

    InputDecoration compactDecoration({
      required String label,
      String? helperText,
      Widget? suffixIcon,
    }) {
      return InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        helperText: helperText,
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
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
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: staffIdCtrl,
                  style: textStyle,
                  readOnly: true,
                  decoration: compactDecoration(
                    label: 'Staff ID',
                    //helperText: 'Auto-generated from joining date',
                  ),
                ),
              ),
              SizedBox(
                width: 260,
                height: 48,
                child: TextField(
                  controller: fullNameCtrl,
                  style: textStyle,
                  onChanged: onNameChanged,
                  decoration: compactDecoration(label: 'Full Name'),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: _DatePickerField(
                label: 'Date of Birth',
                date: dob,
                onTap: onPickDob,
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: mobileCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.phone,
                  decoration: compactDecoration(label: 'Mobile Number'),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: TextField(
                  controller: altMobileCtrl,
                  style: textStyle,
                  keyboardType: TextInputType.phone,
                  decoration:
                      compactDecoration(label: 'Alternate Number (Optional)'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 48,
                child: TextField(
                  controller: addressCtrl,
                  style: textStyle,
                  decoration:
                      compactDecoration(label: 'Address (Optional)'),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: employmentRole,
                  decoration: compactDecoration(label: 'Role'),
                  style: textStyle,
                  items: _roles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onRoleChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: _DatePickerField(
                label: 'Date of Joining',
                date: dateOfJoining,
                onTap: onPickDoj,
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: usernameCtrl,
                  style: textStyle,
                  decoration: compactDecoration(label: 'Username'),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: passwordCtrl,
                  style: textStyle,
                  decoration: compactDecoration(
                    label: 'Password',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.casino_outlined),
                      tooltip: 'Generate password',
                      onPressed: onGeneratePassword,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: accountStatus,
                  decoration: compactDecoration(label: 'Account Status'),
                  style: textStyle,
                  items: _statusOptions
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
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
            'Access Level',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _accessOptions
                .map(
                  (option) => FilterChip(
                    label: Text(option),
                    selected: accessLevels.contains(option),
                    onSelected: (_) => onAccessLevelToggle(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: remarksCtrl,
            style: textStyle,
            maxLines: 2,
            decoration: compactDecoration(label: 'Remarks (Optional)'),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Create Staff'),
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

class _ViewTab extends StatefulWidget {
  const _ViewTab({
    required this.controller,
    required this.searchCtrl,
    required this.filterRole,
    required this.onRoleChanged,
    required this.filterStatus,
    required this.onStatusChanged,
    required this.joiningRange,
    required this.onPickJoiningRange,
    required this.onSelectRecord,
  });

  final StaffCreationController controller;
  final TextEditingController searchCtrl;
  final String filterRole;
  final ValueChanged<String> onRoleChanged;
  final String filterStatus;
  final ValueChanged<String> onStatusChanged;
  final DateTimeRange? joiningRange;
  final VoidCallback onPickJoiningRange;
  final ValueChanged<StaffRecord> onSelectRecord;

  static const _roles = ['All', ..._StaffCreationViewState._roles];
  static const _statusOptions = [
    'All',
    ..._StaffCreationViewState._statusOptions,
  ];

  @override
  State<_ViewTab> createState() => _ViewTabState();
}

class _ViewTabState extends State<_ViewTab> {
  final ScrollController _horizontalScrollController = ScrollController();

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
    final filtered = widget.controller.filter(
      query: widget.searchCtrl.text,
      role: widget.filterRole,
      status: widget.filterStatus,
      joiningRange: widget.joiningRange,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: widget.searchCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Search by name or mobile',
                    labelStyle: labelStyle,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: widget.filterRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: labelStyle,
                  ),
                  style: textStyle,
                  items: _ViewTab._roles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onRoleChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  value: widget.filterStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: labelStyle,
                  ),
                  style: textStyle,
                  items: _ViewTab._statusOptions
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) widget.onStatusChanged(value);
                  },
                ),
              ),
              _DateRangeButton(
                label: 'Joining Date Range',
                range: widget.joiningRange,
                onTap: widget.onPickJoiningRange,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text('Staff ID')),
                        DataColumn(label: Text('Full Name')),
                        DataColumn(label: Text('Mobile')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Access Level')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Date of Joining')),
                      ],
                      rows: filtered
                          .map(
                            (record) => DataRow(
                              onSelectChanged: (_) =>
                                  widget.onSelectRecord(record),
                              cells: [
                                DataCell(Text(record.staffId)),
                                DataCell(Text(record.fullName)),
                                DataCell(Text(record.mobile)),
                                DataCell(Text(record.role)),
                                DataCell(Text(record.accessLevels.join(', '))),
                                DataCell(Text(record.accountStatus)),
                                DataCell(Text(record.formattedDoj)),
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

class _EditTab extends StatelessWidget {
  const _EditTab({
    required this.controller,
    required this.editingRecord,
    required this.onSave,
    required this.onDelete,
    required this.onCancel,
    required this.mobileCtrl,
    required this.altCtrl,
    required this.addressCtrl,
    required this.remarksCtrl,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.accessLevels,
    required this.onToggleAccess,
    required this.reasonCtrl,
  });

  final StaffCreationController controller;
  final StaffRecord? editingRecord;
  final VoidCallback onSave;
  final ValueChanged<StaffRecord> onDelete;
  final VoidCallback onCancel;
  final TextEditingController mobileCtrl;
  final TextEditingController altCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController remarksCtrl;
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final Set<String> accessLevels;
  final ValueChanged<String> onToggleAccess;
  final TextEditingController reasonCtrl;

  static const _roles = _StaffCreationViewState._roles;
  static const _statusOptions = _StaffCreationViewState._statusOptions;
  static const _accessOptions = _StaffCreationViewState._accessOptions;

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

    if (editingRecord == null) {
      return const Center(child: Text('Select a staff record to edit.'));
    }

    final record = editingRecord!;

    Future<void> handleDelete() async {
      final result = await showDialog<_DeleteActionResult>(
        context: context,
        builder: (context) => _DeleteDialog(
          record: record,
          reasonCtrl: reasonCtrl,
          initialHardDelete: false,
        ),
      );

      if (result == null) return;

      if (result.hardDelete) {
        controller.hardDelete(record.staffId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff permanently deleted.')),
        );
      } else {
        if (result.reason.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Provide a reason for soft delete.')),
          );
          return;
        }
        controller.softDelete(record.staffId, result.reason.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff deactivated successfully.')),
        );
      }
      onDelete(record);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${record.fullName} (${record.staffId})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.danger,
                onPressed: handleDelete,
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ReadOnlyField(
                label: 'Date of Joining',
                value: record.formattedDoj,
              ),
              _ReadOnlyField(
                label: 'Username',
                value: record.username,
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: mobileCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: labelStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: TextField(
                  controller: altCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Alternate Number (Optional)',
                    labelStyle: labelStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                height: 48,
                child: TextField(
                  controller: addressCtrl,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: labelStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: labelStyle,
                  ),
                  style: textStyle,
                  items: _roles
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onRoleChanged(value);
                  },
                ),
              ),
              SizedBox(
                width: 220,
                height: 48,
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Account Status',
                    labelStyle: labelStyle,
                  ),
                  style: textStyle,
                  items: _statusOptions
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
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
            'Access Level',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _accessOptions
                .map(
                  (option) => FilterChip(
                    label: Text(option),
                    selected: accessLevels.contains(option),
                    onSelected: (_) => onToggleAccess(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: remarksCtrl,
            style: textStyle,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Remarks (Internal)',
              labelStyle: labelStyle,
            ),
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
                label: const Text('Update Staff'),
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

class _DeleteActionResult {
  const _DeleteActionResult({required this.hardDelete, required this.reason});

  final bool hardDelete;
  final String reason;
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog({
    required this.record,
    required this.reasonCtrl,
    required this.initialHardDelete,
  });

  final StaffRecord record;
  final TextEditingController reasonCtrl;
  final bool initialHardDelete;

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  late bool hardDelete;

  @override
  void initState() {
    super.initState();
    hardDelete = widget.initialHardDelete;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Staff Delete'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete this staff record?'),
            const SizedBox(height: 12),
            Text('Staff ID: ${widget.record.staffId}'),
            Text('Name: ${widget.record.fullName}'),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: hardDelete,
              onChanged: (value) => setState(() => hardDelete = value),
              title: const Text('Perform hard delete'),
              subtitle: const Text(
                'Hard delete removes the record permanently. Soft delete will only deactivate.',
              ),
            ),
            if (!hardDelete) ...[
              const SizedBox(height: 12),
              TextField(
                controller: widget.reasonCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reason for deactivation',
                  hintText: 'Resigned from company',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(
            context,
            _DeleteActionResult(
              hardDelete: hardDelete,
              reason: widget.reasonCtrl.text,
            ),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

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
    return SizedBox(
      width: 220,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd-MMM-yyyy').format(date),
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  const _DateRangeButton({
    required this.label,
    required this.range,
    required this.onTap,
  });

  final String label;
  final DateTimeRange? range;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = range == null
        ? 'Any time'
        : '${DateFormat('dd MMM yyyy').format(range!.start)} -\n${DateFormat('dd MMM yyyy').format(range!.end)}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

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
    return SizedBox(
      width: 220,
      height: 48,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.border),
            ),
          ),
        child: Text(
          value,
          style: textStyle,
        ),
      ),
    );
  }
}
