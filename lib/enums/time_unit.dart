import 'package:medtrack/enums/plural.dart';
import 'package:medtrack/main.dart';

enum TimeUnitOption { minute, hour, day, week }

class TimeUnitController {

  static final Map<PluralProperty, Map<TimeUnitOption, String>> asTextMap = {
    PluralProperty.singular: {
      TimeUnitOption.minute: 'minuto',
      TimeUnitOption.hour: 'hora',
      TimeUnitOption.day: 'dia',
      TimeUnitOption.week: 'semana'
    },
    PluralProperty.plural: {
      TimeUnitOption.minute: 'minutos',
      TimeUnitOption.hour: 'horas',
      TimeUnitOption.day: 'dias',
      TimeUnitOption.week: 'semanas'
    },
    PluralProperty.pluralOptional: {
      TimeUnitOption.minute: 'minuto(s)',
      TimeUnitOption.hour: 'hora(s)',
      TimeUnitOption.day: 'dia(s)',
      TimeUnitOption.week: 'semana(s)'
    },
  };

  static asText(PluralProperty plural, TimeUnitOption option, [bool? capitalize]){
    if(asTextMap[plural]!.containsKey(option)) {
      if(capitalize != null && capitalize == true){
        return asTextMap[plural]![option]!.toCapitalized();
      }
      return asTextMap[plural]![option];
    }
  }
}