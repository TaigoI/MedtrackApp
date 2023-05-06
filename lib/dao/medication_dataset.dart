import 'package:medtrack/util/medicationsDatabase.dart';
import 'package:medtrack/util/searchable.dart';
import 'package:string_similarity/string_similarity.dart';

class MedicationDataset {

  static Future<List<Map>> findByNameSortedByDistance(String name) async {
    List<Map> resultSet = await MedicationsDatabaseHelper.db.rawQuery("SELECT * FROM medication WHERE searchable LIKE ? ORDER BY searchable", [Searchable.toLike(name)]);

    List<Map> result = [];
    for (var line in resultSet) {
      Map element = {
        "id": line["id"],
        "name": line["name"],
        "searchable": line["searchable"]
      };
      element['distance'] = element['searchable'].toString().similarityTo(name);
      result.add(element);
    }

    result.sort((a,b) => a['distance'] != b['distance']
        ? b['distance'].compareTo(a['distance'])
        : a['searchable'].compareTo(b['searchable'])
    );

    return result;
  }

  static Future<Map?> getByName(String name) async{
    List<Map> resultSet = await MedicationsDatabaseHelper.db.rawQuery("SELECT * FROM medication WHERE searchable = ?", [Searchable.toEquals(name)]);
    return resultSet.length == 1 ? resultSet[0] : null;
  }

}
