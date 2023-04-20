import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class PrescriptionItemModel {
  static final _items = Hive.box('items');

  String key;
  String medicationName; //nome do remédio. "Paracetamol"
  String doseAmount; //posologia do remédio. "500"
  String doseUnit; //unidade da posologia do remédio. "MG/ML"
  int dosageAmount; //quantidade do remédio que devem ser consumidas por vez. "5"
  String dosageUnit; //unidade da quantidade de remédio que deve ser consumida por vez. "ML"
  int interval; //quantidade, em minutos, entre 2 doses
  int occurrences; //quantidade total de doses que o paciente irá consumir pra esta medicação
  String comments; //orientações gerais livres para o uso do medicamento a critério do médico
  DateTime initialDosage; //primeira vez que o paciente tomou o remédio
  String patientName;

  PrescriptionItemModel({
    required this.key,
    required this.patientName,
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.dosageAmount,
    required this.dosageUnit,
    required this.interval,
    required this.occurrences,
    required this.comments,
    required this.initialDosage
  });

  persist(){
    _items.put(key, toJSON());
  }

  delete(){
    _items.delete(key);
  }

  factory PrescriptionItemModel.fromStorage(String key) {
    var item = _items.get(key);
    return PrescriptionItemModel.fromJson(item!);
  }

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    var prescriptionItem = PrescriptionItemModel(
        key: json.containsKey('key') ? json['key'] : UniqueKey().toString(),
        patientName: json['patientName'].toString(),
        medicationName: json['medicationName'].toString(),
        doseAmount: json['doseAmount'].toString(),
        doseUnit: json['doseUnit'].toString(),
        dosageAmount: int.parse(json['dosageAmount'].toString()),
        dosageUnit: json['dosageUnit'].toString(),
        interval: int.parse(json['interval'].toString()),
        occurrences: int.parse(json['occurrences'].toString()),
        comments: json['comments'].toString(),
        initialDosage: DateTime.parse(json['initialDosage'].toString())
    );
    return prescriptionItem;
  }

  toJSON() {
    Map<String, dynamic> json = {
      'key': key,
      'patientName' : patientName,
      'medicationName': medicationName,
      'doseAmount': doseAmount,
      'doseUnit': doseUnit,
      'dosageAmount': dosageAmount,
      'dosageUnit': dosageUnit,
      'interval': interval,
      'occurrences': occurrences,
      'comments': comments,
      'initialDosage': initialDosage.toString(),
    };
    return jsonEncode(json);
  }

}

class PrescriptionItem extends StatefulWidget {

  final PrescriptionItemModel model;
  const PrescriptionItem({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _PrescriptionItemState();

  factory PrescriptionItem.fromJson(Map<String, dynamic> json){
    if(!json.containsKey('key')) {
      json['key'] = UniqueKey().toString();
    }

    return PrescriptionItem(
        key: ValueKey(json['key']),
        model: PrescriptionItemModel.fromJson(json),
    );
  }

}

class _PrescriptionItemState extends State<PrescriptionItem> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 4,
      child: Column(
          children: [
            Container(
              margin:
              const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 4),
              child: Row(
                children: <Widget>[
                  Text(
                    "${widget.model.medicationName} - ${widget.model.dosageAmount} ${widget.model.dosageUnit}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(onPressed: () { widget.model.delete(); }, icon: const Icon(Icons.delete)),
                ],
              ),
            ),
            Text(
                widget.model.patientName,
                style: Theme.of(context).textTheme.bodyMedium
            ),
            Text(
                "Tomar ${widget.model.doseAmount} ${widget.model.doseUnit}",
                style: Theme.of(context).textTheme.bodyMedium
            ),
            const SizedBox(height: 3),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(label: Text("00:00"), deleteIcon: Icon(Icons.close),),
                SizedBox(width: 4),
                Chip(label: Text("00:00+1"), deleteIcon: Icon(Icons.close),),
                SizedBox(width: 4),
                Chip(label: Text("00:00+2"), deleteIcon: Icon(Icons.close),),
              ],
            )
          ],
        )
    );
  }
}
