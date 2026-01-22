import 'package:expense_tracker/config/theme_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.surface,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
            Image.asset('assets/logo.png', scale: 5),
            Text('FinWise', style: Theme.of(context).textTheme.headlineLarge),

            Text(
              'Know Where Your Money Goes',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
