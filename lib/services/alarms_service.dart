import 'package:alarm/alarm.dart';
import 'package:medtrack/components/prescription.dart';

import '../components/prescription_item.dart';

class AlarmPrescriptionItem {
  PrescriptionItem prescriptionItem;
  String audioPath;
  bool vibrate;
  late DateTime startDate;
  List<int> alarmsIds = List.empty(growable: true); 

  // PrescriptionItem.date is # of days

  AlarmPrescriptionItem(
      {required this.prescriptionItem,
      required this.audioPath,
      required this.vibrate}) {
    startDate = DateTime.now();
  }

  void setPeriodicAlarm() async {
    final int hourlyPeriod = int.parse(prescriptionItem.time);
    DateTime endDate = startDate.add(Duration(days: int.parse(prescriptionItem.date)));
    final int timesPerDay = (24 / hourlyPeriod).ceil();
    final int numberOfDays = endDate.difference(startDate).inDays;
    
    DateTime currentStamp = startDate;

    print("hourly period: $hourlyPeriod | timesPerDay: $timesPerDay | numberOfDays: $numberOfDays");

    // actual logic:
      // while(currentStamp.day < endDate.day) {
    for (int i = 0; i < 1; i++) {
      currentStamp = currentStamp.add(const Duration(seconds: 5));
      
      int currId = DateTime.now().millisecondsSinceEpoch % 1000;
      alarmsIds.add(currId);
      
      final alarmSettings =  AlarmSettings(
        id: currId, 
        dateTime: currentStamp, 
        assetAudioPath: audioPath,
        vibrate: vibrate,
        loopAudio: false,
        notificationTitle: "Hora do Remédio",
        notificationBody: prescriptionItem.medicine
      );

      await Alarm.set(alarmSettings: alarmSettings); // nota: em caso de alarmes que passam do dia atual, o debug mostra a data errada
    }

    for (AlarmSettings alarm in Alarm.getAlarms()) {
      print("Novo alarme: ${alarm.id} [${alarm.dateTime}]"); // aqui é possível ver que os alarmes têm as datas certas
    }
  }
}

List<AlarmPrescriptionItem> getAlarmsFromPrescription(Prescription prescription) {
  List<AlarmPrescriptionItem> alarmsList = List.empty(growable: true);
  
  String audioPath = 'sounds/mozart.mp3';
  bool vibrate = true;

  DateTime today = DateTime.now();
  for (PrescriptionItem item in prescription.items) {
    if (today.isAfter(today.add(
        Duration(days: int.parse(item.date))
      ))
    ) {
      continue;
    }
    
    alarmsList.add(
      AlarmPrescriptionItem(prescriptionItem: item, audioPath: audioPath, vibrate: vibrate)
    );
  }

  return alarmsList;
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