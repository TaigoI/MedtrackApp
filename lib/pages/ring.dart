import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

import 'package:medtrack/components/prescription_item.dart';
import 'package:medtrack/pages/home.dart';

class RingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  late PrescriptionItem prescriptionItem;

  RingScreen({super.key, required this.alarmSettings}) {
    prescriptionItem = alarmsList
        .firstWhere((element) => element.alarmsIds.contains(alarmSettings.id))
        .prescriptionItem;
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${prescriptionItem.medicine} • x${prescriptionItem.dose}",
                  style: Theme.of(context).textTheme.headlineMedium),
              Icon(
                Icons.alarm,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    //snooze
                    onPressed: () {
                      final now = DateTime.now();
                      Alarm.set(
                              alarmSettings: alarmSettings.copyWith(
                                  dateTime: DateTime(now.year, now.month,
                                          now.day, now.hour, now.minute, 0, 0)
                                      .add(const Duration(minutes: 3))))
                          .then((_) => Navigator.pop(context));
                    },
                    icon: const Icon(Icons.snooze),
                    label: Text(
                      "SONECA",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  OutlinedButton.icon(
                      onPressed: () {
                        Alarm.stop(alarmSettings.id)
                            .then((_) => Navigator.pop(context));
                      },
                      icon: const Icon(Icons.stop),
                      label: Text("PARAR",
                          style: Theme.of(context).textTheme.titleLarge)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
