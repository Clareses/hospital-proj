import 'package:flutter/material.dart';
import 'package:hospital_end/pages/login.dart';
import 'package:hospital_end/utils/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const AppEntry(),
    );
  }
}

/// 入口：根据登录状态跳转
class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final isLogin = Global().isLogin;
    return const LoginPage();
    // return isLogin ? const HomePage() : const LoginPage();
  }
}
