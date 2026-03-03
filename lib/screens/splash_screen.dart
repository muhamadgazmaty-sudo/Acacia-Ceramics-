import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_config_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF36454F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق (أيقونة افتراضية)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.store, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // اسم التطبيق الديناميكي
            Text(
              config.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'آكاسيا للسيراميك',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Developed by: Mohammad Jazmati',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
