import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Role _role = Role.parent;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _submitting = false;
  bool _googleSubmitting = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = tr('auth.login.error_empty'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final profile = await _authRepository.signIn(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        profile.isNurse ? '/nurse/dashboard' : '/parent/dashboard',
      );
    } on AppAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitGoogle() async {
    setState(() {
      _googleSubmitting = true;
      _error = null;
    });
    try {
      await _authRepository.signInWithGoogle();
    } on AppAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _googleSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = AppColors.brandFor(_role);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              role: _role,
              title: tr('auth.login.title'),
              subtitle: tr('auth.login.subtitle'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: _roleTab(
                              tr('auth.login.parent_tab'),
                              Icons.family_restroom,
                              Role.parent,
                            ),
                          ),
                          Expanded(
                            child: _roleTab(
                              tr('auth.login.nurse_tab'),
                              Icons.medical_services_outlined,
                              Role.nurse,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: tr('auth.login.email'),
                      placeholder: _role == Role.parent
                          ? 'sarah@example.com'
                          : 'joy.ekane@gmail.com',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: tr('auth.login.password'),
                      placeholder: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      trailing: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textFaint,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: AppColors.dangerText,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/forgot-password',
                          arguments: _emailController.text.trim().isEmpty
                              ? null
                              : _emailController.text.trim(),
                        ),
                        child: Text(
                          tr('auth.login.forgot_password'),
                          style: TextStyle(
                            color: brand,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _submitting ? tr('auth.login.signing_in') : tr('auth.login.log_in'),
                      color: brand,
                      onPressed: _submitting ? null : _submit,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            tr('auth.login.or'),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textFaint,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: tr('auth.login.create_account'),
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed('/signup', arguments: _role),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _googleSubmitting
                          ? tr('auth.login.connecting')
                          : tr('auth.login.continue_google'),
                      variant: AppButtonVariant.secondary,
                      onPressed: _googleSubmitting ? null : _submitGoogle,
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Text(
                        tr('auth.login.footer'),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleTab(String label, IconData icon, Role role) {
    final active = _role == role;
    final brand = AppColors.brandFor(role);
    return GestureDetector(
      onTap: () => setState(() => _role = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? brand : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
