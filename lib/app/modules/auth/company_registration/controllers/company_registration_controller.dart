import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_routes.dart';

const String _companyEndpoint = 'http://localhost:3309/api/companies';

class CompanyRegistrationController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController billingPrefixController = TextEditingController(text: 'INV');
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool acceptTerms = false;
  bool isSubmitting = false;
  String selectedBusinessType = '';
  String selectedState = '';

  final List<String> businessTypes = <String>[
    'Retail Jewellery',
    'Wholesale Jewellery',
    'Bullion Trading',
    'Gold Loan & Finance',
    'Manufacturing & Workshop',
  ];

  final List<String> indianStates = <String>[
    'Andhra Pradesh',
    'Delhi',
    'Gujarat',
    'Karnataka',
    'Kerala',
    'Maharashtra',
    'Tamil Nadu',
    'Telangana',
    'West Bengal',
    'Other',
  ];

  void selectBusinessType(String? value) {
    if (value == null || value == selectedBusinessType) return;
    selectedBusinessType = value;
    notifyListeners();
  }

  void selectState(String? value) {
    if (value == null || value == selectedState) return;
    selectedState = value;
    stateController.text = value;
    notifyListeners();
  }

  void toggleTerms(bool? value) {
    acceptTerms = value ?? false;
    notifyListeners();
  }

  Future<void> submitRegistration(BuildContext context) async {
    final form = formKey.currentState;
    if (form == null) return;

    if (!form.validate()) {
      return;
    }

    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm that you accept the Jewel MS terms of service.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The passwords you entered do not match.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await _createCompany(context);
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    gstinController.dispose();
    usernameController.dispose();
    businessEmailController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    stateController.dispose();
    billingPrefixController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createCompany(BuildContext context) async {
    if (isSubmitting) return;

    isSubmitting = true;
    notifyListeners();

    try {
      final String stateValue = selectedState.trim().isNotEmpty
          ? selectedState.trim()
          : stateController.text.trim();

      final response = await http.post(
        Uri.parse(_companyEndpoint),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'companyName': companyNameController.text.trim(),
          'address': addressController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateValue,
          'pinCode': pinCodeController.text.trim(),
          'primaryContactNumber': phoneController.text.trim(),
          'alternateContactNumber': alternatePhoneController.text.trim().isEmpty
              ? null
              : alternatePhoneController.text.trim(),
          'gstin': gstinController.text.trim().isEmpty ? null : gstinController.text.trim(),
          'businessType': selectedBusinessType.trim(),
          'invoicePrefix':
              billingPrefixController.text.trim().isEmpty ? null : billingPrefixController.text.trim(),
          'businessEmail':
              businessEmailController.text.trim().isEmpty ? null : businessEmailController.text.trim(),
          'adminUsername': usernameController.text.trim(),
          'accessPin': passwordController.text.trim(),
          'acceptTerms': acceptTerms,
        }),
      );
      final Map<String, dynamic> responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 201) {
        if (!context.mounted) return;

        final Map<String, dynamic>? responseData =
            responseBody['data'] is Map<String, dynamic> ? responseBody['data'] as Map<String, dynamic> : null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message']?.toString() ?? 'Company created successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.shell,
          (route) => false,
          arguments: responseData,
        );
        return;
      }

      final errorMessage =
          responseBody['message']?.toString() ?? 'Failed to create company. Please try again later.';
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to reach server. Please check your connection. ($error)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}


