import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'theme.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init(showDebugLogs: true);

  for (AlarmSettings alarm in Alarm.getAlarms()) {
    Alarm.stop(alarm.id);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Home(),
    );
  }
}