import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/prescription.dart';
import '../models/medication.dart';
import '../widgets/medication_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'dart:async';
import 'package:alarm/alarm.dart';

import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/ring.dart';

DateTime goalTime = DateTime.now().add(const Duration(seconds: 10));

DateTime today = DateTime.now();

List<Medication> testItems = [

];

List<AppAlarm> alarmsList = List.empty(growable: true);

String test = '';
List<String> tests = [];

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
  final _medicationBox = Hive.box('medication');

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
      interval: 330,
      occurrences: 10,
      comments: "Você precisa tomar seu remédio em jejum.",
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
      print('\nloaded alarms: $alarms\n');
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

  void readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              for (Medication item in testItems) {
                alarmFromMedication(alarmsList, item);
              }
              printAlarms();
            },
          ),
          title: Image.asset('assets/images/logo.png', height: 48),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {printAlarms();},
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
                      _clearStorage();
                    },
                    child: const Icon(Icons.qr_code),
                  ),
                  const SizedBox(height: 10),
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
              ]
          )
        )
    );
  }
}
