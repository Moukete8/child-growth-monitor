import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/child_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../data/reports/report_generator.dart';
import '../../design_system/molecules/list_tiles.dart';
import '../../design_system/organisms/gradient_header.dart';
import '../../design_system/templates/role_scaffold.dart';
import '../../design_system/tokens/app_colors.dart';

class _ChildReport {
  const _ChildReport({required this.child, required this.history});
  final ChildRow child;
  final List<MeasurementRow> history;
}

class NurseReportsScreen extends StatefulWidget {
  const NurseReportsScreen({super.key});

  @override
  State<NurseReportsScreen> createState() => _NurseReportsScreenState();
}

class _NurseReportsScreenState extends State<NurseReportsScreen> {
  final _childRepository = ChildRepository();
  final _measurementRepository = MeasurementRepository();
  late Future<List<_ChildReport>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_ChildReport>> _load() async {
    final children = await _childRepository.childrenForCurrentNurse();
    final out = <_ChildReport>[];
    for (final child in children) {
      final history = await _measurementRepository.historyForChild(child.id);
      out.add(_ChildReport(child: child, history: history));
    }
    return out;
  }

  Future<void> _generatePdf(_ChildReport report) async {
    await Printing.layoutPdf(
      onLayout: (_) => ReportGenerator.buildGrowthHistoryPdf(
        child: report.child,
        history: report.history,
      ),
      name: '${report.child.name}_growth_history.pdf',
    );
  }

  Future<void> _sharePdf(_ChildReport report) async {
    final bytes = await ReportGenerator.buildGrowthHistoryPdf(
      child: report.child,
      history: report.history,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${report.child.name}_growth_history.pdf',
    );
  }

  Future<void> _exportCsv(_ChildReport report) async {
    final csv = ReportGenerator.buildGrowthHistoryCsv(
      child: report.child,
      history: report.history,
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${report.child.name}_growth_history.csv');
    await file.writeAsString(csv);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], fileNameOverrides: [file.path]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      role: Role.nurse,
      currentNavIndex: 3,
      onNavTap: (i) => _navigate(context, i),
      header: GradientHeader(
        role: Role.nurse,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('nurse.reports.title'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              tr('nurse.reports.subtitle'),
              style: const TextStyle(fontSize: 12.5, color: Color(0xD9FFFFFF)),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<_ChildReport>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data!;
          if (reports.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  tr('nurse.reports.empty'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textFaint, fontSize: 13),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final report = reports[i];
              return ReportTile(
                icon: Icons.history,
                title: tr('nurse.reports.history_title', args: [report.child.name]),
                subtitle: report.history.length == 1
                    ? tr('nurse.reports.measurement_count_one', args: ['${report.history.length}'])
                    : tr('nurse.reports.measurement_count', args: ['${report.history.length}']),
                brand: AppColors.nursePrimary,
                onGeneratePdf: () => _generatePdf(report),
                onExport: () => _exportCsv(report),
                onShare: () => _sharePdf(report),
              );
            },
          );
        },
      ),
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
    if (i != 3) Navigator.of(context).pushReplacementNamed(routes[i]);
  }
}
