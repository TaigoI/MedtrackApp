import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home.dart';
import 'theme.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init(showDebugLogs: true);
  await Alarm.setNotificationOnAppKillContent(
    'Seus alarmes podem não tocar', 
    'Você fechou o app. Por favor, abra-o novamente para que os alarmes toquem.'
  );

  for (AlarmSettings alarm in Alarm.getAlarms()) {
    await Alarm.stop(alarm.id);
  }

  await Hive.initFlutter();
  await Hive.openBox('items');
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