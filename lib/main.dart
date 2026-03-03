import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services (سننشئها في الخطوات القادمة)
// import 'services/auth_service.dart';
// import 'services/app_config_provider.dart';

// Screens (سننشئها في الخطوات القادمة)
// import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Firebase
  await Firebase.initializeApp();
  
  runApp(const AcaciaApp());
}

class AcaciaApp extends StatelessWidget {
  const AcaciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acacia Ceramics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD4AF37), // ذهبي
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF36454F)),
          titleTextStyle: TextStyle(
            color: Color(0xFF36454F),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFF36454F), // فحمي
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Acacia Ceramics\nDeveloped by Mohammad Jazmati',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
