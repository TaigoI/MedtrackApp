import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:medtrack/pages/home.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/models/medication.dart';
import 'package:medtrack/models/prescription.dart';
import 'package:hive/hive.dart';

class RingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  final Box<dynamic> medicationBox;
  
  late AppAlarm appAlarm;
  

  RingScreen({super.key, required this.alarmSettings, required this.medicationBox}) {
    appAlarm = alarmsList
        .firstWhere((element) => element.alarmId == alarmSettings.id);
  }

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  Map<String, List<bool>> _checklist = {};

  
  @override
  void initState() {
    super.initState();
    
    bool active = true;
    for (MapEntry e in widget.appAlarm.items.entries) {
      if (e.value.every((v) => v == false)) {
        active = false;
      } else {
        active = true;
      }
    }

    if (!active) {
      Alarm.stop(widget.appAlarm.alarmId).then((_) => Navigator.pushNamed(context, '/'));
    }

    widget.appAlarm.items.forEach((patientName, itemsList) {
      _checklist[patientName] = List.filled(
        itemsList.where((element) => element.isActive() == true).toList().length,
        false
      );
    });
  }

  Widget medicationCheckBox(
      BuildContext context, AlarmItem item, int idx, String patientName) {
    Medication med = Medication.fromMap(
        widget.medicationBox
        .get(item.medicationKey)
        .cast<String, dynamic>());
    
    return CheckboxListTile(
      value: _checklist[patientName]![idx],
      onChanged: (bool? value) {
        setState(() => _checklist[patientName]![idx] = value!);
      },
      title: Text(
        "${med.medicationName} * ${med.doseAmount}${med.doseUnit}",
      ),
      secondary: const Icon(Icons.medication_outlined),
    );
  }

  Widget patientCard(BuildContext context, String patientName, List<AlarmItem> items) {
    return Card(
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 3,
        child: Column(children: [
          Center(
            widthFactor: 2,
            heightFactor: 2,
            child: Text(
              patientName,
              style: Theme.of(context).textTheme.headlineSmall
            ),
          ),
          Column(
            children: 
                items
                .where((element) => element.isActive() == true)
                .toList()
                .asMap()
                .entries
                .map((item) => medicationCheckBox(context, item.value, item.key, patientName))
                .toList(),
          )
        ]));
  }

  List<Widget> getPatientsCards(
      BuildContext context, Map<String, dynamic> items) {
    List<Widget> cards = [];
    for (String name in items.keys) {
      cards.add(patientCard(context, name, items[name]!));
    }

    return cards;
  }

  bool checkedEverything() {
    for (String key in _checklist.keys) {
      if (!_checklist[key]!.every((element) => element == true)) {
        return false;
      }
    } 
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        title: Image.asset('assets/images/logo.png', height: 48),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.account_circle_rounded), onPressed: () {})
        ],
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          alignment: AlignmentDirectional.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200),
                  padding: const EdgeInsets.all(0),
                  child: ListView(
                      children:
                          getPatientsCards(context, widget.appAlarm.items))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Quer mesmo adiar?"),
                              content: const Text(
                                  "O alarme voltará a tocar em 3 minutos."),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      final now = DateTime.now();
                                      Alarm.set(
                                              alarmSettings:
                                                  widget.alarmSettings.copyWith(
                                                      dateTime: DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              now.hour,
                                                              now.minute,
                                                              0,
                                                              0)
                                                          .add(const Duration(
                                                              minutes: 3))))
                                          .then((_) => Navigator.pushNamed(
                                              context, '/'));
                                    },
                                    child: const Text("Confirmar"))
                              ],
                            )),
                    icon: const Icon(Icons.snooze),
                    label: const Text("Adiar"),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: checkedEverything()
                        ? null
                        : () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Quer mesmo pular?"),
                                    content: const Text(
                                        "Você não confirmou que tomou todos os medicamentos!"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancelar")),
                                      TextButton(
                                          onPressed: () => Alarm.stop(
                                                  widget.alarmSettings.id)
                                              .then((_) => Navigator.pushNamed(
                                                  context, '/')),
                                          child: const Text("Confirmar"))
                                    ])),
                    icon: const Icon(Icons.arrow_circle_right),
                    label: const Text("Pular"),
                  ),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      onPressed: !checkedEverything()
                          ? null
                          : () {
                              Alarm.stop(widget.alarmSettings.id)
                                  .then((_) => Navigator.pop(context));
                            },
                      icon: const Icon(Icons.check),
                      label: const Text("Confirmar")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}