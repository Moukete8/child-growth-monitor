import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/remote/supabase_client.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, this.role = Role.parent});
  final Role role;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newPassword = _newPasswordController.text;
    if (newPassword.isEmpty) {
      setState(() => _error = tr('auth.set_password.error_empty'));
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
    });
    try {
      await AppSupabase.client.auth.updateUser(UserAttributes(password: newPassword));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('auth.set_password.success'))),
      );
      final route = widget.role == Role.nurse ? '/nurse/dashboard' : '/parent/dashboard';
      Navigator.of(context).pushReplacementNamed(route);
    } on AuthException catch (e) {
      setState(() => _error = e.message);
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
          children: [
            AuthHeader(
              role: widget.role,
              title: tr('auth.set_password.title'),
              subtitle: tr('auth.set_password.subtitle'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: tr('auth.change_password.new_password'),
                      placeholder: '••••••••',
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
                      placeholder: '••••••••',
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
                    const SizedBox(height: 24),
                    AppButton(
                      label: _submitting
                          ? tr('auth.change_password.submitting')
                          : tr('auth.set_password.submit'),
                      color: AppColors.brandFor(widget.role),
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
