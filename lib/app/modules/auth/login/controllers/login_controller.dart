import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';

class LoginController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> submitLogin(BuildContext context) async {
    final form = formKey.currentState;
    if (form == null) {
      return;
    }

    if (!form.validate()) {
      return;
    }

    if (isLoading) {
      return;
    }

    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    isLoading = false;
    notifyListeners();

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.shell, (route) => false);
  }

  void navigateToRegistration(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.companyRegistration);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}


