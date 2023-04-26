import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home.dart';
import 'theme.dart';
import 'package:alarm/alarm.dart';
import 'package:medtrack/services/alarms_service.dart';

List<AppAlarm> alarmsList = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('prescription');
  await Hive.openBox('medication');
  await Hive.openBox('alarm');

  await Alarm.init(showDebugLogs: true);
  await Alarm.setNotificationOnAppKillContent(
    'Seus alarmes podem não tocar', 
    'Você fechou o app. Por favor, abra-o novamente para que os alarmes toquem.'
  );

  // print("\nour alarms:");
  // printAlarms();

  alarmsList = getAlarmList();

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
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
      // home: Home(),
    );
  }
}