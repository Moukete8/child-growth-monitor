import 'package:child_growth_monitor/data/local/app_database.dart';
import 'package:child_growth_monitor/data/reports/report_generator.dart';
import 'package:flutter_test/flutter_test.dart';

ChildRow _child() => ChildRow(
      id: 'child-1',
      name: 'Baby Kofi',
      dateOfBirth: DateTime(2023, 1, 15),
      sex: 'male',
      birthWeightKg: 3.2,
      parentUserId: 'parent-1',
      registeredByNurseId: 'nurse-1',
      linkCode: 'ABC123',
      parentContact: null,
      avatarUrl: null,
      syncStatus: SyncStatus.synced,
    );

MeasurementRow _measurement({required double weight, required DateTime takenAt}) => MeasurementRow(
      id: 'm-${takenAt.toIso8601String()}',
      childId: 'child-1',
      nurseId: 'nurse-1',
      takenAt: takenAt,
      weightKg: weight,
      heightCm: 60,
      muacCm: 13.5,
      headCircumferenceCm: 40,
      bmi: 16.2,
      waz: -1.1,
      haz: -0.8,
      whz: -1.4,
      syncStatus: SyncStatus.synced,
    );

void main() {
  group('ReportGenerator', () {
    test('buildGrowthHistoryCsv includes header row and one row per measurement', () {
      final history = [
        _measurement(weight: 5.4, takenAt: DateTime(2023, 3, 1)),
        _measurement(weight: 6.1, takenAt: DateTime(2023, 4, 1)),
      ];

      final csv = ReportGenerator.buildGrowthHistoryCsv(child: _child(), history: history);
      final lines = csv.trim().split('\r\n');

      expect(lines, hasLength(3));
      expect(lines.first, 'Date,Weight (kg),Height (cm),MUAC (cm),BMI,WAZ,HAZ,WHZ');
      expect(lines[1], contains('2023-03-01'));
      expect(lines[1], contains('5.4'));
      expect(lines[2], contains('6.1'));
    });

    test('buildGrowthHistoryCsv emits just the header when there are no measurements', () {
      final csv = ReportGenerator.buildGrowthHistoryCsv(child: _child(), history: const []);
      expect(csv.trim().split('\r\n'), hasLength(1));
    });

    test('buildGrowthHistoryPdf produces a non-empty PDF document', () async {
      final bytes = await ReportGenerator.buildGrowthHistoryPdf(
        child: _child(),
        history: [_measurement(weight: 5.4, takenAt: DateTime(2023, 3, 1))],
      );

      expect(bytes, isNotEmpty);
      // PDF files start with the "%PDF-" magic header.
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });
}
