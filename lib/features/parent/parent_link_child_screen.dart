import 'package:flutter/material.dart';
import '../../data/repositories/child_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

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

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Enter the code given to you by the nurse.');
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
      setState(() => _error = 'Could not link this child: $e');
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
                  HeaderIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: 14),
                  const Text('Link a Child', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Connect to a child record created by a nurse. Enter the code given to you at the clinic.',
                    style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.55),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                          child: const Icon(Icons.qr_code_2, color: Colors.white, size: 120),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, size: 19, color: AppColors.parentPrimary),
                            SizedBox(width: 7),
                            Text('QR scanning coming soon — use the code below',
                                style: TextStyle(color: AppColors.parentPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or enter code', style: TextStyle(fontSize: 12, color: AppColors.textFaint)),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    placeholder: 'e.g. CMR4X9',
                    icon: Icons.sell_outlined,
                    controller: _codeController,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5)),
                  ],
                  const SizedBox(height: 16),
                  AppButton(
                    label: _submitting ? 'Linking…' : 'Link Child',
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
