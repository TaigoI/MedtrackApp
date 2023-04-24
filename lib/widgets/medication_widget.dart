import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/models/prescription.dart';

import '../models/medication.dart';


class MedicationWidget extends StatefulWidget {

  final Medication model;
  const MedicationWidget({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _MedicationWidgetState();

  factory MedicationWidget.fromJson(Map<String, dynamic> json){
    if(!json.containsKey('key')) {
      json['key'] = UniqueKey().toString();
    }

    return MedicationWidget(
        key: ValueKey(json['key']),
        model: Medication.fromJson(json),
    );
  }

}

class _MedicationWidgetState extends State<MedicationWidget> {
  bool edit = false;
  bool a1 = true;
  bool a2 = true;
  bool a3 = true;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilterChip(
                      avatar: Icon(a1 ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                      label: const Text('08:00'),
                      selected: a1,
                      onSelected: (selected) {
                        setState(() {
                          a1 = !a1;
                        });
                      },
                      showCheckmark: false,
                      elevation: 2,
                    ),
                    SizedBox(width: 4),
                    FilterChip(
                      avatar: Icon(a2 ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                      label: const Text('20:00'),
                      selected: a2,
                      onSelected: (selected) {
                        setState(() {
                          a2 = !a2;
                        });
                      },
                      showCheckmark: false,
                      elevation: 2,
                    ),
                    SizedBox(width: 4),
                    FilterChip(
                      avatar: Icon(a3 ? Icons.access_time_filled_rounded : Icons.access_time_rounded, color: colors.onSurface,),
                      label: const Text('08:00+1'),
                      selected: a3,
                      onSelected: (selected) {
                        setState(() {
                          a3 = !a3;
                        });
                      },
                      showCheckmark: false,
                      elevation: 2,
                    ),
                  ],
                )
              ],
            )
      )
    );
  }
}
