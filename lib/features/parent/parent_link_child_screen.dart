import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/child_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';
import 'qr_scan_screen.dart';

/// mobile_scanner only supports Android/iOS/web — desktop falls back to the
/// manual code entry, which is also the universal fallback for low-end
/// Android phones without a working camera.
bool get _canScanQr => kIsWeb || Platform.isAndroid || Platform.isIOS;

class ParentLinkChildScreen extends StatefulWidget {
  const ParentLinkChildScreen({super.key});

  @override
  State<ParentLinkChildScreen> createState() => _ParentLinkChildScreenState();
}

class _ParentLinkChildScreenState extends State<ParentLinkChildScreen> {
  final _codeController = TextEditingController();
  final _childRepository = ChildRepository();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _scanQr() async {
    final code = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScanScreen()));
    if (code == null || !mounted) return;
    _codeController.text = code;
    await _submit();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _error = tr('parent.link_child.error_empty'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final child = await _childRepository.linkChildByCode(code);
      if (!mounted) return;
      Navigator.of(context).pop(child);
    } on ChildNotFoundException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = tr('parent.link_child.error_link', args: ['$e']));
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
              role: Role.parent,
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    tr('parent.link_child.title'),
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
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    tr('parent.link_child.intro'),
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _canScanQr ? _scanQr : null,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 188,
                            height: 188,
                            decoration: BoxDecoration(
                              color: AppColors.parentGradientDeep,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.qr_code_2,
                              color: Colors.white,
                              size: 120,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 19,
                                color: AppColors.parentPrimary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                _canScanQr
                                    ? tr('parent.link_child.scan_qr')
                                    : tr('parent.link_child.scan_coming_soon'),
                                style: const TextStyle(
                                  color: AppColors.parentPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          tr('parent.link_child.or_enter_code'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textFaint,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    placeholder: tr('parent.link_child.code_placeholder'),
                    icon: Icons.sell_outlined,
                    controller: _codeController,
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
                  const SizedBox(height: 16),
                  AppButton(
                    label: _submitting
                        ? tr('parent.link_child.linking')
                        : tr('parent.link_child.submit'),
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
}
