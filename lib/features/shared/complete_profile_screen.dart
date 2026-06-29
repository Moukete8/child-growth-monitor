import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/tokens/app_colors.dart';

/// Shown once, right after a first Google sign-in, for accounts whose
/// `public.users` row was auto-created by the `handle_new_user` trigger
/// without a role or full name (those only exist for email/password
/// sign-ups, which pass them explicitly).
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  Role _role = Role.parent;
  late final _nameController = TextEditingController(text: _googleDisplayName());
  final _hospitalIdController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _submitting = false;
  String? _error;

  String _googleDisplayName() {
    final meta = _authRepository.currentUser?.userMetadata;
    return (meta?['full_name'] as String?) ?? (meta?['name'] as String?) ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hospitalIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = tr('auth.complete_profile.error_name'));
      return;
    }
    if (_role == Role.nurse && _hospitalIdController.text.trim().isEmpty) {
      setState(() => _error = tr('auth.complete_profile.error_hospital_id'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final profile = await _authRepository.completeProfile(
        fullName: name,
        role: _role == Role.nurse ? 'nurse' : 'parent',
        hospitalId: _role == Role.nurse ? _hospitalIdController.text.trim() : null,
      );
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(profile.isNurse ? '/nurse/dashboard' : '/parent/dashboard');
    } on AppAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = AppColors.brandFor(_role);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        automaticallyImplyLeading: false,
        title: Text(tr('auth.complete_profile.title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('auth.complete_profile.intro'),
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(child: _roleTab(tr('auth.login.parent_tab'), Icons.family_restroom, Role.parent)),
                    Expanded(child: _roleTab(tr('auth.login.nurse_tab'), Icons.medical_services_outlined, Role.nurse)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: tr('auth.complete_profile.full_name'),
                placeholder: 'Sarah Mballa',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              if (_role == Role.nurse) ...[
                const SizedBox(height: 16),
                AppTextField(
                  label: tr('auth.complete_profile.hospital_id'),
                  placeholder: 'HGD-0231',
                  icon: Icons.local_hospital_outlined,
                  controller: _hospitalIdController,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5)),
              ],
              const SizedBox(height: 22),
              AppButton(
                label: _submitting ? tr('auth.complete_profile.saving') : tr('auth.complete_profile.continue'),
                color: brand,
                onPressed: _submitting ? null : _submit,
              ),
            ],
          ),
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
