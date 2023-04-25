import 'package:alarm/alarm.dart';

import 'package:medtrack/models/medication.dart';
import 'package:medtrack/models/prescription.dart';
/**
   * A ideia pra isso aqui é o seguinte:
   * Há o problema de que o plugin enlouquece se tiver mais de uma alarme ao mesmo tempo
   * e esse certamente será o caso; é muito normal que uma pessoa tome dois, três remédios ao mesmo tempo
   * Além disso, surgiu a possibilidade de atribuir pessoas às receitas.
   * Dessa forma, não só é possível tocar mais de um alarme ao mesmo tempo, mas vários alarmes 
   * para várias receitas.
   * Na prática, para mim, cada ponto no tempo só pode ter um alarme, ainda que haja 500 remédios
   * para tomar ao mesmo tempo.
   * Então, eu preciso conhecer esses pontos no tempo de antemão antes de setar o alarme.
   * Preciso dar um jeito de, lendo os horários que o cara vai tomar o remédio, ver se já tem remédios setados 
   * para aquele alarme. 
   * A ideia, então, é deixar esse alarme dentro de um classes cujos campos são expandíveis (leia-se, os pacientes
   * e os remédios podem entrar e sair a qualquer momento).
   * Então, não é mais um remédio que tem um alarme numa hora, mas um alarme numa hora que tem os remédios 
   */ ///

class AlarmItem {
  bool active = true;
  var identificador;

  AlarmItem({required this.identificador});

  void setToActive() {
    active = true;
  }

  void setToInactive() {
    active = false;
  }
}

class SingleAlarm {
  DateTime timeStamp; // horário em que o alarme soará
  late Map<String, List<Medication>> items =
      {}; // itens a serem tomados neste horário
  String audioPath; // vem das configurações
  List<int> alarmsIds = List.empty(growable: true);

  SingleAlarm(
      {required this.timeStamp,
      required this.audioPath,
      required Medication item,
      required String patientName}) {
    items[patientName] = [item];
    setAlarm();
  }

  void addItem(Medication item, String patientName) {
    if (items.containsKey(patientName)) {
      items[patientName]!.add(item);
    } else {
      items[patientName] = [item];
    }
  }

  Future<void> setAlarm() async {
    int id = DateTime.now().millisecondsSinceEpoch % 1000;
    alarmsIds.add(id);

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
}

void alarmFromMedication(
    List<SingleAlarm> alarms, Medication medication, DateTime goalTime) async {
  String patientName =
      Prescription.fromStorage(medication.prescriptionKey).patientName;

  DateTime endDate = medication.initialDosage
      .add(Duration(minutes: (medication.occurrences * medication.interval)));

  print("endDate: [$endDate]");

  DateTime currentStamp = medication.initialDosage;
  bool timeStampTaken;
  // DateTime goal = DateTime.now().add(const Duration(seconds: 30));

  // while (currentStamp.isBefore(endDate)) {
  for (int i = 0; i < 1; i++) {
    timeStampTaken = false;

    for (SingleAlarm alarm in alarms) {
      if (alarm.timeStamp.compareTo(goalTime) == 0) {
        alarm.addItem(medication, patientName);
        timeStampTaken = true;
        break;
      }
    }

    if (!timeStampTaken) {
      alarms.add(SingleAlarm(
          audioPath: 'sounds/mozart.mp3',
          timeStamp: goalTime,
          item: medication,
          patientName: patientName));
    }

    currentStamp = currentStamp.add(Duration(minutes: medication.interval));
  }
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
