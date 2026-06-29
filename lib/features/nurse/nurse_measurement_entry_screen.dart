import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/age_format.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/atoms/app_button.dart';
import '../../design_system/atoms/app_text_field.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class NurseMeasurementEntryScreen extends StatefulWidget {
  const NurseMeasurementEntryScreen({super.key, required this.childId});

  final String childId;

  @override
  State<NurseMeasurementEntryScreen> createState() => _NurseMeasurementEntryScreenState();
}

class _NurseMeasurementEntryScreenState extends State<NurseMeasurementEntryScreen> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _muac = TextEditingController();
  final _head = TextEditingController();
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  ChildRow? _child;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _childRepository.childById(widget.childId).then((c) {
      if (mounted) setState(() => _child = c);
    });
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _muac.dispose();
    _head.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final child = _child;
    if (child == null) return;
    final weightKg = double.tryParse(_weight.text.trim());
    final heightCm = double.tryParse(_height.text.trim());
    if (weightKg == null || heightCm == null) {
      setState(() => _error = tr('nurse.measure.error_validation'));
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _measurementRepository.addMeasurement(
        child: child,
        weightKg: weightKg,
        heightCm: heightCm,
        muacCm: double.tryParse(_muac.text.trim()),
        headCircumferenceCm: double.tryParse(_head.text.trim()),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/nurse/analysis/${widget.childId}');
    } catch (e) {
      setState(() => _error = tr('nurse.measure.error_submit', args: ['$e']));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _child;
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
                  HeaderIconButton(icon: Icons.arrow_back, onPressed: () => Navigator.of(context).pop()),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('nurse.measure.title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(
                        child == null ? '…' : '${child.name} · ${formatAge(child.dateOfBirth)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: child == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(label: tr('nurse.measure.weight'), controller: _weight, keyboardType: TextInputType.number),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: AppTextField(label: tr('nurse.measure.height'), controller: _height, keyboardType: TextInputType.number),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(label: tr('nurse.measure.muac'), controller: _muac, keyboardType: TextInputType.number),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: AppTextField(label: tr('nurse.measure.head_circumference'), controller: _head, keyboardType: TextInputType.number),
                            ),
                          ],
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(_error!, style: const TextStyle(color: AppColors.dangerText, fontSize: 12.5)),
                        ],
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(13)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.verified_outlined, size: 19, color: AppColors.riskNormalDot),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  tr('nurse.measure.info'),
                                  style: const TextStyle(fontSize: 12, color: AppColors.successText, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppButton(
                          label: _submitting ? tr('nurse.measure.computing') : tr('nurse.measure.submit'),
                          icon: Icons.calculate_outlined,
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
}
