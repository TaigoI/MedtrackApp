import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medtrack/enums/dose_unit.dart';
import 'package:medtrack/enums/time_unit.dart';
import 'package:medtrack/services/alarms_service.dart';

class AlarmStamp {
  final DateTime timeStamp;
  bool active = true;

  AlarmStamp({required this.timeStamp});
  AlarmStamp.withActive({required this.timeStamp, required this.active});

  factory AlarmStamp.fromMap(Map<dynamic, dynamic> map) {
    return AlarmStamp.withActive(
      timeStamp: map.containsKey('timeStamp') ? DateTime.parse(map['timeStamp'].toString()) : DateTime.now(),
      active: map['active'] 
    );
  }

  toMap() {
    Map<String, dynamic> map = {
      'timeStamp': timeStamp.toString(),
      'active': active
    };

    return map;
  }
}

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

  List<AlarmStamp> timeStamps = [];
  
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

  Medication.withStamps({
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
    this.expectedFinalDosage,
    required this.timeStamps
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
  save(){ _box.put(key, toMap()); }
  delete() async {
    await _box.delete(key);
    await removeFromAlarmsList();
  }

  Future<void> removeFromAlarmsList() async {
    List<int> indexesToRemove = [];
    for (int i = 0; i < alarmsList.length; i++) {
      if (await alarmsList[i].removeItem(patientName, key)) {
        indexesToRemove.add(i);
      }
    }
  
    for (int idx in indexesToRemove.reversed) {
      alarmsList.removeAt(idx);
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

  
  factory Medication.fromMap(Map<dynamic, dynamic> map) {
    return Medication.withStamps(
      key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
      active:map['active'],
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
      expectedFinalDosage: map.containsKey('expectedFinalDosage') && map['expectedFinalDosage'] != 'null' ? DateTime.parse(map['expectedFinalDosage'].toString()) : null,
      timeStamps: List.from(map['timeStamps'].map((item) => AlarmStamp.fromMap(item))) 
    );
  }

  Map<String, dynamic> toMap() {
    print(List.from(timeStamps.map((item) => item.toMap())));

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
      'timeStamps': List.from(timeStamps.map((item) => item.toMap()))
    };
  }

  int getIntervalInMinutes(){
    if(intervalUnit == TimeUnitOption.week) return interval*60*24*7;
    if(intervalUnit == TimeUnitOption.day) return interval*60*24;
    if(intervalUnit == TimeUnitOption.hour) return interval*60;
    return interval;
  }

  
  Future buildAlarms() async {
    int intervalInMinutes = getIntervalInMinutes();
    expectedFinalDosage = initialDosage!.add(Duration(minutes: (occurrences-1)*intervalInMinutes));

    var stamps = await alarmFromMedication(this, intervalInMinutes);
    for (var stamp in stamps) {
      timeStamps.add(stamp);
    }
  }

  clearAlarms() async {
    await removeFromAlarmsList();
    timeStamps.clear();
    initialDosage = null;
    expectedFinalDosage = null;
    save();
  }

}