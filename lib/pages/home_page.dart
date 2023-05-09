import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/pages/medication_page.dart';
import 'package:medtrack/pages/read_json.dart';
import 'package:medtrack/pages/settings_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../models/medication.dart';
import '../widgets/medication_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _medicationBox = Hive.box('medication');
  final QRCodeScanner _qrCodeScanner = QRCodeScanner();

  _clearStorage() async {
    Hive.box('medication').clear();
    Hive.box('prescription').clear();
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
                    child: const Icon(Icons.delete),
                    label: 'Excluir alarmes',
                    onTap: () {
                      _clearStorage();
                    },
                  ),
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