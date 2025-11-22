import 'package:flutter/material.dart';

import '../modules/auth/company_registration/views/company_registration_view.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/shell/views/shell_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute<LoginView>(
          builder: (_) => const LoginView(),
          settings: settings,
        );
      case AppRoutes.companyRegistration:
        return MaterialPageRoute<CompanyRegistrationView>(
          builder: (_) => const CompanyRegistrationView(),
          settings: settings,
        );
      case AppRoutes.shell:
        return MaterialPageRoute<ShellView>(
          builder: (_) => const ShellView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<LoginView>(
          builder: (_) => const LoginView(),
          settings: settings,
        );
    }
  }
}

