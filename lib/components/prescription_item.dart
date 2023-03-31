import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/enums/dosage_unit.dart';

class PrescriptionItem extends StatefulWidget {
  String medicine;
  String dose;
  String dosage;
  String dosageUnit;
  String time;
  String date;

  PrescriptionItem(
      {super.key,
      required this.medicine,
      required this.dose,
      required this.dosage,
      required this.dosageUnit,
      required this.time,
      required this.date});

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    String medicine = json['medicationName'].toString();
    String dose = "${json['doseAmount']} ${json['doseUnit']}";
    String dosage = json['dosage'].toString();
    String dosageUnit = json['presentationType'].toString();
    String time = json['frequency'].toString();
    String date = json['duration'].toString();

    var prescriptionItem = PrescriptionItem(
      medicine: medicine,
      dose: dose,
      dosage: dosage,
      dosageUnit: dosageUnit,
      time: time,
      date: date,
    );
    return prescriptionItem;
  }

  @override
  State<StatefulWidget> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<PrescriptionItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("${widget.medicine} • ${widget.dose}",
                style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        SizedBox(
          height: 40,
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              PrescriptionChip(
                  icon: Icons.medication,
                  text: "x${widget.dosage}"),
              PrescriptionChip(icon: Icons.update, text: "${widget.time}h"),
              PrescriptionChip(
                  icon: Icons.calendar_today, text: "Por ${widget.date} dias"),
            ],
          ),
        )
      ],
    );
  }
}

class PrescriptionChip extends StatefulWidget {
  final IconData icon;
  final String text;

  const PrescriptionChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  State<StatefulWidget> createState() => _PrescriptionChipState();
}

class _PrescriptionChipState extends State<PrescriptionChip> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 6,
        child: Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 16.0, top: 6.0, bottom: 6.0),
            child: Row(
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: 18,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(widget.text,
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            )));
  }
}
