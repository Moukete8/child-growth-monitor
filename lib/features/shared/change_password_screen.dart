import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  bool _wrongOldPassword = false;
  String? _error;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      setState(() => _error = tr('auth.change_password.error_validation'));
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _error = tr('auth.change_password.error_password_length'));
      return;
    }
    if (newPassword != _confirmPasswordController.text) {
      setState(() => _error = tr('auth.change_password.error_password_match'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
      _wrongOldPassword = false;
    });
    try {
      await _authRepository.changePassword(
        email: widget.email,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('auth.change_password.success'))),
      );
      Navigator.of(context).pop();
    } on AppAuthException catch (e) {
      setState(() {
        _wrongOldPassword = e.wrongOldPassword;
        _error = e.wrongOldPassword ? tr('auth.change_password.error_old_password_wrong') : e.message;
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              role: Role.parent,
              title: tr('auth.change_password.title'),
              subtitle: tr('auth.change_password.subtitle'),
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: tr('auth.change_password.old_password'),
                      icon: Icons.lock_outline,
                      obscureText: _obscureOld,
                      controller: _oldPasswordController,
                      trailing: IconButton(
                        icon: Icon(
                          _obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textFaint,
                        ),
                        onPressed: () => setState(() => _obscureOld = !_obscureOld),
                      ),
                    ),
                    if (_wrongOldPassword) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/forgot-password', arguments: widget.email),
                        child: Text(
                          tr('auth.login.forgot_password'),
                          style: const TextStyle(
                            color: AppColors.parentPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    AppTextField(
                      label: tr('auth.change_password.new_password'),
                      icon: Icons.lock_outline,
                      obscureText: _obscureNew,
                      controller: _newPasswordController,
                      trailing: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textFaint,
                        ),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: tr('auth.change_password.confirm_password'),
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
                    const SizedBox(height: 18),
                    AppButton(
                      label: _submitting ? tr('auth.change_password.submitting') : tr('auth.change_password.submit'),
                      color: AppColors.parentPrimary,
                      onPressed: _submitting ? null : _submit,
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
}
