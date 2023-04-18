import 'package:flutter/material.dart';

import 'package:alarm/alarm.dart';

import 'package:medtrack/pages/home.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/components/prescription_item.dart';
class RingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  late SingleAlarm singleAlarm;
  // single prescription item here

  RingScreen({super.key, required this.alarmSettings}) {
    singleAlarm = alarmsList
        .firstWhere((element) => element.alarmsIds.contains(alarmSettings.id));
  }

  Widget medicineNameText(BuildContext context, PrescriptionItem item) {
    return Text(
      "${item.medicationName} • ${item.doseAmount}${item.doseUnit}",
      style: Theme.of(context).textTheme.headlineLarge);
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
              Column(
                children: singleAlarm.items.map((e) => medicineNameText(context, e)).toList()
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

/**
 * Text("${prescriptionItem.medicine} • x${prescriptionItem.dose}",
                  style: Theme.of(context).textTheme.headlineMedium),
              Icon(
                Icons.alarm,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              
            ],
 */