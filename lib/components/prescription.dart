import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/components/prescription_item.dart';

class Prescription extends StatefulWidget {
  String title;
  List<PrescriptionItem> items;

  Prescription({super.key, required this.title, required this.items});

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      title: json['title'],
      items: (json['items'] as List)
          .map((json) => PrescriptionItem.fromJson(json))
          .toList(),
    );
  }

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
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
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(onPressed: () { }, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
              child: Column(children: widget.items)),
        ],
      ),
    );
  }
}
