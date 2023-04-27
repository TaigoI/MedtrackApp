import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Alarme {
  static final _alarmeBox = Hive.box('alarme');

  String key;
  String medicationKey;
  DateTime timestamp;
  bool active;

  Alarme({
    required this.key,
    required this.medicationKey,
    required this.timestamp,
    required this.active,
  });

  get(String key) { return Alarme.fromMap(_alarmeBox.get(key)!); }
  save(){ _alarmeBox.put(key, toMap()); }
  delete(){ _alarmeBox.delete(key); }

  factory Alarme.fromMap(Map<String, dynamic> map) {
    return Alarme(
        key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
        medicationKey: map['medicationKey'].toString(),
        timestamp: DateTime.parse(map['timestamp'].toString()),
        active: true,
    );
  }

  toMap() {
    Map<String, dynamic> map = {
      'key': key,
      'medicationKey': medicationKey,
      'timestamp': timestamp,
      'active': active,
    };
    return map;
  }

}