import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerRecord {
  CustomerRecord({
    required this.customerId,
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.mobile,
    this.altMobile,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.idProofType,
    required this.idProofNumber,
    required this.addressProofType,
    this.addressProofNumber,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.branchName,
    this.upiId,
    this.referralName,
    this.referralMobile,
    this.remarks,
    this.kycVerified,
    this.status = 'Active',
    DateTime? createdAt,
    this.createdBy = 'System',
    this.inactiveReason,
  }) : createdAt = createdAt ?? DateTime.now();

  final String customerId;
  final String fullName;
  final String gender;
  final DateTime dob;
  final String mobile;
  final String? altMobile;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;

  final String idProofType;
  final String idProofNumber;
  final String addressProofType;
  final String? addressProofNumber;

  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? branchName;
  final String? upiId;

  final String? referralName;
  final String? referralMobile;
  final String? remarks;

  final bool? kycVerified;
  final String status; // Active / Inactive

  final DateTime createdAt;
  final String createdBy;
  final String? inactiveReason;

  String get formattedDob => DateFormat('dd-MMM-yyyy').format(dob);

  CustomerRecord copyWith({
    String? mobile,
    String? altMobile,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    String? upiId,
    String? referralName,
    String? referralMobile,
    String? remarks,
    bool? kycVerified,
    String? status,
    String? inactiveReason,
  }) {
    return CustomerRecord(
      customerId: customerId,
      fullName: fullName,
      gender: gender,
      dob: dob,
      mobile: mobile ?? this.mobile,
      altMobile: altMobile ?? this.altMobile,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      idProofType: idProofType,
      idProofNumber: idProofNumber,
      addressProofType: addressProofType,
      addressProofNumber: addressProofNumber ?? this.addressProofNumber,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      upiId: upiId ?? this.upiId,
      referralName: referralName ?? this.referralName,
      referralMobile: referralMobile ?? this.referralMobile,
      remarks: remarks ?? this.remarks,
      kycVerified: kycVerified ?? this.kycVerified,
      status: status ?? this.status,
      createdAt: createdAt,
      createdBy: createdBy,
      inactiveReason: inactiveReason ?? this.inactiveReason,
    );
  }
}

class CustomerCreationController extends ChangeNotifier {
  final List<CustomerRecord> _customers = [];
  final NumberFormat _serialFormat = NumberFormat('0000');

  List<CustomerRecord> get customers => List.unmodifiable(_customers);

  String generateNextCustomerId(DateTime now) {
    final prefix = DateFormat('yyyy').format(now);
    final countForYear = _customers
            .where(
              (c) =>
                  DateFormat('yyyy').format(c.createdAt) ==
                  DateFormat('yyyy').format(now),
            )
            .length +
        1;
    return 'CUST-$prefix-${_serialFormat.format(countForYear)}';
  }

  void addCustomer(CustomerRecord record) {
    final index =
        _customers.indexWhere((item) => item.customerId == record.customerId);
    if (index >= 0) {
      _customers[index] = record;
    } else {
      _customers.insert(0, record);
    }
    notifyListeners();
  }

  void updateCustomer(String customerId, CustomerRecord updated) {
    final index =
        _customers.indexWhere((record) => record.customerId == customerId);
    if (index == -1) return;
    _customers[index] = updated;
    notifyListeners();
  }

  void softDelete(String customerId, String reason) {
    final index =
        _customers.indexWhere((record) => record.customerId == customerId);
    if (index == -1) return;
    final record = _customers[index];
    _customers[index] = record.copyWith(
      status: 'Inactive',
      inactiveReason: reason,
    );
    notifyListeners();
  }

  void hardDelete(String customerId) {
    _customers.removeWhere((record) => record.customerId == customerId);
    notifyListeners();
  }

  List<CustomerRecord> filter({
    String? query,
    String? city,
    String? status,
  }) {
    return _customers.where((record) {
      if (query != null && query.trim().isNotEmpty) {
        final lower = query.toLowerCase();
        if (!record.fullName.toLowerCase().contains(lower) &&
            !record.customerId.toLowerCase().contains(lower) &&
            !record.mobile.toLowerCase().contains(lower)) {
          return false;
        }
      }
      if (city != null && city.trim().isNotEmpty && city != 'All') {
        if (record.city.toLowerCase() != city.toLowerCase()) return false;
      }
      if (status != null && status.trim().isNotEmpty && status != 'All') {
        if (record.status != status) return false;
      }
      return true;
    }).toList();
  }
}


