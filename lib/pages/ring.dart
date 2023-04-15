import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../services/alarms_service.dart';

class RingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  // pegar a classe de alarme também para ter as informações do medicamento
  const RingScreen({Key? key, required this.alarmSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        title: Image.asset('assets/images/logo.png', height: 48),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.account_circle_rounded), onPressed: () {})
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Alarme ${alarmSettings.id} tocando...",
                style: Theme.of(context).textTheme.titleLarge),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  //snooze
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                            alarmSettings: alarmSettings.copyWith(
                                dateTime: DateTime(now.year, now.month, now.day,
                                        now.hour, now.minute, 0, 0)
                                    .add(const Duration(minutes: 3))))
                        .then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Soneca",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                    onPressed: () {
                      Alarm.stop(alarmSettings.id)
                          .then((_) => Navigator.pop(context));
                    },
                    child: Text("Parar",
                        style: Theme.of(context).textTheme.titleLarge)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
