import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.prefillEmail});

  final String? prefillEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final _emailController = TextEditingController(
    text: widget.prefillEmail ?? '',
  );
  final _authRepository = AuthRepository();
  bool _submitting = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = tr('auth.forgot_password.error_empty'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _authRepository.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() => _sent = true);
    } on AppAuthException catch (e) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthHeader(
              role: Role.parent,
              title: tr('auth.forgot_password.title'),
              subtitle: tr('auth.forgot_password.subtitle'),
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                child: _sent ? _confirmation() : _form(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: tr('auth.forgot_password.email'),
          placeholder: 'you@example.com',
          icon: Icons.mail_outline,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5),
          ),
        ],
        const SizedBox(height: 18),
        AppButton(
          label: _submitting ? tr('auth.forgot_password.sending') : tr('auth.forgot_password.send'),
          color: AppColors.parentPrimary,
          onPressed: _submitting ? null : _submit,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.nurseInfoBg,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 19,
                color: AppColors.parentPrimary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  tr('auth.forgot_password.google_hint'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.nurseInfoText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _confirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 48,
          color: AppColors.parentPrimary,
        ),
        const SizedBox(height: 16),
        Text(
          tr('auth.forgot_password.confirmation_title'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          tr('auth.forgot_password.confirmation_body', args: [_emailController.text.trim()]),
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: tr('auth.forgot_password.back_to_login'),
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
