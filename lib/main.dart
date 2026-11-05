
import 'package:flutter/material.dart';
import 'pages/user/dashboard/user_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SirumaApp());
}

class SirumaApp extends StatelessWidget {
  const SirumaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRUMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F8F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B50),
          primary: const Color(0xFF006B50),
        ),
      ),
      home: const UserDashboardPage(
        namaPengguna: 'Pengguna',
      ),
    );
  }
}
