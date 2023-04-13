import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:medtrack/components/prescription.dart';

import '../components/prescription_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
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

  _addItem(String title) {
    final item = Prescription(
      key: UniqueKey(),
      title: 'Prescription $counter',
      items: [
        PrescriptionItem(
            medicationName: 'Medication Name', doseAmount: '1', doseUnit: 'ML', dosage: '1', dosageUnit: 'ML', frequency: '1', duration: '1'),
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
            FloatingActionButton(
              onPressed: () {
                _addItem('Sample Prescription');
              },
              child: const Icon(Icons.add),
            ),
*/
