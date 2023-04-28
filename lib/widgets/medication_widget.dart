import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/models/prescription.dart';

import '../models/medication.dart';
import 'package:medtrack/services/alarms_service.dart';


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
  List<int> llista = [1, 2, 3, 4, 5, 6, 7];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
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
                    itemCount: widget.model.timeStamps.length,
                    itemBuilder: (context, i) {
                      String chipText = DateFormat('HH:mm').format(widget.model.timeStamps[i].timeStamp);
                      int dayDiff = widget.model.timeStamps[i].timeStamp.difference(DateTime.now()).inDays;
                      if(dayDiff > 0){chipText+="+$dayDiff";}

                      return FilterChip(
                        avatar: Icon(widget.model.timeStamps[i].active ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                        label: Text(chipText),
                        selected: widget.model.timeStamps[i].active,
                        onSelected: (selected) async {
                          setState(() {
                            widget.model.timeStamps[i].active = selected;
                            
                            String patientName = Prescription.fromStorage(widget.model.prescriptionKey).patientName;
                            
                            if (!widget.model.timeStamps[i].active) {
                              setItemInactive(
                                widget.model.timeStamps[i].timeStamp, 
                                patientName, 
                                widget.model.key
                              );
                            }
                            else {
                              setItemActive(
                                widget.model.timeStamps[i].timeStamp, 
                                patientName, 
                                widget.model.key);
                            }
                          });
                          await widget.model.save();
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




