import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/pages/confirm_qr_code_page.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/home_page.dart';
import 'package:medtrack/theme.dart';
import 'package:alarm/alarm.dart';
import 'package:medtrack/models/settings.dart';

const settingsKey = 'user_prefs';

late Preference settings;

const String chave = "medtrack qrCode";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final now = DateTime.now();

  await Hive.initFlutter();
  await Hive.openBox('medication');
  await Hive.openBox('alarm');
  await Hive.openBox('preference');

  final configBox = Hive.box('preference');

  await Alarm.init(showDebugLogs: true);
  
  for (AlarmSettings alarm in Alarm.getAlarms()) {
    if (alarm.dateTime.isBefore(now)) {
      await Alarm.stop(alarm.id);
    }
  }

  await Alarm.setNotificationOnAppKillContent(
    'Seus alarmes podem não tocar', 
    'Você fechou o app. Por favor, abra-o novamente para que os alarmes toquem.'
  );

  alarmsList = getAlarmList();
  print("at main, alarmsList: $alarmsList");

  if (configBox.get(settingsKey) != null) {
    settings = Preference.fromMap(configBox.get(settingsKey).cast);
  } else {
    settings = Preference(
        key: settingsKey,
        //selectedRingtones: ['sounds/mozart.mp3'],
        receiveNotifications: true,
        confirmAlarmQRCode: true,
        receiveNotificationsTwentyMinutes: true);
  }

  runApp(const MyApp());
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
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
        '/scan/confirm': (context) => ScanQrCode()
      },
      // home: Home(),
    );
  }
}