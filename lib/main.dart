import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/report_screen.dart';
import 'screens/map_screen.dart';
import 'screens/alerts_screen.dart';

void main() {
  runApp(const Emergency911App());
}

class Emergency911App extends StatelessWidget {
  const Emergency911App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '911 Emergency Response',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/sos': (context) => const SosScreen(),
        '/report': (context) => const ReportScreen(),
        '/map': (context) => const MapScreen(),
        '/alerts': (context) => const AlertsScreen(),
      },
    );
  }
}
