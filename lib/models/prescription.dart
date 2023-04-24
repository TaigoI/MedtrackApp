import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Prescription {
  static final _prescriptionBox = Hive.box('prescription');
  static final _itemBox = Hive.box('item');

  String key;
  String patientName;
  String doctorName;
  String doctorRegistration; //ex.: 7156 CRM-AL

  Prescription({
    required this.key,
    required this.patientName,
    required this.doctorName,
    required this.doctorRegistration,
  });

  persist(){
    _prescriptionBox.put(key, toJSON());
  }

  delete(){
    _prescriptionBox.delete(key);
    _itemBox.values.where((item) => item.prescriptionKey == key).forEach((element) { element.delete(); });
  }

  factory Prescription.fromStorage(String key) {
    var prescription = _prescriptionBox.get(key);
    return prescription != null
        ? Prescription.fromJson(jsonDecode(prescription))
        : Prescription(key: UniqueKey().toString(), patientName: "Paciente não especificado", doctorName: "Médico não especificado", doctorRegistration: "");
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      key: json.containsKey('key') ? json['key'] : UniqueKey().toString(),
      patientName: json['patientName'].toString(),
      doctorName: json['doctorName'].toString(),
      doctorRegistration: json['doctorRegistration'].toString(),
    );
  }

  toJSON() {
    Map<String, dynamic> json = {
      "key": key,
      "doctorName": doctorName,
      "doctorRegistration": doctorRegistration,
      "patientName": patientName,
    };
    return jsonEncode(json);
  }

}