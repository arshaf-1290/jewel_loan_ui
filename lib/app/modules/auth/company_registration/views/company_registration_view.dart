import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/company_registration_controller.dart';

const EdgeInsets _compactFieldPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);

class CompanyRegistrationView extends StatefulWidget {
  const CompanyRegistrationView({super.key});

  @override
  State<CompanyRegistrationView> createState() => _CompanyRegistrationViewState();
}

class _CompanyRegistrationViewState extends State<CompanyRegistrationView> {
  late final CompanyRegistrationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CompanyRegistrationController();
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
      appBar: AppBar(
        title: const Text('Register Your Company'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _controller.goToLogin(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _controller.goToLogin(context),
            child: const Text('Sign in instead'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1020),
                child: Form(
                  key: _controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Launch your Jewel MS workspace',
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'We use these details to personalise billing templates, tax settings and onboarding for your firm.',
                                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurface.withOpacity(0.7)),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  _StepPill(index: 1, label: 'Company profile'),
                                  _StepPill(index: 2, label: 'Operational preferences'),
                                  _StepPill(index: 3, label: 'Admin access'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Company profile',
                        subtitle: 'Tell us about your brand and statutory identity.',
                        children: [
                          _ResponsiveRow(
                            children: [
                              AppTextField(
                                controller: _controller.companyNameController,
                                label: 'Registered Company / Brand Name *',
                                prefixIcon: const Icon(Icons.diamond_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: _requiredValidator('Enter your company or brand name'),
                              ),

                              AppTextField(
                                controller: _controller.phoneController,
                                label: 'Primary Contact Number *',
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(Icons.call_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter a contact number';
                                  }
                                  final trimmed = value.trim();
                                  if (trimmed.length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ResponsiveRow(
                            children: [
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) => DropdownButtonFormField<String>(
                                  value: _controller.selectedBusinessType.isEmpty ? null : _controller.selectedBusinessType,
                                  onChanged: _controller.selectBusinessType,
                                  items: _controller.businessTypes
                                      .map(
                                        (type) => DropdownMenuItem<String>(
                                          value: type,
                                          child: Text(type),
                                        ),
                                      )
                                      .toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Business Type *',
                                    prefixIcon: const Icon(Icons.storefront_outlined),
                                    isDense: true,
                                    contentPadding: _compactFieldPadding,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select your business type';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              AppTextField(
                                controller: _controller.gstinController,
                                label: 'GSTIN (Optional)',
                                hint: '22ABCDE1234F1Z5',
                                prefixIcon: const Icon(Icons.receipt_long_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ResponsiveRow(
                            children: [

                              AppTextField(
                                controller: _controller.alternatePhoneController,
                                label: 'Alternate Contact (Optional)',
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(Icons.contact_phone_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  final trimmed = value.trim();
                                  if (trimmed.length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                controller: _controller.businessEmailController,
                                label: 'Business Email (Optional)',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.alternate_email_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }
                                  final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailPattern.hasMatch(value.trim())) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      _SectionCard(
                        title: 'Operational preferences',
                        subtitle: 'Configure where you operate and how invoices should appear.',
                        children: [
                          AppTextField(
                            controller: _controller.addressController,
                            label: 'Workshop / Shop Address *',
                            maxLines: 3,
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            isDense: true,
                            contentPadding: _compactFieldPadding,
                            validator: _requiredValidator('Enter your address'),
                          ),
                          const SizedBox(height: 16),
                          _ResponsiveRow(
                            children: [
                              AppTextField(
                                controller: _controller.cityController,
                                label: 'City / Town *',
                                prefixIcon: const Icon(Icons.location_city_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: _requiredValidator('Enter city'),
                              ),
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) => DropdownButtonFormField<String>(
                                  value: _controller.selectedState.isEmpty ? null : _controller.selectedState,
                                  decoration: InputDecoration(
                                    labelText: 'State / UT *',
                                    prefixIcon: const Icon(Icons.map_outlined),
                                    isDense: true,
                                    contentPadding: _compactFieldPadding,
                                  ),
                                  items: _controller.indianStates
                                      .map(
                                        (state) => DropdownMenuItem<String>(
                                          value: state,
                                          child: Text(state),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _controller.selectState,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Choose a state';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ResponsiveRow(
                            children: [
                              AppTextField(
                                controller: _controller.pinCodeController,
                                label: 'PIN Code *',
                                keyboardType: TextInputType.number,
                                prefixIcon: const Icon(Icons.local_post_office_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter postal code';
                                  }
                                  if (value.trim().length != 6) {
                                    return 'Use 6-digit PIN';
                                  }
                                  return null;
                                },
                              ),
                              AppTextField(
                                controller: _controller.billingPrefixController,
                                label: 'Invoice Prefix',
                                hint: 'e.g. INV, RET',
                                prefixIcon: const Icon(Icons.confirmation_number_outlined),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _SectionCard(
                        title: 'Admin access',
                        subtitle: 'Create your administrator account credentials.',
                        children: [
                          _ResponsiveRow(
                            children: [
                              AppTextField(
                                controller: _controller.usernameController,
                                label: 'Admin Username *',
                                prefixIcon: const Icon(Icons.person_outline),
                                isDense: true,
                                contentPadding: _compactFieldPadding,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter a username';
                                  }
                                  if (value.trim().length < 3) {
                                    return 'Username must be at least 3 characters';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _controller.passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Set Access PIN *',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  isDense: true,
                                  contentPadding: _compactFieldPadding,
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters:  [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Create a 4-6 digit PIN';
                                  }
                                  if (value.length < 4 || value.length > 6) {
                                    return 'PIN must be 4 to 6 digits';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _controller.confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Access PIN *',
                                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                                  isDense: true,
                                  contentPadding: _compactFieldPadding,
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters:  [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Re-enter the password';
                                  }
                                  if (value.length < 4 || value.length > 6) {
                                    return 'PIN must be 4 to 6 digits';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => CheckboxListTile(
                          value: _controller.acceptTerms,
                          onChanged: _controller.toggleTerms,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium,
                              children: const [
                                TextSpan(text: 'I accept the '),
                                TextSpan(
                                  text: 'Jewel MS Terms of Service',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                                TextSpan(text: ' and confirm that company data is accurate.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _controller.isSubmitting ? null : () => _controller.submitRegistration(context),
                            icon: _controller.isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  )
                                : const Icon(Icons.rocket_launch_outlined),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(_controller.isSubmitting ? 'Creating workspace...' : 'Launch Jewel MS'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Our onboarding team will reach out within 1 business day with data import assistance.',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String? Function(String?) _requiredValidator(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 18),
            ..._withSpacing(children, 16),
          ],
        ),
      ),
    );
  }

  static List<Widget> _withSpacing(List<Widget> children, double spacing) {
    final List<Widget> spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) {
        spaced.add(SizedBox(height: spacing));
      }
    }
    return spaced;
  }
}

class _ResponsiveRow extends StatelessWidget {
  const _ResponsiveRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useRow = constraints.maxWidth >= 720 && children.length > 1;
        if (useRow) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < children.length; index++) ...[
                Expanded(child: children[index]),
                if (index != children.length - 1) const SizedBox(width: 20),
              ],
            ],
          );
        }
        return Column(
          children: [
            for (int index = 0; index < children.length; index++) ...[
              children[index],
              if (index != children.length - 1) const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({required this.index, required this.label});

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary,
            child: Text(
              '$index',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}


