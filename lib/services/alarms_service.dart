import 'package:alarm/alarm.dart';

void AlarmIn15Seconds() {
  final now = DateTime.now();
  final id = DateTime.now().millisecondsSinceEpoch % 100000;

  final alarmSettings = AlarmSettings(
    id: id, 
    dateTime: now.add(const Duration(seconds: 15)), 
    assetAudioPath: 'sounds/mozart.mp3',
    loopAudio: true,
    vibrate: true,
    notificationTitle: 'Exemplo de Alarme',
    notificationBody: 'Alarme ($id) está tocando',
  );

  Alarm.set(alarmSettings: alarmSettings);
}

void stopAlarms() {
  for (AlarmSettings alarm in Alarm.getAlarms()) {
    Alarm.stop(alarm.id);
  }
}