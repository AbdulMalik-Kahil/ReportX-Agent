import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/talent_pulse_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TalentPulseApp());
}

class TalentPulseApp extends StatelessWidget {
  const TalentPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReportX Agent - AI Performance Intelligence',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TalentPulseHome(),
    );
  }
}
