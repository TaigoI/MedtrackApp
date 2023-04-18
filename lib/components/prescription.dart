import 'package:flutter/material.dart';
import 'package:medtrack/components/prescription_item.dart';

class Prescription extends StatefulWidget {
  final String pacientName;
  final Function deleteFunction;
  final List<PrescriptionItem> items;

  const Prescription({super.key, required this.pacientName, required this.items, required this.deleteFunction});

  factory Prescription.fromJson(Function deleteFunction, Map<String, dynamic> json) {
    return Prescription(
      deleteFunction: deleteFunction,
      pacientName: json['pacientName'],
      items: (json['items'] as List)
          .map((json) => PrescriptionItem.fromJson(json))
          .toList(),
    );
  }

  toJSONEncodable() {
    Map<String, dynamic> m = {};
    m['pacientName'] = pacientName;
    m['items'] = items.map((item) {
      return item.toJSONEncodable();
    }).toList();
    return m;
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
                  widget.pacientName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(onPressed: () { widget.deleteFunction(widget.key); }, icon: const Icon(Icons.more_vert)),
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