import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/prescription.dart';
import '../models/medication.dart';
import '../widgets/medication_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _items = Hive.box('item');
  final _prescriptions = Hive.box('prescription');

  _addItem(String title) {
    var prescriptionModel = Prescription(
      key: UniqueKey().toString(),
      doctorName: "Médico do Taígo",
      doctorRegistration: "0000 CRM-AL",
      patientName: "Taígo"
    );
    prescriptionModel.persist();

    var itemModel = Medication.fromJson({
      "key": UniqueKey().toString(),
      "prescriptionKey": prescriptionModel.key,
      "medicationName": "Paracetamol",
      "medicationDosageAmount": 250,
      "medicationDosageUnit": "MG/ML",
      "doseAmount": 5,
      "doseUnit": "ml",
      "interval": 60,
      "occurrences": 10,
      "comments": "",
      "initialDosage": "2023-12-12 00:00:00"
    });
    itemModel.persist();
  }

  _clearStorage() async {
    _items.clear();
    _prescriptions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {},
          ),
          title: Image.asset('assets/images/logo.png', height: 48),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle_rounded),
              onPressed: () {},
            )
          ],
          centerTitle: true,
          elevation: 4,
        ),
        body: ValueListenableBuilder(
          valueListenable: _items.listenable(),
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
                    final item = jsonDecode(box.getAt(index));
                    return MedicationWidget.fromJson(item);
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
              ]
          )
        )
    );
  }

}

/*

FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!initialized) {
                  var objects = storage.getItem('list');
                  if (objects != null) {
                    List<Prescription> prescriptions = [];
                    for(var object in objects as List){
                      Prescription value = Prescription.fromJson(_deleteItem, object);
                      prescriptions.add(value);
                    }
                    list.items = prescriptions;
                  }
                  initialized = true;
                }

                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: list.items.length,
                            itemBuilder: (context, index) {
                              return list.items[index];
                            }))
                  ],
                );
              }
            )

*/


/*
            FloatingActionButton(
              onPressed: () {
                _addItem('Sample Prescription');
              },
              child: const Icon(Icons.add),
            ),
*/
