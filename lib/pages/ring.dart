import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../components/prescription_item.dart';
import 'package:medtrack/pages/home.dart';

class RingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  late PrescriptionItem prescriptionItem;

  RingScreen({super.key, required this.alarmSettings}) {
    prescriptionItem = 
      alarmsList.firstWhere(
        (element) => element.alarmsIds.contains(alarmSettings.id)
      ).prescriptionItem;
  }

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
            Text("${prescriptionItem.medicine} • ${prescriptionItem.dose}",
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
