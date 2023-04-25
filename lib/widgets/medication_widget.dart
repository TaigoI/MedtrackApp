import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/models/alarm.dart';
import 'package:medtrack/models/prescription.dart';

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

class _MedicationWidgetState extends State<MedicationWidget> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    List<Alarme> AlarmeList = widget.model.getAlarmeList();
    var prescription = Prescription.fromStorage(widget.model.prescriptionKey);

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
                          "${widget.model.medicationDosageAmount} ${widget.model.medicationDosageUnit}",
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton(onPressed: () { widget.model.delete(); }, icon: const Icon(Icons.delete)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    "${prescription.patientName}, tomar ${widget.model.doseAmount}${widget.model.doseUnit}",
                    style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    primary: true,
                    itemCount: AlarmeList.length,
                    itemBuilder: (context, i) {
                      String chipText = DateFormat('HH:mm').format(AlarmeList[i].timestamp);
                      int dayDiff = AlarmeList[i].timestamp.difference(DateTime.now()).inDays;
                      if(dayDiff > 0){chipText+="+$dayDiff";}

                      return FilterChip(
                        avatar: Icon(AlarmeList[i].active ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                        label: Text(chipText),
                        selected: AlarmeList[i].active,
                        onSelected: (selected) {
                          setState(() {
                            AlarmeList[i].active = selected;
                            AlarmeList[i].save();
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
              ],
            )
      )
    );
  }
}




