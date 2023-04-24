import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Alarm {
  static final _alarmBox = Hive.box('alarm');

  String key;
  String medicationKey;
  DateTime timestamp;
  bool active;

  Alarm({
    required this.key,
    required this.medicationKey,
    required this.timestamp,
    required this.active,
  });

  persist(){
    _alarmBox.put(key, toJSON());
  }

  delete(){
    _alarmBox.delete(key);
  }

  factory Alarm.fromStorage(String key) {
    var item = _alarmBox.get(key);
    return Alarm.fromJson(item!);
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
        key: json.containsKey('key') ? json['key'] : UniqueKey().toString(),
        medicationKey: json['medicationKey'].toString(),
        timestamp: DateTime.parse(json['timestamp'].toString()),
        active: bool.parse(json['active'].toString()),
    );
  }

  toJSON() {
    Map<String, dynamic> json = {
      'key': key,
      'medicationKey': medicationKey,
      'timestamp': timestamp,
      'active': active,
    };
    return jsonEncode(json);
  }

}
