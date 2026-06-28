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
      setState(() => _error = 'Enter your email and password.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final profile = await _authRepository.signIn(email: email, password: password);
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(profile.isNurse ? '/nurse/dashboard' : '/parent/dashboard');
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
              title: 'Welcome back',
              subtitle: 'Sign in to continue monitoring',
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
                          Expanded(child: _roleTab('Parent', Icons.family_restroom, Role.parent)),
                          Expanded(child: _roleTab('Nurse', Icons.medical_services_outlined, Role.nurse)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Email',
                      placeholder: _role == Role.parent ? 'sarah@example.com' : 'nurse.joy@hgd.cm',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      placeholder: '••••••••',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      trailing: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textFaint,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5)),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot password?',
                            style: TextStyle(color: brand, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _submitting ? 'Signing in…' : 'Log in',
                      color: brand,
                      onPressed: _submitting ? null : _submit,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or', style: TextStyle(fontSize: 12, color: AppColors.textFaint)),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'Create an account',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pushNamed('/signup', arguments: _role),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _googleSubmitting ? 'Connecting…' : 'Continue with Google',
                      variant: AppButtonVariant.secondary,
                      onPressed: _googleSubmitting ? null : _submitGoogle,
                    ),
                    const SizedBox(height: 22),
                    const Center(
                      child: Text('Secured by Supabase · Works offline',
                          style: TextStyle(fontSize: 12, color: AppColors.textFaint)),
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
            Icon(icon, size: 18, color: active ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 7),
            Text(label,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
