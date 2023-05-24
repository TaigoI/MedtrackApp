import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/pages/splash_screen.dart';
import 'pages/home_page.dart';
import 'theme.dart';
import 'package:medtrack/models/settings.dart';
import 'package:alarm/alarm.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/tutorial_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const settingsKey = 'user_prefs';
Preference? settings;
bool showOnboarding = true;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Alarm.init(showDebugLogs: true);

  await Hive.initFlutter();
  await Hive.openBox('medication');
  await Hive.openBox('alarm');
  await Hive.openBox('preference');

  final configBox = Hive.box('preference');

  if (configBox.get(settingsKey) != null) {
    settings =
        Preference.fromMap(configBox.get(settingsKey).cast<String, dynamic>());
  } else {
    settings = Preference(
        key: settingsKey,
        selectedRingtone: 'sounds/mozart.mp3',
        keyQRCode: '',
        confirmAlarmQRCode: false,
        receiveNotifications: true);
  }

  DateTime now = DateTime.now();

  for (AlarmSettings alarm in Alarm.getAlarms()) {
    if (alarm.dateTime.isBefore(now)) {
      await Alarm.stop(alarm.id);
    }
  }

  await Alarm.setNotificationOnAppKillContent(
    'Seus alarmes podem não tocar', 
    'Você fechou o app. Por favor, abra-o novamente para que os alarmes toquem.'
  );

  alarmsList = await getAlarmList();

  WidgetsFlutterBinding.ensureInitialized();
  final preference = await SharedPreferences.getInstance();
  showOnboarding = preference.getBool('ONBOARDING') ?? true;

  runApp(const MyApp());
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
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
        '/': (context) => SplashScreen(),
        '/home': (context) => showOnboarding ? TutorialScreen() : const Home(), // Home screen route
      },
      // home: const Home(),
    );
  }
}
