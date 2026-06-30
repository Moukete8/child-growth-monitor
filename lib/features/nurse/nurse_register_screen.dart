import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/utils/image_picker_sheet.dart';
import '../../data/repositories/child_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class NurseRegisterScreen extends StatefulWidget {
  const NurseRegisterScreen({super.key});

  @override
  State<NurseRegisterScreen> createState() => _NurseRegisterScreenState();
}

class _NurseRegisterScreenState extends State<NurseRegisterScreen> {
  bool _isMale = true;
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _contactController = TextEditingController();
  final _childRepository = ChildRepository();
  bool _submitting = false;
  String? _error;
  XFile? _avatar;

  Future<void> _pickAvatar() async {
    final picked = await pickAvatarSource(context);
    if (picked != null) setState(() => _avatar = picked);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _birthWeightController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  DateTime? _parseDob(String text) {
    final parts = text.trim().split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final dob = _parseDob(_dobController.text);
    if (name.isEmpty || dob == null) {
      setState(() => _error = tr('nurse.register.error_validation'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final avatarBytes = _avatar == null ? null : await _avatar!.readAsBytes();
      final child = await _childRepository.registerChild(
        name: name,
        dateOfBirth: dob,
        sex: _isMale ? 'male' : 'female',
        birthWeightKg: double.tryParse(_birthWeightController.text.trim()),
        parentContact: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        avatarBytes: avatarBytes,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(tr('nurse.register.dialog_title')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('nurse.register.dialog_body', args: [child.name])),
              const SizedBox(height: 12),
              Text(
                tr('nurse.register.dialog_share'),
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Center(child: QrImageView(data: child.linkCode, size: 160)),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  child.linkCode,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = tr('nurse.register.error_submit', args: ['$e']));
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
            GradientHeader(
              role: Role.nurse,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    tr('nurse.register.title'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        children: [
                          FutureBuilder<Uint8List>(
                            future: _avatar?.readAsBytes(),
                            builder: (context, snapshot) {
                              return CircleAvatar(
                                radius: 38,
                                backgroundColor: AppColors.background,
                                backgroundImage: snapshot.data == null
                                    ? null
                                    : MemoryImage(snapshot.data!),
                                child: snapshot.data == null
                                    ? Icon(
                                        Icons.child_care,
                                        color: AppColors.textFaint,
                                        size: 32,
                                      )
                                    : null,
                              );
                            },
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.nursePrimary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      tr('nurse.register.photo_optional'),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    label: tr('nurse.register.name_label'),
                    placeholder: tr('nurse.register.name_placeholder'),
                    controller: _nameController,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: tr('nurse.register.dob_label'),
                          placeholder: 'DD/MM/YYYY',
                          icon: Icons.calendar_today_outlined,
                          controller: _dobController,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 11),
                      SizedBox(
                        width: 118,
                        child: AppTextField(
                          label: tr('nurse.register.birth_weight_label'),
                          placeholder: '3.3',
                          controller: _birthWeightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    tr('nurse.register.sex_label'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: _sexOption(tr('nurse.register.male'), true),
                        ),
                        Expanded(
                          child: _sexOption(tr('nurse.register.female'), false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    label: tr('nurse.register.contact_label'),
                    placeholder: '+237 6XX XX XX XX',
                    icon: Icons.call_outlined,
                    controller: _contactController,
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
                          Icons.qr_code_2,
                          size: 19,
                          color: AppColors.nursePrimary,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            tr('nurse.register.info'),
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
                  const SizedBox(height: 18),
                  AppButton(
                    label: _submitting
                        ? tr('nurse.register.submitting')
                        : tr('nurse.register.submit'),
                    color: AppColors.nursePrimary,
                    onPressed: _submitting ? null : _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sexOption(String label, bool male) {
    final active = _isMale == male;
    return GestureDetector(
      onTap: () => setState(() => _isMale = male),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.nursePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
