import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/enums/dose_unit.dart';
import 'package:medtrack/enums/time_unit.dart';
import 'package:medtrack/models/alarm.dart';


class Medication {
  static final _box = Hive.box('medication');
  static final _alarmBox = Hive.box('alarm');

  String key;
  bool active;

  String patientName;

  String doctorName;
  String doctorRegistration;

  String medicationName; //nome do remédio. "Paracetamol"
  String medicationDosage; //posologia do remédio. "500 MG/ML"

  int doseAmount; //quantidade do remédio que devem ser consumidas por vez. "5"
  DoseUnitOption doseUnit; //unidade da quantidade de remédio que deve ser consumida por vez. "ML"

  int interval;
  TimeUnitOption intervalUnit; //quantidade, em minutos, entre 2 doses

  int occurrences; //quantidade total de doses que o paciente irá consumir pra esta medicação
  String comments; //orientações gerais livres para o uso do medicamento a critério do médico

  DateTime? initialDosage; //primeira vez que o paciente tomou o remédio
  DateTime? expectedFinalDosage;

  Medication({
    required this.key,
    required this.active,
    required this.patientName,
    required this.doctorName,
    required this.doctorRegistration,
    required this.medicationName,
    required this.medicationDosage,
    required this.doseAmount,
    required this.doseUnit,
    required this.interval,
    required this.intervalUnit,
    required this.occurrences,
    required this.comments,
    this.initialDosage,
    this.expectedFinalDosage
  });

  static newKey(){
    int i = 0;
    while (i < 10000){
      String key = UniqueKey().toString();
      if(!_box.containsKey(key)){
        return key;
      }
      i++;
    }
  }

  get(String key) { return Medication.fromMap(_box.get(key)!); }
  save(){
    _box.put(key, toMap());
    print(_box.values);
  }
  delete(){
    _box.delete(key);
    for (var alarm in getAlarmList()) {
      alarm.delete();
    }
  }

  factory Medication.empty() {
    return Medication(
        key: UniqueKey().toString(),
        active: true,
        patientName: "",
        doctorName: "",
        doctorRegistration: "",
        medicationName: "",
        medicationDosage: "",
        doseAmount: 1,
        doseUnit: DoseUnitOption.pill,
        interval: 1,
        intervalUnit: TimeUnitOption.minute,
        occurrences: 1,
        comments: "",
        initialDosage: null,
        expectedFinalDosage: null
    );
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
        key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
        active: bool.parse(map['active'].toString()),
        patientName: map['patientName'].toString(),
        doctorName: map['doctorName'].toString(),
        doctorRegistration: map['doctorRegistration'].toString(),
        medicationName: map['medicationName'].toString(),
        medicationDosage: map['medicationDosage'].toString(),
        doseAmount: int.parse(map['doseAmount'].toString()),
        doseUnit: DoseUnitOption.values.byName(map['doseUnit'].toString().split('.')[1]),
        interval: int.parse(map['interval'].toString()),
        intervalUnit: TimeUnitOption.values.byName(map['intervalUnit'].toString().split('.')[1]),
        occurrences: int.parse(map['occurrences'].toString()),
        comments: map['comments'].toString(),
        initialDosage: map.containsKey('initialDosage') && map['initialDosage'] != 'null' ? DateTime.parse(map['initialDosage'].toString()) : null,
        expectedFinalDosage: map.containsKey('expectedFinalDosage') && map['expectedFinalDosage'] != 'null' ? DateTime.parse(map['expectedFinalDosage'].toString()) : null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'active': active,
      'patientName': patientName,
      'doctorName': doctorName,
      'doctorRegistration': doctorRegistration,
      'medicationName': medicationName,
      'medicationDosage': medicationDosage,
      'doseAmount': doseAmount,
      'doseUnit': doseUnit.toString(),
      'interval': interval,
      'intervalUnit': intervalUnit.toString(),
      'occurrences': occurrences,
      'comments': comments,
      'initialDosage': initialDosage.toString(),
      'expectedFinalDosage': expectedFinalDosage.toString(),
    };
  }

  //TODO: Can be optimized with a 'medicationToAlarms' Box<MedicationKey, List<AlarmKey>>
  List<Alarm> getAlarmList() {
    List<Alarm> alarmList = [];
    _alarmBox.values.where((map) => map['medicationKey'] == key).forEach((map) {
      var alarm = Alarm.fromMap(map.cast<String, dynamic>());
      if(alarm.timestamp.difference(DateTime.now()).inMinutes > 0){
        alarmList.add(alarm);
      }
    });
    alarmList.sort(compareAlarms);
    return alarmList;
  }

  buildAlarms(){
    for(int i = 0; i < occurrences; i++){
      var alarm = Alarm(
        key: UniqueKey().toString(),
        medicationKey: key,
        active: true,
        timestamp: initialDosage!.add(Duration(minutes: i*interval)),
      );
      alarm.save();
    }
  }

  int compareAlarms(Alarm a, Alarm b){
    return a.timestamp.compareTo(b.timestamp);

    //TODO: ask about 'active' aware sorting
    /*if((!a.active && !b.active) || (a.active && b.active)){
      return a.timestamp.compareTo(b.timestamp);
    } else {
      if(a.active){
        return -1;
      } else {
        return 1;
      }
    }*/
  }

}
