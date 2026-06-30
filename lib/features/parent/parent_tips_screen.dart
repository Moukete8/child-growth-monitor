import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/utils/recommendation_mapping.dart';
import '../../core/utils/risk_mapping.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../design_system/molecules/recommendation_card.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/tokens/app_colors.dart';

class ParentTipsScreen extends StatefulWidget {
  const ParentTipsScreen({super.key});

  @override
  State<ParentTipsScreen> createState() => _ParentTipsScreenState();
}

class _ParentTipsScreenState extends State<ParentTipsScreen> {
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();

  int _openIndex = -1;
  List<ChildRow> _children = const [];
  ChildRow? _selected;
  List<Recommendation>? _recommendations;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final children = await _childRepository.childrenForCurrentParent();
    setState(() {
      _children = children;
      _selected = children.isEmpty ? null : children.first;
    });
    await _loadRecommendationsForSelected();
  }

  Future<void> _loadRecommendationsForSelected() async {
    final child = _selected;
    if (child == null) {
      setState(() {
        _recommendations = null;
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    final history = await _measurementRepository.historyForChild(child.id);
    if (!mounted) return;
    if (history.isEmpty) {
      setState(() {
        _recommendations = null;
        _loading = false;
      });
      return;
    }
    final latest = history.first;
    final worst = worstClassification(waz: latest.waz ?? 0, haz: latest.haz ?? 0, whz: latest.whz ?? 0);
    setState(() {
      _recommendations = recommendationsFor(worst);
      _loading = false;
      _openIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientHeader(
          role: Role.parent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr('parent.tips_screen.title'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                _selected == null ? tr('parent.tips_screen.subtitle_no_child') : tr('parent.tips_screen.subtitle_child', args: [_selected!.name]),
                style: const TextStyle(fontSize: 12.5, color: Color(0xCCFFFFFF)),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_children.length > 1) ...[
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _children.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final child = _children[i];
                        final active = child.id == _selected?.id;
                        return ChoiceChip(
                          label: Text(child.name),
                          selected: active,
                          selectedColor: AppColors.parentPrimary,
                          labelStyle: TextStyle(color: active ? Colors.white : AppColors.textPrimary, fontSize: 12.5),
                          onSelected: (_) {
                            setState(() => _selected = child);
                            _loadRecommendationsForSelected();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_recommendations == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(tr('tips.empty'),
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
                  )
                else ...[
                  for (var i = 0; i < _recommendations!.length; i++) ...[
                    RecommendationCard(
                      icon: _recommendations![i].icon,
                      iconBg: _recommendations![i].iconBg,
                      iconColor: _recommendations![i].iconColor,
                      title: _recommendations![i].title,
                      shortText: _recommendations![i].shortText,
                      body: _recommendations![i].body,
                      expanded: _openIndex == i,
                      onToggle: () => setState(() => _openIndex = _openIndex == i ? -1 : i),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFFBF0DC), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign, color: AppColors.riskModerateDot, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(tr('parent.tips_screen.footer'),
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF8A5A12), height: 1.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
        ),
      ],
    );
  }
}
