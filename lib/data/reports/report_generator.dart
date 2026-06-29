import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../local/app_database.dart';

/// Builds a growth-history PDF and CSV for one child's measurement
/// timeline. Pure Dart (no Flutter widgets) so it can run in `flutter test`
/// without a widget binding — `Printing`/`Share` calls stay in the screen.
class ReportGenerator {
  static const _headers = [
    'Date',
    'Weight (kg)',
    'Height (cm)',
    'MUAC (cm)',
    'BMI',
    'WAZ',
    'HAZ',
    'WHZ',
  ];

  static List<List<String>> _rows({required List<MeasurementRow> history}) => [
    for (final m in history)
      [
        m.takenAt.toIso8601String().split('T').first,
        m.weightKg.toStringAsFixed(1),
        m.heightCm.toStringAsFixed(1),
        m.muacCm?.toStringAsFixed(1) ?? '—',
        m.bmi?.toStringAsFixed(1) ?? '—',
        m.waz?.toStringAsFixed(2) ?? '—',
        m.haz?.toStringAsFixed(2) ?? '—',
        m.whz?.toStringAsFixed(2) ?? '—',
      ],
  ];

  static Future<Uint8List> buildGrowthHistoryPdf({
    required ChildRow child,
    required List<MeasurementRow> history,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              child.name,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'DOB: ${child.dateOfBirth.toIso8601String().split('T').first}'
              '   ·   Sex: ${child.sex == 'male' ? 'Male' : 'Female'}'
              '   ·   Link code: ${child.linkCode}',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Growth history',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            history.isEmpty
                ? pw.Text('No measurements recorded yet.')
                : pw.TableHelper.fromTextArray(
                    headers: _headers,
                    data: _rows(history: history),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 9,
                    ),
                    cellStyle: const pw.TextStyle(fontSize: 9),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellAlignment: pw.Alignment.centerLeft,
                  ),
          ],
        ),
      ),
    );
    return doc.save();
  }

  static String buildGrowthHistoryCsv({
    required ChildRow child,
    required List<MeasurementRow> history,
  }) {
    return const ListToCsvConverter().convert([
      _headers,
      ..._rows(history: history),
    ]);
  }
}
