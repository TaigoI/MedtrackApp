import 'package:flutter/foundation.dart';
import 'package:medtrack/models/medication.dart';
import 'package:medtrack/models/prescription.dart';
import 'package:alarm/alarm.dart';
import 'package:hive/hive.dart';
import 'package:medtrack/main.dart';

List<AppAlarm> alarmsList = [];

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

  String getKey() {
    return medicationKey;
  }

  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem.withActive(
        medicationKey: map['medicationKey'],
        active: map['active'] 
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'medicationKey': medicationKey, 'active': active};
    return map;
  }

  @override
  String toString() {
    return "key: $medicationKey, active: $active";
  }
}

final _alarmBox = Hive.box('alarm');

class AppAlarm {
  String key;
  DateTime timeStamp; // horário em que o alarme soará
  late Map<String, dynamic> items; // itens a serem tomados neste horário
  String audioPath; // vem das configurações

  late int alarmId; //id para pegar do plugin
  bool active = true;

  AppAlarm(
      {required this.key,
      required this.timeStamp,
      required this.audioPath,
      required String medicationKey,
      required String patientName}) {
    items = {};
    items[patientName] = [AlarmItem(medicationKey: medicationKey)];
    setAlarm();
  }

  get(String key) {
    return AppAlarm.fromMap(_alarmBox.get(key)!);
  }

  Future<void> save() async {
    await _alarmBox.put(key, toMap());
  }

  AppAlarm.withItems(
      {required this.key,
      required this.timeStamp,
      required this.items,
      required this.audioPath,
      required this.alarmId,
      required this.active}) {
    setAlarmIfAlreadyNot(alarmId);
  }

  factory AppAlarm.fromMap(Map<String, dynamic> map) {
    return AppAlarm.withItems(
        key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
        timeStamp: DateTime.parse(map['timeStamp'].toString()),
        items: Map<String, dynamic>.from(
          (map['items'] as Map).map((name, list) => MapEntry(name,
          list.map((i) => AlarmItem.fromMap(Map<String, dynamic>.from(i as Map)))))
        ), // vsf
        audioPath: map['audioPath'],
        alarmId: map['alarmId'],
        active: map['active'] == 'true' ? true : false
      );
  }

  toMap() {
    Map<String, dynamic> map = {
      'key': key,
      'timeStamp': timeStamp,
      'items': items.map((patientName, list) =>
          MapEntry(patientName, List.from(list.map((item) => item.toMap())))),
      'audioPath': audioPath,
      'alarmId': alarmId,
      'active': active
    };
    return map;
  }

  void addItem(String medicationKey, String patientName) async {
    if (items.containsKey(patientName)) {
      print(items[patientName].runtimeType);
      items[patientName].add(AlarmItem(medicationKey: medicationKey));
    } else {
      items[patientName] = [AlarmItem(medicationKey: medicationKey)];
    }
    await save();
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
    await save();
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
      if (value.every((val) => val.isActive() == false)) {
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> removeItem(String patientName, String medicationKey) async {
    items.removeWhere((key, value) => key == patientName && value.any((e) => e.getKey() == medicationKey));

    if (items.isEmpty) {
      await Alarm.stop(alarmId);
      await _alarmBox.delete(key);
      active = false;
      return true; //remove it from list
    }

    return false; // do not remove it from list
  }

  Future<void> setItemInactive(String patientName, String medicationKey) async {
    items[patientName].firstWhere((element) => element.medicationKey == medicationKey).setActive(false);

    if (!shouldRing()) {
      active = false;
      await Alarm.stop(alarmId); 
    }
    await save();
  }

  void setItemActive(String patientName, String medicationKey) async {
    items[patientName].firstWhere((element) => element.medicationKey == medicationKey).setActive(true);
    
    if (!active) {
      active = true;
      await setAlarmIfAlreadyNot(alarmId); 
    }
    await save();
  }
}

Future<List<AlarmStamp>> alarmFromMedication(Medication medication) async {
  String patientName =
      Prescription.fromStorage(medication.prescriptionKey).patientName;

  DateTime endDate = medication.initialDosage
      .add(Duration(minutes: (medication.occurrences * medication.interval)));


  DateTime currentStamp = medication.initialDosage;
  bool timeStampTaken;

  List<AlarmStamp> times = [];

  while (currentStamp.isBefore(endDate)) {
    // for (int i = 0; i < 1; i++) {
    times.add(AlarmStamp(timeStamp: currentStamp));
    timeStampTaken = false;

    for (AppAlarm alarm in alarmsList) {
      if (alarm.timeStamp.compareTo(currentStamp) == 0) {
        alarm.addItem(medication.key, patientName);
        timeStampTaken = true;
        break;
      }
    }

    if (!timeStampTaken) {
      alarmsList.add(await AppAlarm(
          key: UniqueKey().toString(),
          audioPath: 'sounds/mozart.mp3',
          timeStamp: currentStamp,
          medicationKey: medication.key,
          patientName: patientName));
    }

    currentStamp = currentStamp.add(Duration(minutes: medication.interval));
  }

  print('\n\nAlarmes: ');
  printAlarms();

  return times;
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

void clearAllAlarms() async {
  stopAllAlarms();
  await _alarmBox.clear();
}

List<AppAlarm> getAlarmList() {
  List<AppAlarm> list = [];
  _alarmBox.toMap().forEach((key, value) {
    list.add(AppAlarm.fromMap(Map<String, dynamic>.from(value as Map)));
  });

  return list;
}

void setItemInactive(DateTime timeStamp, String patientName, String medicationKey) async {
  await alarmsList.firstWhere((element) => element.timeStamp == timeStamp)
    .setItemInactive(patientName, medicationKey);
}

void setItemActive(DateTime timeStamp, String patientName, String medicationKey) async {
  alarmsList.firstWhere((element) => element.timeStamp == timeStamp)
    .setItemActive(patientName, medicationKey);
}