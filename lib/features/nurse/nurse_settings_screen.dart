import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/image_picker_sheet.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../data/sync/sync_service_provider.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/molecules/avatar.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class NurseSettingsScreen extends StatefulWidget {
  const NurseSettingsScreen({super.key});

  @override
  State<NurseSettingsScreen> createState() => _NurseSettingsScreenState();
}

class _NurseSettingsScreenState extends State<NurseSettingsScreen> {
  final _authRepository = AuthRepository();
  bool _syncing = false;
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _authRepository.resolveCurrentProfile();
  }

  Future<void> _changeAvatar() async {
    final picked = await pickAvatarSource(context);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    try {
      await _authRepository.updateAvatar(bytes, contentType: 'image/jpeg');
      if (!mounted) return;
      setState(() => _profileFuture = _authRepository.resolveCurrentProfile());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update photo: $e')));
    }
  }

  String _syncLabel(SyncStatusSnapshot status) {
    final last = status.lastSyncedAt;
    if (last == null) return tr('sync.never');
    final minutes = DateTime.now().difference(last).inMinutes;
    return minutes < 1
        ? tr('sync.just_now')
        : tr('sync.minutes_ago', args: ['$minutes']);
  }

  Future<void> _syncNow() async {
    setState(() => _syncing = true);
    final result = await syncService.syncNow();
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('sync.result', args: ['${result.pushed}'])),
        backgroundColor: AppColors.toastBg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return RoleScaffold(
          role: Role.nurse,
          currentNavIndex: 4,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
            role: Role.nurse,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _changeAvatar,
                  child: Stack(
                    children: [
                      AppAvatar(
                        imageUrl: profile?.avatarUrl,
                        fallbackIcon: Icons.person,
                        radius: 29,
                        backgroundColor: const Color(0x33FFFFFF),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.nursePrimary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? '…',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tr('nurse.settings.staff_id', args: [profile?.hospitalId ?? '—']),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xD9FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              StreamBuilder<SyncStatusSnapshot>(
                stream: syncService.statusStream,
                initialData: syncService.lastStatus,
                builder: (context, snapshot) {
                  final status = snapshot.data ?? syncService.lastStatus;
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.cloud_done_outlined,
                          color: AppColors.riskNormalDot,
                          size: 21,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('nurse.settings.sync_status'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                _syncLabel(status),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _syncing ? null : _syncNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.nursePrimary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sync,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tr('sync.now'),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/change-password', arguments: profile?.email ?? ''),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: AppColors.nursePrimary, size: 21),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            tr('nurse.settings.change_password'),
                            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.textFaint),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.dark_mode_outlined, color: AppColors.nursePrimary, size: 21),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('nurse.settings.theme'),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              tr('nurse.settings.dark_mode'),
                              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: AppColors.isDark,
                        activeThumbColor: AppColors.nursePrimary,
                        onChanged: (_) => ThemeController.instance.toggle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr('nurse.settings.preferences'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 11),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => context.setLocale(
                        Locale(
                          context.locale.languageCode == 'en' ? 'fr' : 'en',
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: AppColors.nursePrimary,
                              size: 21,
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                tr('language'),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              context.locale.languageCode.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.textFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, color: AppColors.borderSubtle),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            color: AppColors.nursePrimary,
                            size: 21,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Text(
                              tr('nurse.settings.audit_trail'),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            tr('nurse.settings.audit_trail_subtitle'),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: tr('shared.log_out'),
                variant: AppButtonVariant.danger,
                icon: Icons.logout,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = [
      '/nurse/dashboard',
      '/nurse/children',
      '/nurse/alerts',
      '/nurse/reports',
      '/nurse/settings',
    ];
    if (i != 4) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
