import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/components/prescription.dart';

import 'package:alarm/alarm.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/ring.dart';

import '../components/prescription_item.dart';

DateTime goalTime = DateTime.now().add(const Duration(seconds: 10));

List<PrescriptionItemModel> testItems = [
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Hélder Lima",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Hélder Lima",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Manuel Bandeira",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Manuel Bandeira",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Manuel Bandeira",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Gabriel Faure",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Gabriel Faure",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Gabriel Faure",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Joseph Ratzinger",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Joseph Ratzinger",
      comments: ""),
  PrescriptionItemModel(
      key: UniqueKey().toString(),
      medicationName: "Trembolona",
      doseAmount: "500",
      doseUnit: "MG",
      dosageAmount: 100,
      dosageUnit: "ML",
      interval: 15,
      occurrences: 5,
      initialDosage: DateTime.now().add(const Duration(seconds: 15)),
      patientName: "Joseph Ratzinger",
      comments: ""),
];

List<SingleAlarm> alarmsList = List.empty(growable: true);

// PrescriptionItem testItem =
//   PrescriptionItem(medicine: "Amoxilina", dose: "1", dosage: "3", dosageUnit: "MG", time: '1', date: '1');

// AlarmPrescriptionItem alarmTest =
//   AlarmPrescriptionItem(prescriptionItem: testItem, audioPath: 'sounds/mozart.mp3', vibrate: true);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _items = Hive.box('items');

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  _addItem(String title) {
    var prescriptionModel = PrescriptionModel(
        key: UniqueKey().toString(),
        doctorName: "Médico do Taígo",
        doctorRegistration: "0000 CRM-AL");
    //prescriptionModel.persist();

    var itemModel = PrescriptionItemModel.fromJson({
      "key": UniqueKey().toString(),
      "patientName": "Taígo Pedrosa",
      "medicationName": "Paracetamol",
      "doseAmount": 250,
      "doseUnit": "MG/ML",
      "dosageAmount": 5,
      "dosageUnit": "ML",
      "interval": 60,
      "occurrences": 10,
      "comments": "",
      "initialDosage": "2023-12-12 00:00:00"
    });
    itemModel.persist();
  }

  _clearStorage() async {
    _items.deleteFromDisk();
  }

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream
        .listen((alarmSettings) => navigateToRingScreen(alarmSettings));
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
      print('\nloaded alarms: $alarms\n');
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RingScreen(alarmSettings: alarmSettings)));
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
            onPressed: () {
              for (PrescriptionItemModel item in testItems) {
                alarmFromPrescriptionItem(alarmsList, item, goalTime);
              }
              printAlarms();},
          ),
          title: Image.asset('assets/images/logo.png', height: 48),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {
                stopAllAlarms();    
              },
            )
          ],
          centerTitle: true,
          elevation: 4,
        ),
        body: ValueListenableBuilder(
          valueListenable: _items.listenable(),
          builder: (context, Box box, widget) {
            if (box.isEmpty) {
              return const Center(
                child: Text('Empty'),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = jsonDecode(box.getAt(index));
                    return PrescriptionItem.fromJson(item);
                  },
                ),
              );
            }
          },
        ),
        floatingActionButton: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _addItem('Sample Prescription');
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: () {
                  _clearStorage();
                },
                child: const Icon(Icons.delete),
              ),
            ])));
  }
}
