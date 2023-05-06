import 'package:medtrack/util/medicationsDatabase.dart';
import 'package:medtrack/util/searchable.dart';
import 'package:string_similarity/string_similarity.dart';

class PresentationDataset {

  static Future<List<Map>> findByNameAndMedicationIdSortedByDistance(String name, int id) async {
    String query = '''SELECT p.*
                      FROM medication_presentation mp
                      JOIN presentation p ON (mp.presentationid = p.id)
                      WHERE mp.medicationid = ?
                      AND p.searchable LIKE ?
                      GROUP BY p.id
                      ORDER BY p.searchable;''';

    List<Map> resultSet = await MedicationsDatabaseHelper.db.rawQuery(query, [id, Searchable.toLike(name)]);

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

  static Future<Map?> searchByNameAndMedicationId(String name, int id) async{
    List<Map> resultSet = await MedicationsDatabaseHelper.db.rawQuery("SELECT * FROM prescription WHERE searchable = ?", [Searchable.toEquals(name)]);
    return resultSet.length == 1 ? null : resultSet[0];
  }

}
