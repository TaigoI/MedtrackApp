import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Medication {
  static final _itemBox = Hive.box('item');

  String key;
  String medicationName; //nome do remédio. "Paracetamol"
  int medicationDosageAmount; //posologia do remédio. "500"
  String medicationDosageUnit; //unidade da posologia do remédio. "MG/ML"
  int doseAmount; //quantidade do remédio que devem ser consumidas por vez. "5"
  String doseUnit; //unidade da quantidade de remédio que deve ser consumida por vez. "ML"
  int interval; //quantidade, em minutos, entre 2 doses
  int occurrences; //quantidade total de doses que o paciente irá consumir pra esta medicação
  String comments; //orientações gerais livres para o uso do medicamento a critério do médico
  DateTime initialDosage; //primeira vez que o paciente tomou o remédio
  String prescriptionKey;

  Medication({
    required this.key,
    required this.prescriptionKey,
    required this.medicationName,
    required this.medicationDosageAmount,
    required this.medicationDosageUnit,
    required this.doseAmount,
    required this.doseUnit,
    required this.interval,
    required this.occurrences,
    required this.comments,
    required this.initialDosage
  });

  persist(){
    _itemBox.put(key, toJSON());
  }

  delete(){
    _itemBox.delete(key);
  }

  factory Medication.fromStorage(String key) {
    var item = _itemBox.get(key);
    return Medication.fromJson(item!);
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
        key: json.containsKey('key') ? json['key'] : UniqueKey().toString(),
        prescriptionKey: json['prescriptionKey'].toString(),
        medicationName: json['medicationName'].toString(),
        medicationDosageAmount: int.parse(json['medicationDosageAmount'].toString()),
        medicationDosageUnit: json['medicationDosageUnit'].toString(),
        doseAmount: int.parse(json['doseAmount'].toString()),
        doseUnit: json['doseUnit'].toString(),
        interval: int.parse(json['interval'].toString()),
        occurrences: int.parse(json['occurrences'].toString()),
        comments: json['comments'].toString(),
        initialDosage: DateTime.parse(json['initialDosage'].toString())
    );
  }

  toJSON() {
    Map<String, dynamic> json = {
      'key': key,
      'prescriptionKey' : prescriptionKey,
      'medicationName': medicationName,
      'medicationDosageAmount': medicationDosageAmount,
      'medicationDosageUnit': medicationDosageUnit,
      'doseAmount': doseAmount,
      'doseUnit': doseUnit,
      'interval': interval,
      'occurrences': occurrences,
      'comments': comments,
      'initialDosage': initialDosage.toString(),
    };
    return jsonEncode(json);
  }

}
