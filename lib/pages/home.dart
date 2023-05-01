import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/prescription.dart';
import '../models/medication.dart';
import '../widgets/medication_widget.dart';
import '../widgets/bottom_bar.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _medicationBox = Hive.box('medication');

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
      comments: "",
      initialDosage: DateTime.now()
    );
    medication.save();
    medication.updateAlarms();
  }

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
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.qr_code),
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
