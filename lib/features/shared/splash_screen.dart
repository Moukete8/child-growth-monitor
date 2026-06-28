import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../design_system/tokens/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    final authRepository = AuthRepository();
    final minimumSplash = Future<void>.delayed(const Duration(milliseconds: 1400));
    final profile = authRepository.currentUser == null
        ? null
        : await authRepository.resolveCurrentProfile();
    await minimumSplash;
    if (!mounted) return;
    if (profile == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else if (profile.needsProfileCompletion) {
      Navigator.of(context).pushReplacementNamed('/complete-profile');
    } else {
      Navigator.of(context)
          .pushReplacementNamed(profile.isNurse ? '/nurse/dashboard' : '/parent/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1),
            end: Alignment(0.6, 1),
            colors: [
              AppColors.parentGradientStart,
              AppColors.parentGradientEnd,
              AppColors.parentGradientDeep,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(color: Color(0x38000000), blurRadius: 40, offset: Offset(0, 18))],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(Icons.favorite, color: AppColors.accentCoral, size: 64),
                    Icon(Icons.child_care, color: Colors.white, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Child Growth\nMonitoring',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.25,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'WHO-standard nutrition tracking',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xB3FFFFFF)),
              ),
              const SizedBox(height: 64),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text('Loading…',
                  style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF), letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
