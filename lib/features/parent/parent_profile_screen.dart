import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/image_picker_sheet.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../data/sync/sync_service_provider.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/molecules/avatar.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final _authRepository = AuthRepository();
  final _childRepository = ChildRepository();
  late Future<({UserProfile? profile, int childCount})> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<({UserProfile? profile, int childCount})> _load() async {
    final profile = await _authRepository.resolveCurrentProfile();
    final children = await _childRepository.childrenForCurrentParent();
    return (profile: profile, childCount: children.length);
  }

  Future<void> _changeAvatar() async {
    final picked = await pickAvatarSource(context);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    try {
      await _authRepository.updateAvatar(bytes, contentType: 'image/jpeg');
      if (!mounted) return;
      setState(() => _future = _load());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr('shared.could_not_update_photo', args: ['$e']))));
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final profile = snapshot.data?.profile;
        final childCount = snapshot.data?.childCount ?? 0;
        return RoleScaffold(
          role: Role.parent,
          currentNavIndex: 4,
          onNavTap: (i) => _navigate(context, i),
          header: GradientHeader(
            role: Role.parent,
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
                        radius: 30,
                        backgroundColor: const Color(0x33FFFFFF),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.parentPrimary,
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
                        childCount == 1
                            ? tr('parent.profile.child_linked')
                            : tr('parent.profile.children_linked', args: ['$childCount']),
                        style: const TextStyle(
                          fontSize: 13,
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.call_outlined,
                      tr('parent.profile.phone'),
                      profile?.phone ?? '—',
                      divider: true,
                    ),
                    _infoRow(
                      Icons.mail_outline,
                      tr('parent.profile.email'),
                      profile?.email ?? '—',
                      divider: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr('parent.profile.preferences'),
                style: const TextStyle(
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
                              color: AppColors.parentPrimary,
                              size: 21,
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                tr('language'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              context.locale.languageCode.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textFaint,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    StreamBuilder<SyncStatusSnapshot>(
                      stream: syncService.statusStream,
                      initialData: syncService.lastStatus,
                      builder: (context, snapshot) {
                        final status = snapshot.data ?? syncService.lastStatus;
                        return Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cloud_done_outlined,
                                color: AppColors.parentPrimary,
                                size: 21,
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr('parent.profile.offline_data'),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      _syncLabel(status),
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: AppColors.riskNormalDot,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    required bool divider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.parentPrimary, size: 21),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (divider) const Divider(height: 1, color: AppColors.borderSubtle),
      ],
    );
  }

  void _navigate(BuildContext context, int i) {
    const routes = [
      '/parent/dashboard',
      '/parent/charts',
      '/parent/tips',
      '/parent/notifications',
      '/parent/profile',
    ];
    if (i != 4) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
