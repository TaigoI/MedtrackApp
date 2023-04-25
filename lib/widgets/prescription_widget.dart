import 'package:flutter/material.dart';
import '../models/prescription.dart';


class PrescriptionWidget extends StatefulWidget {
  final Prescription model;

  const PrescriptionWidget({super.key, required this.model});

  factory PrescriptionWidget.fromJson(Map<String, dynamic> json){
    if(!json.containsKey('key')) {
      json['key'] = UniqueKey().toString();
    }

    return PrescriptionWidget(
      key: ValueKey(json['key']),
      model: Prescription.fromJson(json),
    );
  }

  @override
  State<PrescriptionWidget> createState() => _PrescriptionWidgetState();
}

class _PrescriptionWidgetState extends State<PrescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin:
                const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 4),
            child: Row(
              children: <Widget>[
                Text(
                  widget.model.patientName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(onPressed: () { widget.model.delete(); }, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          /*Container(
              margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
              child: Column(children: widget.items)),*/
        ],
      ),
    );
  }
}