import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/models/alarm.dart';


class Medication {
  static final _box = Hive.box('medication');
  static final _alarmBox = Hive.box('alarm');

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

  get(String key) { return Medication.fromMap(_box.get(key)!); }
  save(){ _box.put(key, toMap()); }
  delete(){
    _box.delete(key);
    for (var alarm in getAlarmList()) {
      alarm.delete();
    }
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
        key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
        prescriptionKey: map['prescriptionKey'].toString(),
        medicationName: map['medicationName'].toString(),
        medicationDosageAmount: int.parse(map['medicationDosageAmount'].toString()),
        medicationDosageUnit: map['medicationDosageUnit'].toString(),
        doseAmount: int.parse(map['doseAmount'].toString()),
        doseUnit: map['doseUnit'].toString(),
        interval: int.parse(map['interval'].toString()),
        occurrences: int.parse(map['occurrences'].toString()),
        comments: map['comments'].toString(),
        initialDosage: map.containsKey('initialDosage') ? DateTime.parse(map['initialDosage'].toString()) : DateTime.now()
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
  }

  //can be optimized with a 'medicationToAlarms' box like Box<MedicationKey, List<AlarmKey>>
  List<Alarm> getAlarmList() {
    List<Alarm> alarmList = [];
    _alarmBox.values.where((map) => map['medicationKey'] == key).forEach((map) { alarmList.add(Alarm.fromMap(map.cast<String, dynamic>())); });
    alarmList.sort(compareAlarms);
    return alarmList;
  }

  updateAlarms(){
    for(int i = 0; i < occurrences; i++){
      var alarm = Alarm(
        key: UniqueKey().toString(),
        medicationKey: key,
        active: true,
        timestamp: initialDosage.add(Duration(minutes: i*interval)),
      );
      alarm.save();
    }
  }

  int compareAlarms(Alarm a, Alarm b){
    if((!a.active && !b.active) || (a.active && b.active)){
      return a.timestamp.compareTo(b.timestamp);
    } else {
      if(a.active){
        return -1;
      } else {
        return 1;
      }
    }
  }

}