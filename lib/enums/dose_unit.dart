import 'package:medtrack/enums/plural.dart';
import 'package:medtrack/main.dart';

enum DoseUnitOption { pill, drop, spray, application }

class DoseUnitController {

  static final Map<PluralProperty, Map<DoseUnitOption, String>> asTextMap = {
    PluralProperty.singular: {
      DoseUnitOption.pill: 'comprimido',
      DoseUnitOption.drop: 'gota',
      DoseUnitOption.spray: 'jato',
      DoseUnitOption.application: 'aplicação',
    },
    PluralProperty.plural: {
      DoseUnitOption.pill: 'comprimidos',
      DoseUnitOption.drop: 'gotas',
      DoseUnitOption.spray: 'jatos',
      DoseUnitOption.application: 'aplicações',
    },
    PluralProperty.pluralOptional: {
      DoseUnitOption.pill: 'comprimido(s)',
      DoseUnitOption.drop: 'gota(s)',
      DoseUnitOption.spray: 'jatos(s)',
      DoseUnitOption.application: 'aplicação(ões)',
    },
  };

  static asText(PluralProperty plural, DoseUnitOption option, [bool? capitalize]){
    if(asTextMap[plural]!.containsKey(option)) {
      if(capitalize != null && capitalize == true){
        return asTextMap[plural]![option]!.toCapitalized();
      }
      return asTextMap[plural]![option];
    }
  }

}
