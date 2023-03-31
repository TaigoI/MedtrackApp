import 'dart:convert';

import 'package:medtrack/components/prescription.dart';
import 'package:http/http.dart' as http;

class PrescriptionAPI {

  static const String LOCALHOST = "http://localhost:8080";
  static const String DEV = "https://pds-2022-2-03.edge.net.br";
  static const String BASE_URL = LOCALHOST;

  /// Refreshes all records from the API, replacing the ones that are in the cache.
  /// Notifies listeners if notifyListeners is true.

  static List<Prescription> parsePrescriptionList(String responseBody) {
    final parsed = jsonDecode(responseBody)['content'].cast<Map<String, dynamic>>();

    return parsed.map<Prescription>((json) => Prescription.fromJson(json)).toList();
  }

  static Future<List<Prescription>> getAll() async{
    final response = await http.get(Uri.parse('$BASE_URL/prescription'));
    if (response.statusCode == 200) {
      return parsePrescriptionList(response.body);
    } else {
      throw Exception('Failed to load prescriptions');
    }
  }

  create(Prescription p) async{
    //TODO: http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  update(Prescription p) async{
    //TODO: http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

}
