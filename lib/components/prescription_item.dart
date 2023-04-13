import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/enums/dosage_unit.dart';

class PrescriptionItem extends StatefulWidget {
  String medicationName;
  String doseAmount;
  String doseUnit;
  String dosage;
  String dosageUnit;
  String frequency;
  String duration;

  PrescriptionItem(
      {super.key, required this.medicationName, required this.doseAmount, required this.doseUnit,
      required this.dosage, required this.dosageUnit, required this.frequency, required this.duration});

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    var prescriptionItem = PrescriptionItem(
      medicationName: json['medicationName'].toString(),
      doseAmount: json['doseAmount'].toString(),
      doseUnit: json['doseUnit'].toString(),
      dosage: json['dosage'].toString(),
      dosageUnit: json['dosageUnit'].toString(),
      frequency: json['frequency'].toString(),
      duration: json['duration'].toString(),
    );
    return prescriptionItem;
  }

  toJSONEncodable() {
    Map<String, dynamic> json = {
      'medicationName': medicationName,
      'doseAmount': doseAmount,
      'doseUnit': doseUnit,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'frequency': frequency,
      'duration': duration,
    };
    return json;
  }

  @override
  State<StatefulWidget> createState() => _PrescriptionState();
}

//              PrescriptionChip(icon: Icons.update, text: "${widget.frequency}h"),
class _PrescriptionState extends State<PrescriptionItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("${widget.medicationName} • ${widget.doseAmount} ${widget.doseUnit}",
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
              PrescriptionChip(
                  icon: Icons.calendar_today, text: "Por ${widget.duration} dias"),
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
