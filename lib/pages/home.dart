import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/components/prescription.dart';
import 'package:medtrack/components/prescription_item.dart';
import 'package:medtrack/pages/ring.dart';

import 'package:medtrack/services/alarms_service.dart';

DateTime goalTime = DateTime.now().add(const Duration(seconds: 45));

List<PrescriptionItem> testItems = [
  PrescriptionItem(
    medicationName: "Trembolona", 
    doseAmount: "500", 
    doseUnit: "MG", 
    dosage: "100", 
    dosageUnit: "M", 
    interval: 15, 
    occurences: 5,
    initialDosage: DateTime.now().add(const Duration(seconds: 15)),
    ),

  PrescriptionItem(
    medicationName: "Durateston", 
    doseAmount: "500", 
    doseUnit: "MG", 
    dosage: "100", 
    dosageUnit: "M", 
    interval: 15, 
    occurences: 5,
    initialDosage: DateTime.now().add(const Duration(seconds: 15)),
    
    ),

  PrescriptionItem(
    medicationName: "Deca Durabolin", 
    doseAmount: "500", 
    doseUnit: "MG", 
    dosage: "100", 
    dosageUnit: "M", 
    interval: 15, 
    occurences: 5,
    initialDosage: DateTime.now().add(const Duration(seconds: 15)),
    ),
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

class PrescriptionList {
  List<Prescription> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class _HomeState extends State<Home> {
  final list = PrescriptionList();
  final storage = LocalStorage('prescriptions.json');
  int counter = 1;
  
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  _addItem(String pacientName) {
    final item = Prescription(
      key: UniqueKey(),
      pacientName: pacientName,
      items: [
        PrescriptionItem(
          medicationName: "Outra Bomba", 
          doseAmount: "500", 
          doseUnit: "MG", 
          dosage: "100", 
          dosageUnit: "M", 
          interval: 15, 
          occurences: 5),
      ],
      deleteFunction: _deleteItem,
    );

    setState(() {
      counter += 1;
      list.items.add(item);
      _saveToStorage();
    });
  }

  _deleteItem(UniqueKey key) {
    setState(() {
      list.items.removeWhere((element) => element.key == key);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('list', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();
    setState(() {
      counter = 1;
      list.items = storage.getItem('list') ?? [];
    });
  }

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
      print('\nloaded alarms: $alarms\n');
      
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
            onPressed: () {
              for (PrescriptionItem item in testItems) {
                alarmFromPrescriptionItem(alarmsList, item, goalTime);
              }
              printAlarms();

            },
          ),
          title: Image.asset('assets/images/logo.png', height: 48),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () => stopAllAlarms(),
            )
          ],
          centerTitle: true,
          elevation: 4,
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: list.items.length,
                        itemBuilder: (context, index) {
                          return list.items[index];
                        }))
              ],
            )
        ),
        floatingActionButton: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _addItem('Hélder Silva Ferreira Lima');
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
            ]
          )
        )
    );
  }
}
  