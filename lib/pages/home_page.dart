import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/pages/medication_page.dart';
import 'package:medtrack/pages/read_json.dart';
import 'package:medtrack/pages/settings_page.dart';

import '../models/medication.dart';
import '../widgets/medication_widget.dart';

import 'dart:async';
import 'package:alarm/alarm.dart';

import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/ring_page.dart';

DateTime goalTime = DateTime.now().add(const Duration(seconds: 10));

DateTime today = DateTime.now();
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _medicationBox = Hive.box('medication');
  final QRCodeScanner _qrCodeScanner = QRCodeScanner();

  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;

  _clearStorage() async {
    await Hive.box('medication').clear();
    await Hive.box('alarm').clear();
    alarmsList.clear();
    await stopAllAlarms();
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

  Future<void> stopDeprecatedAlarms() async {
    final now = DateTime.now();

    for (AlarmSettings alarm in Alarm.getAlarms()) {
      if (alarm.dateTime.isBefore(now)) {
        await Alarm.stop(alarm.id);
      }
    }
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
          title: Image.asset('assets/images/logo.png', height: 48),
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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () async {
                  await _qrCodeScanner.scanQRCode();
                },
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicationPage(medication: Medication.empty(), isNew: true,)),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () async {
                    await _clearStorage();
                  },
                  child: const Icon(Icons.delete),
                ),
            ]
        )
    );
  }
}
