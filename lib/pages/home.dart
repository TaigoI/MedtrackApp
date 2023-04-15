import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/components/prescription.dart';
import 'package:medtrack/components/prescription_item.dart';
import 'package:medtrack/pages/ring.dart';

import '../cache/prescription_cache.dart';

import 'package:medtrack/services/alarms_service.dart';

PrescriptionItem testItem = 
  PrescriptionItem(medicine: "Amoxilina", dose: "1", dosage: "3", dosageUnit: "MG", time: '1', date: '1');

AlarmPrescriptionItem alarmTest = 
  AlarmPrescriptionItem(prescriptionItem: testItem, audioPath: 'sounds/mozart.mp3', vibrate: true);

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PrescriptionCache prescriptionCache =  PrescriptionCache();

  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings)
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RingScreen(alarmSettings: alarmSettings)
      )
    );
    loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {alarmTest.setPeriodicAlarm();},
        ),
        title: Image.asset('assets/images/logo.png', height: 48),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {stopAlarms();},
          )
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: FutureBuilder<List<Prescription>?>(
            future: prescriptionCache.getAllRecords(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) { return snapshot.data?[index]; },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
      )
    );
  }
}
  