import 'package:flutter/material.dart';
import 'package:appsilma/database/database_helper.dart';
import 'package:appsilma/screens/login_page.dart';
import 'package:appsilma/screens/register_page.dart';
import 'package:appsilma/screens/home_page.dart';
import 'package:appsilma/models/slot_lapangan.dart';

void main() async {
  // Pastikan Flutter binding siap sebelum akses database
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database saat app pertama kali launch
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySILMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5C38)),
        fontFamily: 'Roboto',
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/login':
            final args = settings.arguments as Map<String, String>?;
            return MaterialPageRoute(
              builder: (_) => LoginPage(
                prefillContact: args?['contact'] ?? '',
                prefillPassword: args?['password'] ?? '',
              ),
            );
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case '/home':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => HomePage(
                userId: args?['userId'] ?? 1,
                userName: args?['userName'] ?? 'Pengguna',
              ),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
      initialRoute: '/login',
    );
  }
}
