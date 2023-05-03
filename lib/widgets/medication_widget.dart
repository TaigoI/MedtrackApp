import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/enums/dose_unit.dart';
import 'package:medtrack/enums/plural.dart';
import 'package:medtrack/enums/time_unit.dart';
import 'package:medtrack/pages/medication_page.dart';

import '../models/medication.dart';
import 'package:medtrack/services/alarms_service.dart';

class MedicationWidget extends StatefulWidget {
  final Medication model;

  const MedicationWidget({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _MedicationWidgetState();

  factory MedicationWidget.fromMap(Map<String, dynamic> map) {
    bool hasKey = !map.containsKey('key');
    if (hasKey) {
      map['key'] = UniqueKey().toString();
    }

    var model = Medication.fromMap(map);
    if (hasKey) {
      model.save();
    }

    return MedicationWidget(
      key: ValueKey(map['key']),
      model: model,
    );
  }
}

enum MedicationWidgetMenuOption { edit, delete, resetAlarms, share }

class _MedicationWidgetState extends State<MedicationWidget> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 4),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.medicationName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    widget.model.medicationDosage,
                    style: Theme.of(context).textTheme.labelSmall,
                  )
                ],
              ),
              const Spacer(),
              PopupMenuButton<MedicationWidgetMenuOption>(
                onSelected: (MedicationWidgetMenuOption item) {
                  switch (item) {
                    case MedicationWidgetMenuOption.edit:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicationPage(
                              medication: widget.model,
                              isNew: false,
                            )),
                      );
                      break;
                    case MedicationWidgetMenuOption.delete:
                      widget.model.delete();
                      break;
                    case MedicationWidgetMenuOption.share:
                      // TODO: Handle this case.
                      break;
                    case MedicationWidgetMenuOption.resetAlarms:
                      widget.model.clearAlarms();
                      initialDosagePicker(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => getMenuList(context)
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${widget.model.patientName}, ${widget.model.doseAmount} ${DoseUnitController.asText(PluralController.fromAmount(widget.model.doseAmount), widget.model.doseUnit)} a cada ${widget.model.interval} ${TimeUnitController.asText(PluralController.fromAmount(widget.model.interval), widget.model.intervalUnit)}",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              widget.model.initialDosage != null
                  ? SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  primary: true,
                  itemCount: widget.model.timeStamps.length,
                  itemBuilder: (context, i) {
                    String chipText = 
                    DateFormat('HH:mm').format(widget.model.timeStamps[i].timeStamp);
                    
                    int dayDiff = widget.model.timeStamps[i]
                        .timeStamp
                        .difference(DateTime.now())
                        .inDays;
                    if (dayDiff > 0) {
                      chipText += "+$dayDiff";
                    }

                    return FilterChip(
                      avatar: Icon(
                        widget.model.timeStamps[i].active
                            ? Icons.access_time_filled_rounded
                            : Icons.access_time_rounded,
                        color: colors.onSurface,
                      ),
                      label: Text(chipText),
                      selected: widget.model.timeStamps[i].active,
                      onSelected: (selected) {
                        setState(() async {
                            widget.model.timeStamps[i].active = selected;
                                                        
                            if (!widget.model.timeStamps[i].active) {
                              setItemInactive(
                                widget.model.timeStamps[i].timeStamp, 
                                widget.model.patientName, 
                                widget.model.key
                              );
                            }
                            else {
                              setItemActive(
                                widget.model.timeStamps[i].timeStamp, 
                                widget.model.patientName, 
                                widget.model.key);
                            }
                          });
                      },
                      showCheckmark: false,
                      elevation: 2,
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(width: 4);
                  },
                ),
              )
                  : SizedBox(
                height: 36,
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                              ),
                              minimumSize: const Size(
                                  double.infinity,
                                  double
                                      .infinity) // put the width and height you want
                          ),
                          onPressed: () {initialDosagePicker(context);},
                          child: const Text('Iniciar Medicação'),
                        )),
                  ],
                ),
              ),
              widget.model.comments == "" ? Container() : const SizedBox(height: 8),
              widget.model.comments == ""
                  ? Container()
                  : Text(widget.model.comments,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          )
        )
      ],
    ));
  }

  List<PopupMenuEntry<MedicationWidgetMenuOption>> getMenuList(context){
    List<PopupMenuEntry<MedicationWidgetMenuOption>> list = [
      const PopupMenuItem<MedicationWidgetMenuOption>(
        value: MedicationWidgetMenuOption.edit,
        child: Text('Editar'),
      ),
      const PopupMenuItem<MedicationWidgetMenuOption>(
        value: MedicationWidgetMenuOption.delete,
        child: Text('Excluir'),
      ),
    ];

    if (widget.model.initialDosage != null){
      list.add(
        const PopupMenuItem<MedicationWidgetMenuOption>(
          value: MedicationWidgetMenuOption.resetAlarms,
          child: Text('Redefinir alarmes'),
        ),
      );
    }

    return list;
  }


  Future initialDosagePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      var now = TimeOfDay.now();
      bool nextDay = (time.hour < now.hour || time.hour == now.hour && time.minute < now.minute);
      var nowDate = DateTime.now();
      setState(() async {
        widget.model.initialDosage = DateTime(nowDate.year, nowDate.month, nowDate.day, time.hour, time.minute);
        if (nextDay) widget.model.initialDosage?.add(const Duration(days: 1));
        await widget.model.buildAlarms();
        widget.model.save();
      });
    }
  }
}
