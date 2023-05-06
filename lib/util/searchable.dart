import 'package:diacritic/diacritic.dart';

class Searchable {

  static String toEquals(String text){
    var parsed = removeDiacritics(text)
        .toLowerCase()
        .replaceAll('-', '')
        .replaceAll('+', '')
        .replaceAll('/', '')
        .replaceAll(' ', '');
    return parsed;
  }

  static String toLike(String text){
    var parsed = removeDiacritics(text)
        .toLowerCase()
        .replaceAll('-', '')
        .replaceAll('+', '')
        .replaceAll('/', '')
        .replaceAll(' ', '%');
    return '%$parsed%';
  }

}

