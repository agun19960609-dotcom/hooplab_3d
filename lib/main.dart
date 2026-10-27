import 'package:flutter/material.dart';
import 'package:hooplab_3d/data/launch_prefs.dart';
import 'package:hooplab_3d/theme/hooplab_theme.dart';
import 'package:hooplab_3d/views/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LaunchPrefs.ensureLoaded();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOOPLAB',
      debugShowCheckedModeBanner: false,
      theme: hooplabTheme(),
      home: const MainScreen(),
    );
  }
}
