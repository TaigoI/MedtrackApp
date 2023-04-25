import 'package:flutter/foundation.dart';
import 'package:medtrack/models/medication.dart';
import 'package:medtrack/models/prescription.dart';
import 'package:alarm/alarm.dart';
import 'package:hive/hive.dart';

class AlarmItem {
  final String medicationKey;
  bool active = true;

  AlarmItem({required this.medicationKey});
  AlarmItem.withActive({required this.medicationKey, required this.active});

  void setActive(bool active) {
    active = active;
  }

  bool isActive() {
    return active;
  }

  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem.withActive(
        medicationKey: map['medicationKey'],
        active: map['active'] == 'true' ? true : false  
      );

  }

  Map<String, dynamic> toMap(){
    return {
      'medicationKey': medicationKey,
      'active': active
    };
  }

  @override
  String toString() {
    return "key: $medicationKey, active: $active";
  }
}

Map<String, dynamic> itemsFromMap(Map<String, dynamic> map) {
    Map<String, dynamic> itemsMap = map.map(
      (k, v) => MapEntry(k, v.map((e) => AlarmItem.fromMap(e)))
    );

    return itemsMap;
  }

class AppAlarm {
  static final _alarmBox = Hive.box('alarms');

  String key;
  DateTime timeStamp; // horário em que o alarme soará
  late Map<String, dynamic> items; // itens a serem tomados neste horário
  String audioPath; // vem das configurações

  late int alarmId; //id para pegar do plugin

  AppAlarm(
      {required this.key,
      required this.timeStamp,
      required this.audioPath,
      required String medicationKey,
      required String patientName}) {
    items = {};
    items[patientName] = [AlarmItem(medicationKey: medicationKey)];
    print(items[patientName]);
    setAlarm();
  }

  get(String key) {
    return AppAlarm.fromMap(_alarmBox.get(key)!);
  }

  save() async {
    await _alarmBox.put(key, toMap());
  }

  AppAlarm.withItems(
      {required this.key,
      required this.timeStamp,
      required this.items,
      required this.audioPath,
      required this.alarmId}) {
    setAlarmIfAlreadyNot(alarmId);
  }

  factory AppAlarm.fromMap(Map<String, dynamic> map) {
    return AppAlarm.withItems(
        key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
        timeStamp: DateTime.parse(map['timeStamp'].toString()),
        items: itemsFromMap(map['items']),
        audioPath: map['audioPath'],
        alarmId: map['alarmId']);
  }  

  toMap() {
    Map<String, dynamic> map = {
      'key': key,
      'timeStamp': timeStamp,
      'items':
          items.map((patientName, itemsList) => 
            MapEntry(patientName, itemsList.map((item) => item.toMap()))),
      'audioPath': audioPath,
      'alarmId': alarmId
    };
    return map;
  }

  void addItem(String medicationKey, String patientName) {
    if (items.containsKey(patientName)) {
      items[patientName]!.add(AlarmItem(medicationKey: medicationKey));
    } else {
      items[patientName] = [AlarmItem(medicationKey: medicationKey)
      ];
    }
    save();
  }

  Future<void> setAlarm() async {
    int id = DateTime.now().millisecondsSinceEpoch % 1000;
    alarmId = id;

    final alarmSettings = AlarmSettings(
        id: id,
        dateTime: timeStamp,
        assetAudioPath: audioPath,
        vibrate: true,
        loopAudio: false,
        notificationTitle: "Hora dos Remédios",
        notificationBody: "Abra o app para confirmar que tomou");

    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> setAlarmIfAlreadyNot(int id) async {
    if (!Alarm.getAlarms().any((alarm) => alarm.id == id)) {
      await Alarm.set(
          alarmSettings: AlarmSettings(
              id: id,
              dateTime: timeStamp,
              assetAudioPath: audioPath,
              vibrate: true,
              loopAudio: false,
              notificationTitle: "Hora dos Remédios",
              notificationBody: "Abra o app para confirmar que tomou"));
    }
  }

  bool shouldRing() {
    bool flag = true;
    items.forEach((key, value) {
      flag = true;
      if (value.every((val) => val.isActive() == false)) {
        flag = false;
      }
    });
    return flag;
  }

}

void alarmFromMedication(List<AppAlarm> alarms, Medication medication) async {
  String patientName =
      Prescription.fromStorage(medication.prescriptionKey).patientName;

  DateTime endDate = medication.initialDosage
      .add(Duration(minutes: (medication.occurrences * medication.interval)));

  print("endDate: [$endDate]");

  DateTime currentStamp = medication.initialDosage;
  bool timeStampTaken;

  // while (currentStamp.isBefore(endDate)) {
  for (int i = 0; i < 1; i++) {
    timeStampTaken = false;

    for (AppAlarm alarm in alarms) {
      if (alarm.timeStamp.compareTo(currentStamp) == 0) {
        alarm.addItem(medication.key, patientName);
        timeStampTaken = true;
        break;
      }
    }

    if (!timeStampTaken) {
      alarms.add(AppAlarm(
          key: UniqueKey().toString(),
          audioPath: 'sounds/mozart.mp3',
          timeStamp: currentStamp,
          medicationKey: medication.key,
          patientName: patientName));
    }

    currentStamp = currentStamp.add(Duration(minutes: medication.interval));
  }

  print('\n\n');
  printAlarms();
}

void stopAllAlarms() async {
  for (AlarmSettings alarm in Alarm.getAlarms()) {
    await Alarm.stop(alarm.id);
  }
}

void printAlarms() {
  for (AlarmSettings alarm in Alarm.getAlarms()) {
    print("alarme ${alarm.id}: [${alarm.dateTime}]");
  }
}
