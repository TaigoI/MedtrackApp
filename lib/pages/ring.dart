import 'package:flutter/material.dart';

import 'package:alarm/alarm.dart';

import 'package:medtrack/pages/home.dart';
import 'package:medtrack/services/alarms_service.dart';
import 'package:medtrack/components/prescription_item.dart';

class RingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  late SingleAlarm singleAlarm;

  RingScreen({super.key, required this.alarmSettings}) {
    singleAlarm = alarmsList
        .firstWhere((element) => element.alarmsIds.contains(alarmSettings.id));
  }

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen> {
  late List<bool> _checklist;
  bool showSkipAlert = false;

  @override
  void initState() {
    super.initState();
    _checklist = List.filled(widget.singleAlarm.items.length, false);
  }

  Widget medicationCheckBox(
      BuildContext context, PrescriptionItem item, int idx) {
    return CheckboxListTile(
      value: _checklist[idx],
      onChanged: (bool? value) {
        setState(() => _checklist[idx] = value!);
      },
      title: Text(
        "${item.medicationName} * ${item.doseAmount}${item.doseUnit}",
        // style: Theme.of(context).textTheme.bodyLarge
      ),
      secondary: const Icon(Icons.medication_outlined),
    );
  }

  bool checkedEverything() {
    return _checklist.every((element) => element == true);
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
                    children: [
                      Card(
                          color: Theme.of(context).colorScheme.background,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          elevation: 3,
                          child: Column(children: [
                            const Center(
                              widthFactor: 2,
                              heightFactor: 2,
                              child: Text("RECEITA DO FULANO"),
                            ),
                            Column(
                              children: widget.singleAlarm.items
                                  .asMap()
                                  .entries
                                  .map((item) => medicationCheckBox(
                                      context, item.value, item.key))
                                  .toList(),
                            )
                          ])),
                    ],
                  )),
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
