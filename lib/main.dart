import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/home_page.dart';
import 'theme.dart';

import 'package:medtrack/models/settings.dart';

const settingsKey = 'user_prefs';

late Preference settings;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('medication');
  await Hive.openBox('alarm');
  await Hive.openBox('preference');

  final configBox = Hive.box('preference');
 // final map = configBox.get(settingsKey) as Map?;

  // if (map != null) {
  //   settings = Preference.fromMap(map);
  // } else {
  //   settings = Preference(
  //     key: settingsKey,
  //     receiveNotifications: true,
  //     confirmAlarmQRCode: true,
  //     receiveNotificationsTwentyMinutes: true,
  //   );
  // }

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
      home: const HomePage(),
    );
  }
}
