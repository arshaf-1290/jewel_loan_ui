import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/login_controller.dart';

const EdgeInsets _compactFieldPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool showShowcase = constraints.maxWidth >= 920;
          return Row(
            children: [
              if (showShowcase) const Expanded(child: _ProductShowcase()),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                          child: Form(
                            key: _controller.formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: const Icon(Icons.diamond, color: AppColors.accent, size: 28),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Welcome back to Jewel MS',
                                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Sign in with your username and 4-6 digit access PIN.',
                                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurface.withOpacity(0.7)),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _controller.usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      prefixIcon: const Icon(Icons.person_outline),
                                      isDense: true,
                                      contentPadding: _compactFieldPadding,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Enter your username';
                                      }
                                      if (value.trim().length < 3) {
                                        return 'Username must be at least 3 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, _) => TextFormField(
                                      controller: _controller.passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Access PIN (4-6 digits)',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: _controller.togglePasswordVisibility,
                                          icon: Icon(
                                            _controller.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                        isDense: true,
                                        contentPadding: _compactFieldPadding,
                                        counterText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(6),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      obscureText: _controller.obscurePassword,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter your access PIN';
                                        }
                                        if (value.length < 4 || value.length > 6) {
                                          return 'PIN must be 4 to 6 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, _) => SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _controller.isLoading ? null : () => _controller.submitLogin(context),
                                        child: _controller.isLoading
                                            ? const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : const Text('Sign in'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 6,
                                      children: [
                                        Text(
                                          'New company on Jewel MS?',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                        TextButton(
                                          onPressed: () => _controller.navigateToRegistration(context),
                                          child: const Text('Create an account'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _ProductShowcase extends StatelessWidget {
  const _ProductShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1F2A42), Color(0xFF101725)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Jewel MS',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text('Gold retail & loan automation', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Grow a modern jewellery business.',
              style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              'Centralized stock, instant bullion valuation, billing templates, and compliance-ready reports — all in one secure workspace.',
              style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _ShowcaseBadge(icon: Icons.inventory_2_outlined, label: 'Live Inventory Dashboard'),
                _ShowcaseBadge(icon: Icons.summarize_outlined, label: 'GST Ready Billing'),
                _ShowcaseBadge(icon: Icons.insights_outlined, label: 'Analytics & Alerts'),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '“Since switching to Jewel MS, our pledge desk and counter billing stay in sync. Audits take minutes instead of hours.”',
                    style: TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                  ),
                 /* SizedBox(height: 14),
                  Text('AK Jewels, Coimbatore', style: TextStyle(color: Colors.white70)),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseBadge extends StatelessWidget {
  const _ShowcaseBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _KeyHighlights extends StatelessWidget {
  const _KeyHighlights();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _HighlightRow(
          icon: Icons.speed_outlined,
          title: '2X Faster Closings',
          description: 'Automated daily summaries with instant stock valuation.',
        ),
        SizedBox(height: 12),
        _HighlightRow(
          icon: Icons.lock_outline,
          title: 'Bank-Grade Security',
          description: 'Encrypted offline-first architecture with background sync.',
        ),
        SizedBox(height: 12),
        _HighlightRow(
          icon: Icons.support_agent_outlined,
          title: 'Premium Onboarding',
          description: 'Dedicated rollout specialist for imports, staff training, and GST setup.',
        ),
      ],
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(description, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurface.withOpacity(0.7))),
            ],
          ),
        ),
      ],
    );
  }
}


