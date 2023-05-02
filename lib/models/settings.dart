import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/pages/settings.dart';

class Settings {
  static final _settingsBox = Hive.box('settings_storage');

  String key;
  String


}
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
//
// class Alarm {
//   static final _alarmBox = Hive.box('alarm');
//
//   String key;
//   String medicationKey;
//   DateTime timestamp;
//   bool active;
//
//   Alarm({
//     required this.key,
//     required this.medicationKey,
//     required this.timestamp,
//     required this.active,
//   });
//
//   get(String key) { return Alarm.fromMap(_alarmBox.get(key)!); }
//   save(){ _alarmBox.put(key, toMap()); }
//   delete(){ _alarmBox.delete(key); }
//
//   factory Alarm.fromMap(Map<String, dynamic> map) {
//     return Alarm(
//       key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
//       medicationKey: map['medicationKey'].toString(),
//       timestamp: DateTime.parse(map['timestamp'].toString()),
//       active: bool.parse(map['active'].toString()),
//     );
//   }
//
//   toMap() {
//     Map<String, dynamic> map = {
//       'key': key,
//       'medicationKey': medicationKey,
//       'timestamp': timestamp,
//       'active': active,
//     };
//     return map;
//   }
//
// }
