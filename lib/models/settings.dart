import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Preference {
  static final _preferenceBox = Hive.box('preference');

  String key;
  String selectedRingtone;
  String? keyQRCode;
  bool confirmAlarmQRCode;
  bool receiveNotifications;

  Preference({
    required this.key,
    required this.selectedRingtone,
    required this.keyQRCode,
    required this.confirmAlarmQRCode,
    required this.receiveNotifications,
  }) {
    save();
  }

  getKey() {
    return key;
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      key: map['key'],
      selectedRingtone: map['selectedRingtone'].toString(),
      keyQRCode: map['keyQRCode'].toString(),
      confirmAlarmQRCode: map['confirmAlarmQRCode'],
      receiveNotifications: map['receiveNotifications'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'selectedRingtone': selectedRingtone,
      'keyQRCode': keyQRCode,
      'confirmAlarmQRCode': confirmAlarmQRCode,
      'receiveNotifications': receiveNotifications
    };
  }

  static Preference? getPreference(String key) {
    final preferenceMap = _preferenceBox.get(key);
    return preferenceMap != null ? Preference.fromMap(preferenceMap) : null;
  }

  Future<void> save() async {
    await _preferenceBox.put(key, toMap());
  }

  void delete() {
    _preferenceBox.delete(key);
  }
}
