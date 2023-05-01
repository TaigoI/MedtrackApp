
/*

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
                    IconButton(onPressed: () { widget.model.delete(); }, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () { widget.model.delete(); }, icon: const Icon(Icons.delete)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    "${prescription.patientName}, tomar ${widget.model.doseAmount}${widget.model.doseUnit}",
                    style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 8),
                widget.model.comments == "" ? Container() : const SizedBox(height: 8),
                widget.model.comments == "" ? Container() : Text(widget.model.comments, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
      )
    );
  }
}






*/