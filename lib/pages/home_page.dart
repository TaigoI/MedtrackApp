import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:medtrack/pages/medication_page.dart';

import '../models/medication.dart';
import '../widgets/medication_widget.dart';

import 'dart:async';
import 'package:alarm/alarm.dart';

import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/pages/ring_page.dart';
import 'package:medtrack/pages/read_json.dart';
import 'package:medtrack/pages/settings_page.dart';


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
    //loadAlarms();
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
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF044c73),
                        ),
                        child: const Icon(
                          Icons.vaccines_rounded,
                          color: Color(0xFFbadcf5),
                          size: 80.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Para importar uma receita, \nclique no botão +.',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                ),
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
                icon: Icon(Icons.dashboard),
                onPressed: () {},
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
              SpeedDial(
                child: const Icon(Icons.add),
                children: [
                  SpeedDialChild(
                    shape: CircleBorder(),
                    child: const Icon(Icons.receipt),
                    label: 'Adicionar medicamentos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicationPage(medication: Medication.empty(), isNew: true,)),
                      );
                    },
                  ),
                  SpeedDialChild(
                    shape: CircleBorder(),
                    child: const Icon(Icons.qr_code),
                    label: 'Importar nova receita',
                    onTap: () async {
                      await _qrCodeScanner.scanQRCode();
                    },
                  ),
                ],
              ),
            ]
        )
    );
  }
}
