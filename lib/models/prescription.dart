import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Prescription {
  static final _box = Hive.box('prescription');
  static final _medicationBox = Hive.box('medication');

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

  static newKey(){
    int i = 0;
    while (i < 10000){
      String key = UniqueKey().toString();
      if(!exists(key)){
        return key;
      }
      i++;
    }
  }
  static exists(String key){
    return _box.containsKey(key);
  }

  get(String key) { return Prescription.fromMap(_box.get(key)!); }
  save(){_box.put(key, toJSON());}
  delete(){
    _box.delete(key);
    _medicationBox.values.where((item) => item.prescriptionKey == key).forEach((element) { element.delete(); });
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
      patientName: map['patientName'].toString(),
      doctorName: map['doctorName'].toString(),
      doctorRegistration: map['doctorRegistration'].toString(),
    );
  }

  toJSON() {
    Map<String, dynamic> map = {
      "key": key,
      "doctorName": doctorName,
      "doctorRegistration": doctorRegistration,
      "patientName": patientName,
    };
    return jsonEncode(map);
  }

}