import 'who_table_loader.dart';
import 'z_score_engine.dart';

Future<WhoZScoreEngine>? _engineFuture;

/// Lazily loads the WHO LMS tables once per app run and reuses the same
/// [WhoZScoreEngine] instance afterwards.
Future<WhoZScoreEngine> whoZScoreEngine() {
  return _engineFuture ??= WhoTableLoader.load();
}
