import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyBankDetails {
  const CompanyBankDetails({
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.accountType,
    this.upiId,
  });

  final String bankName;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String accountType;
  final String? upiId;

  CompanyBankDetails copyWith({
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    String? accountType,
    String? upiId,
  }) {
    return CompanyBankDetails(
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      accountType: accountType ?? this.accountType,
      upiId: upiId ?? this.upiId,
    );
  }
}

class CompanyRecord {
  CompanyRecord({
    required this.companyId,
    required this.loginId,
    required this.companyName,
    required this.mobileNumber,
    this.alternateContact,
    this.gstNumber,
    required this.businessType,
    required this.addressLine,
    required this.city,
    required this.pincode,
    required this.adminUsername,
    required this.accessPin,
    required this.financialYear,
    this.bankDetails,
    this.isDefaultBank = false,
    required this.createdDate,
    this.status = 'Active',
    this.remarks,
    this.lastEditedBy,
    this.lastEditedAt,
    this.deactivationReason,
  });

  final String companyId;
  final String loginId;
  final String companyName;
  final String mobileNumber;
  final String? alternateContact;
  final String? gstNumber;
  final String businessType;
  final String addressLine;
  final String city;
  final String pincode;
  final String adminUsername;
  final String accessPin;
  final String financialYear;
  final CompanyBankDetails? bankDetails;
  final bool isDefaultBank;
  final DateTime createdDate;
  final String status;
  final String? remarks;
  final String? lastEditedBy;
  final DateTime? lastEditedAt;
  final String? deactivationReason;

  String get formattedCreatedDate =>
      DateFormat('dd-MMM-yyyy').format(createdDate);
  String get defaultBankLabel => isDefaultBank ? 'Yes' : 'No';

  CompanyRecord copyWith({
    String? companyName,
    String? mobileNumber,
    String? alternateContact,
    String? gstNumber,
    String? businessType,
    String? addressLine,
    String? city,
    String? pincode,
    String? adminUsername,
    String? accessPin,
    String? financialYear,
    CompanyBankDetails? bankDetails,
    bool? isDefaultBank,
    String? status,
    String? remarks,
    String? lastEditedBy,
    DateTime? lastEditedAt,
    String? deactivationReason,
  }) {
    return CompanyRecord(
      companyId: companyId,
      loginId: loginId,
      companyName: companyName ?? this.companyName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      alternateContact: alternateContact ?? this.alternateContact,
      gstNumber: gstNumber ?? this.gstNumber,
      businessType: businessType ?? this.businessType,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      adminUsername: adminUsername ?? this.adminUsername,
      accessPin: accessPin ?? this.accessPin,
      financialYear: financialYear ?? this.financialYear,
      bankDetails: bankDetails ?? this.bankDetails,
      isDefaultBank: isDefaultBank ?? this.isDefaultBank,
      createdDate: createdDate,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      lastEditedBy: lastEditedBy ?? this.lastEditedBy,
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
      deactivationReason: deactivationReason ?? this.deactivationReason,
    );
  }
}

class CompanyCreationController extends ChangeNotifier {
  CompanyCreationController() {
    _companies.addAll([
      CompanyRecord(
        companyId: 'CMP-2025-0001',
        loginId: 'LGIN-2025-001',
        companyName: 'TrustConnect Jewellery',
        mobileNumber: '9876543210',
        alternateContact: '9008765432',
        gstNumber: '33TCXPS1234L1Z',
        businessType: 'Gold Loan / Finance Jewellery Shop',
        addressLine: '45, Perundurai Main Road',
        city: 'Erode',
        pincode: '638011',
        adminUsername: 'priya_admin',
        accessPin: '****',
        financialYear: '2025-2026',
        bankDetails: const CompanyBankDetails(
          bankName: 'Indian Bank',
          accountHolderName: 'TrustConnect Jewellery',
          accountNumber: '12345678901',
          ifscCode: 'IDIB000E005',
          branchName: 'Erode Main',
          accountType: 'Current',
          upiId: 'trustconnect@ibl',
        ),
        isDefaultBank: true,
        createdDate: DateTime(2025, 11, 10),
        status: 'Active',
        remarks: 'Primary franchise account',
      ),
      CompanyRecord(
        companyId: 'CMP-2025-0002',
        loginId: 'LGIN-2025-002',
        companyName: 'Sthri Gold & Silver Works',
        mobileNumber: '9123456789',
        businessType: 'Retail Jewellery Shop',
        addressLine: '18, Avinashi Road',
        city: 'Coimbatore',
        pincode: '641018',
        adminUsername: 'arjun_admin',
        accessPin: '****',
        financialYear: '2025-2026',
        bankDetails: const CompanyBankDetails(
          bankName: 'HDFC Bank',
          accountHolderName: 'Sthri Gold',
          accountNumber: '998877665544',
          ifscCode: 'HDFC0004567',
          branchName: 'Coimbatore Main',
          accountType: 'Current',
        ),
        isDefaultBank: false,
        createdDate: DateTime(2025, 11, 10),
        status: 'Active',
      ),
    ]);
  }

