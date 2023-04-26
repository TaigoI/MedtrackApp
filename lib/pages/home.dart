import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/prescription.dart';
import '../models/medication.dart';
import '../widgets/medication_widget.dart';

import 'dart:async';
import 'package:alarm/alarm.dart';

import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/ring.dart';

DateTime goalTime = DateTime.now().add(const Duration(seconds: 10));

DateTime today = DateTime.now();

List<Medication> testItems = [

];

List<AppAlarm> alarmsList = List.empty(growable: true);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _medicationBox = Hive.box('medication');
  final _alarmBox = Hive.box('alarm');

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  _addItem(String title) {
    var prescriptionModel = Prescription(
      key: UniqueKey().toString(),
      doctorName: "Médico do Taígo",
      doctorRegistration: "0000 CRM-AL",
      patientName: "Taígo"
    );
    prescriptionModel.persist();

    var medication = Medication(
      key: UniqueKey().toString(),
      prescriptionKey: prescriptionModel.key,
      medicationName: "Paracetamol",
      medicationDosageAmount: 250,
      medicationDosageUnit: "MG/ML",
      doseAmount: 5,
      doseUnit: "ml",
      interval: 360,
      occurrences: 10,
      comments: "",
      initialDosage: DateTime(
        today.year,
        today.month,
        today.day,
        21,
        0,
        0,
        0,
        )
    );
    medication.save();
    medication.updateAlarmes();

  }

  _clearStorage() async {
    Hive.box('medication').clear();
    Hive.box('prescription').clear();
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
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RingScreen(alarmSettings: alarmSettings, medicationBox: _medicationBox,)));
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
              for (Medication item in testItems) {
                alarmFromMedication(item);
              }
              printAlarms();
            },
          ),
          title: Image.asset('assets/images/logo.png', height: 48),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {printAlarms(); print('\n\n');
                _alarmBox.toMap().forEach((key, value) {print('$key:$value');});
              },
            )
          ],
          centerTitle: true,
          elevation: 4,
        ),
        body: ValueListenableBuilder(
          valueListenable: _medicationBox.listenable(),
          builder: (context, Box box, widget) {
            if(box.isEmpty){
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
                    return MedicationWidget.fromMap(box.getAt(index).cast<String, dynamic>());
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
                      clearAllAlarms();
                    },
                    child: const Icon(Icons.delete),
                  ),
              ]
          )
        )
    );
  }
}
