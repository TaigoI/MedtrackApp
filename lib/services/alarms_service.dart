import 'package:alarm/alarm.dart';

import '../components/prescription_item.dart';

String formatTime(DateTime date) => 
  "${date.hour.toString().padLeft(2, '0')}: ${date.minute.toString().padLeft(2, '0')}";


class AlarmPrescriptionItem {
  PrescriptionItem prescriptionItem;
  String audioPath;
  bool vibrate;
  late int alarmPrescriptionItemId;
  late DateTime now;


  // PrescriptionItem.date is # of days

  AlarmPrescriptionItem(
      {required this.prescriptionItem,
      required this.audioPath,
      required this.vibrate}) {
    alarmPrescriptionItemId = DateTime.now().millisecondsSinceEpoch % 100000;
    now = DateTime.now();
  }

  void setPeriodicAlarm() async {
    final int hourlyPeriod = int.parse(prescriptionItem.time);
    DateTime endDate = now.add(Duration(days: int.parse(prescriptionItem.date)));
    final int timesPerDay = (24 / hourlyPeriod).ceil();
    final int numberOfDays = endDate.difference(now).inDays;
    
    DateTime currentStamp = now;

    print("hourly period: $hourlyPeriod | timesPerDay: $timesPerDay | numberOfDays: $numberOfDays");

    // actual logic:
      // while(currentStamp.day < endDate.day) {
    for (int i = 0; i < 3; i++) {
      currentStamp = currentStamp.add(const Duration(seconds: 15));
      
      final alarmSettings =  AlarmSettings(
        id: DateTime.now().millisecondsSinceEpoch % 100000, 
        dateTime: currentStamp, 
        assetAudioPath: audioPath,
        vibrate: vibrate,
        loopAudio: true,
        notificationTitle: "${formatTime(currentStamp)} | ${prescriptionItem.medicine}",
        notificationBody: "${prescriptionItem.dosage} ${prescriptionItem.dosageUnit}"
      );

      await Alarm.set(alarmSettings: alarmSettings); // nota: em caso de alarmes que passam do dia atual, o debug mostra a data errada
    }

    for (AlarmSettings alarm in Alarm.getAlarms()) {
      print("Novo alarme: ${alarm.id} [${alarm.dateTime}]"); // aqui é possível ver que os alarmes têm as datas certas
    }
  }
}

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

void printAlarms() {
  print("\nAlarmes:");
  for (AlarmSettings alarm in Alarm.getAlarms()) {
      print("Alarme: ${alarm.id} [${alarm.dateTime}]"); // aqui é possível ver que os alarmes têm as datas certas
  }
  print("");
}