  final List<CompanyRecord> _companies = [];
  final NumberFormat _serialFormat = NumberFormat('0000');

  List<CompanyRecord> get companies => List.unmodifiable(_companies);

  int get totalCompanies => _companies.length;
  int get activeCompanies =>
      _companies.where((company) => company.status == 'Active').length;
  int get defaultBankCount =>
      _companies.where((company) => company.isDefaultBank).length;

  static const List<String> businessTypes = [
    'Retail Jewellery Shop',
    'Wholesale Jewellery Distributor',
    'Gold Loan / Finance Jewellery Shop',
    'Goldsmith / Manufacturer',
    'Silver / Diamond Dealer',
    'Custom Jewellery Designer',
    'Others',
  ];

  static const List<String> accountTypes = [
    'Savings',
    'Current',
    'Overdraft',
  ];

  List<String> get financialYears {
    final currentYear = DateTime.now().year;
    return List<String>.generate(
      6,
      (index) {
        final start = currentYear - 1 + index;
        final end = start + 1;
        return '$start-$end';
      },
    );
  }

  String generateCompanyId(DateTime date) {
    final year = date.year;
    final countForYear = _companies
            .where((company) => company.companyId.startsWith('CMP-$year'))
            .length +
        1;
    return 'CMP-$year-${_serialFormat.format(countForYear)}';
  }

  String generateLoginId(DateTime date) {
    final year = date.year;
    final countForYear = _companies
            .where((company) => company.loginId.startsWith('LGIN-$year'))
            .length +
        1;
    return 'LGIN-$year-${_serialFormat.format(countForYear)}';
  }

  void addCompany(CompanyRecord record) {
    final existingIndex =
        _companies.indexWhere((item) => item.companyId == record.companyId);
    if (existingIndex >= 0) {
      _companies[existingIndex] = record;
    } else {
      _companies.insert(0, record);
    }
    notifyListeners();
  }

  void updateCompany(String companyId, CompanyRecord record) {
    final index = _companies.indexWhere((item) => item.companyId == companyId);
    if (index == -1) return;
    _companies[index] = record;
    notifyListeners();
  }

  void softDelete(String companyId, String reason) {
    final index = _companies.indexWhere((item) => item.companyId == companyId);
    if (index == -1) return;
    final record = _companies[index];
    _companies[index] = record.copyWith(
      status: 'Inactive',
      deactivationReason: reason,
    );
    notifyListeners();
  }

  void hardDelete(String companyId) {
    _companies.removeWhere((item) => item.companyId == companyId);
    notifyListeners();
  }

  List<CompanyRecord> filterCompanies({
    String? query,
    String? businessType,
    String? financialYear,
    String? status,
    String? adminUsername,
    String? city,
  }) {
    return _companies.where((company) {
      if (query != null && query.isNotEmpty) {
        final lower = query.toLowerCase();
        final matchesName = company.companyName.toLowerCase().contains(lower);
        final matchesCity = company.city.toLowerCase().contains(lower);
        if (!matchesName && !matchesCity) return false;
      }
      if (city != null && city.isNotEmpty) {
        if (!company.city.toLowerCase().contains(city.toLowerCase())) {
          return false;
        }
      }
      if (businessType != null &&
          businessType.isNotEmpty &&
          businessType != 'All' &&
          company.businessType != businessType) {
        return false;
      }
      if (financialYear != null &&
          financialYear.isNotEmpty &&
          financialYear != 'All' &&
          company.financialYear != financialYear) {
        return false;
      }
      if (status != null &&
          status.isNotEmpty &&
          status != 'All' &&
          company.status != status) {
        return false;
      }
      if (adminUsername != null && adminUsername.isNotEmpty) {
        if (!company.adminUsername
            .toLowerCase()
            .contains(adminUsername.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}

