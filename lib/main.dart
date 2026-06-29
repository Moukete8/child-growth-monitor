import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'data/remote/supabase_client.dart';
import 'data/sync/sync_service_provider.dart';
import 'design_system/tokens/app_colors.dart';
import 'features/nurse/nurse_alerts_screen.dart';
import 'features/nurse/nurse_child_profile_screen.dart';
import 'features/nurse/nurse_dashboard_screen.dart';
import 'features/nurse/nurse_growth_analysis_screen.dart';
import 'features/nurse/nurse_measurement_entry_screen.dart';
import 'features/nurse/nurse_register_screen.dart';
import 'features/nurse/nurse_reports_screen.dart';
import 'features/nurse/nurse_search_screen.dart';
import 'features/nurse/nurse_settings_screen.dart';
import 'features/parent/parent_child_profile_screen.dart';
import 'features/parent/parent_dashboard_screen.dart';
import 'features/parent/parent_growth_charts_screen.dart';
import 'features/parent/parent_link_child_screen.dart';
import 'features/parent/parent_notifications_screen.dart';
import 'features/parent/parent_profile_screen.dart';
import 'features/parent/parent_tips_screen.dart';
import 'features/shared/complete_profile_screen.dart';
import 'features/shared/forgot_password_screen.dart';
import 'features/shared/login_screen.dart';
import 'features/shared/signup_screen.dart';
import 'features/shared/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load();
  await AppSupabase.init();
  // Touch the singleton now (rather than on first screen read) so the
  // connectivity listener is armed from app start.
  syncService;
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const ChildGrowthApp(),
    ),
  );
}

class ChildGrowthApp extends StatefulWidget {
  const ChildGrowthApp({super.key});

  @override
  State<ChildGrowthApp> createState() => _ChildGrowthAppState();
}

class _ChildGrowthAppState extends State<ChildGrowthApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      syncService.syncNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Growth Monitoring',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(Role.parent),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/splash');
    final segments = uri.pathSegments;

    Widget page;
    switch (settings.name) {
      case '/splash':
        page = const SplashScreen();
      case '/login':
        page = const LoginScreen();
      case '/forgot-password':
        page = ForgotPasswordScreen(
          prefillEmail: settings.arguments as String?,
        );
      case '/signup':
        page = SignupScreen(
          initialRole: (settings.arguments as Role?) ?? Role.parent,
        );
      case '/complete-profile':
        page = const CompleteProfileScreen();
      case '/parent/dashboard':
        page = const ParentDashboardScreen();
      case '/parent/charts':
        page = const ParentGrowthChartsScreen();
      case '/parent/tips':
        page = const ParentTipsScreen();
      case '/parent/notifications':
        page = const ParentNotificationsScreen();
      case '/parent/link-child':
        page = const ParentLinkChildScreen();
      case '/parent/profile':
        page = const ParentProfileScreen();
      case '/nurse/dashboard':
        page = const NurseDashboardScreen();
      case '/nurse/children':
        page = const NurseSearchScreen();
      case '/nurse/register':
        page = const NurseRegisterScreen();
      case '/nurse/alerts':
        page = const NurseAlertsScreen();
      case '/nurse/reports':
        page = const NurseReportsScreen();
      case '/nurse/settings':
        page = const NurseSettingsScreen();
      default:
        // Dynamic routes: /parent/child/:id, /nurse/child/:id,
        // /nurse/measure/:id, /nurse/analysis/:id
        if (segments.length == 3 &&
            segments[0] == 'parent' &&
            segments[1] == 'child') {
          page = ParentChildProfileScreen(childId: segments[2]);
        } else if (segments.length == 3 &&
            segments[0] == 'nurse' &&
            segments[1] == 'child') {
          page = NurseChildProfileScreen(childId: segments[2]);
        } else if (segments.length == 3 &&
            segments[0] == 'nurse' &&
            segments[1] == 'measure') {
          page = NurseMeasurementEntryScreen(childId: segments[2]);
        } else if (segments.length == 3 &&
            segments[0] == 'nurse' &&
            segments[1] == 'analysis') {
          page = NurseGrowthAnalysisScreen(childId: segments[2]);
        } else {
          page = const SplashScreen();
        }
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
