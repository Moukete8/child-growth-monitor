import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, this.initialRole = Role.parent});

  final Role initialRole;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late Role _role = widget.initialRole;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hospitalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _submitting = false;
  bool _googleSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hospitalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Fill in your name, email and password.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    if (password != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final profile = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: name,
        role: _role == Role.nurse ? 'nurse' : 'parent',
        phone: _phoneController.text.trim(),
        hospitalId: _role == Role.nurse ? _hospitalIdController.text.trim() : null,
      );
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(profile.isNurse ? '/nurse/dashboard' : '/parent/dashboard');
    } on AppAuthException catch (e) {
      if (e.confirmEmailRequired) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Confirm your email'),
            content: Text(e.message),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
            ],
          ),
        );
        if (!mounted) return;
        Navigator.of(context).pop();
        return;
      }
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
              title: 'Create an account',
              subtitle: 'Join to start monitoring',
              onBack: () => Navigator.of(context).pop(),
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
              AppTextField(label: 'Full name', placeholder: 'Sarah Mballa', icon: Icons.person_outline, controller: _nameController),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email',
                placeholder: _role == Role.parent ? 'sarah@example.com' : 'nurse.joy@hgd.cm',
                icon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone (optional)',
                placeholder: '+237 6xx xxx xxx',
                icon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              if (_role == Role.nurse) ...[
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Hospital ID',
                  placeholder: 'HGD-0231',
                  icon: Icons.local_hospital_outlined,
                  controller: _hospitalIdController,
                ),
              ],
              const SizedBox(height: 16),
              AppTextField(
                label: 'Password',
                placeholder: 'At least 6 characters',
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
              const SizedBox(height: 16),
              AppTextField(
                label: 'Confirm password',
                placeholder: 'Re-enter your password',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirm,
                controller: _confirmPasswordController,
                trailing: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.textFaint,
                  ),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5)),
              ],
              const SizedBox(height: 22),
              AppButton(
                label: _submitting ? 'Creating account…' : 'Create account',
                color: brand,
                onPressed: _submitting ? null : _submit,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: _googleSubmitting ? 'Connecting…' : 'Continue with Google',
                variant: AppButtonVariant.secondary,
                onPressed: _googleSubmitting ? null : _submitGoogle,
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
