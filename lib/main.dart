import 'package:expense_tracker/config/themes.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/ui/screens/login.dart';
import 'package:expense_tracker/ui/screens/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: SafeArea(
        child: const LoginPage())));
}
