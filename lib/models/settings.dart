import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Preference {
  static final _preferenceBox = Hive.box('preference');

  String key;
  //String selectedRingtones;
  bool receiveNotifications;
  bool confirmAlarmQRCode;
  bool receiveNotificationsTwentyMinutes;

  Preference({
    required this.key,
    //required this.selectedRingtones,
    required this.receiveNotifications,
    required this.confirmAlarmQRCode,
    required this.receiveNotificationsTwentyMinutes,
  }) {
    save();
  }

  getKey() {
    return key;
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
      //selectedRingtones: List<String>.from(map['selectedRingtones']),
      receiveNotifications: true,
      confirmAlarmQRCode: true,
      receiveNotificationsTwentyMinutes: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      //'selectedRingtones': selectedRingtones,
      'receiveNotifications': receiveNotifications,
      'confirmAlarmQRCode': confirmAlarmQRCode,
      'receiveNotificationsTwentyMinutes': receiveNotificationsTwentyMinutes
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

// class SettingsModel {
//   static final _settingsBox = Hive.box('settings');
//
//   String key;
//   List<String> selectedRingtones;
//   bool notifier = false;
//   bool confirmQRCode = false;
//   bool notifierTwentyMinutes = false;
//
//   SettingsModel({
//     required this.key,
//     required this.selectedRingtones,
//     required this.notifier,
//     required this.confirmQRCode,
//     required this.notifierTwentyMinutes,
//   });
//
//   static SettingsModel get() {
//     var prefs = _settingsBox.get('user_prefs');
//     if (prefs == null) {
//       return SettingsModel(
//         key: 'key',
//         notifier: true,
//         confirmQRCode: false,
//         notifierTwentyMinutes: false,
//       );
//     } else {
//       return SettingsModel.fromMap(prefs);
//     }
//   }
//
//   save() {
//     _settingsBox.put('user_prefs', toMap());
//   }
//
//   delete(){ _settingsBox.delete(key); }
//
//   factory SettingsModel.fromMap(Map<String, dynamic> map) {
//     return SettingsModel(
//       key: map.containsKey('key') ? map['key'] : UniqueKey().toString(),
//       selectedRingtones: List<String>.from(map['selectedRingtones']),
//       notifier: true,
//       confirmQRCode: false,
//       notifierTwentyMinutes: false,
//     );
//   }
//
//   toMap() {
//     Map<String, dynamic> map = {
//       'key': key,
//       'notifier': notifier,
//       'confirmQRCode': confirmQRCode,
//       'notifierTwentyMinutes': notifierTwentyMinutes,
//     };
//     return map;
//   }
// }
//
// // get(String key) { return SettingsModel.fromMap(_settingsBox.get(key)!); }
// //save(){ _settingsBox.put(key, toMap()); }