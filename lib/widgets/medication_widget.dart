import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/enums/dose_unit.dart';
import 'package:medtrack/enums/plural.dart';
import 'package:medtrack/enums/time_unit.dart';
import 'package:medtrack/models/alarm.dart';
import 'package:medtrack/pages/medication_page.dart';

import '../models/medication.dart';


class MedicationWidget extends StatefulWidget {

  final Medication model;
  const MedicationWidget({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _MedicationWidgetState();

  factory MedicationWidget.fromMap(Map<String, dynamic> map){
    bool hasKey = !map.containsKey('key');
    if(hasKey) { map['key'] = UniqueKey().toString(); }

    var model = Medication.fromMap(map);
    if(hasKey) { model.save(); }

    return MedicationWidget(
        key: ValueKey(map['key']),
        model: model,
    );
  }

}

enum MedicationWidgetMenuOption { edit, delete, share }

class _MedicationWidgetState extends State<MedicationWidget> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    List<Alarm> alarmList = widget.model.getAlarmList();

    return Card(
      child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 4),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        switch(item){
                          case MedicationWidgetMenuOption.edit:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MedicationPage(medication: widget.model, isNew: false,)),
                            );
                            break;
                          case MedicationWidgetMenuOption.delete:
                            widget.model.delete();
                            break;
                          case MedicationWidgetMenuOption.share:
                            // TODO: Handle this case.
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<MedicationWidgetMenuOption>>[
                        //TODO: allow share
                        /*const PopupMenuItem<MedicationWidgetMenuOption>(
                          value: MedicationWidgetMenuOption.share,
                          child: Text('Exportar'),
                        ),*/
                        const PopupMenuItem<MedicationWidgetMenuOption>(
                          value: MedicationWidgetMenuOption.edit,
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem<MedicationWidgetMenuOption>(
                          value: MedicationWidgetMenuOption.delete,
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    "${widget.model.patientName}, tomar ${widget.model.doseAmount} ${DoseUnitController.asText(PluralController.fromAmount(widget.model.doseAmount), widget.model.doseUnit)} a cada ${widget.model.interval} ${TimeUnitController.asText(PluralController.fromAmount(widget.model.interval), widget.model.intervalUnit)}",
                    style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    primary: true,
                    itemCount: alarmList.length,
                    itemBuilder: (context, i) {
                      String chipText = DateFormat('HH:mm').format(alarmList[i].timestamp);
                      int dayDiff = alarmList[i].timestamp.difference(DateTime.now()).inDays;
                      if(dayDiff > 0){chipText+="+$dayDiff";}

                      return FilterChip(
                        avatar: Icon(alarmList[i].active ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                        label: Text(chipText),
                        selected: alarmList[i].active,
                        onSelected: (selected) {
                          setState(() {
                            alarmList[i].active = selected;
                            alarmList[i].save();
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
                ),

                widget.model.comments == "" ? Container() : const SizedBox(height: 8),
                widget.model.comments == "" ? Container() : Text(widget.model.comments, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
      )
    );
  }
}


/*



*/