// qr_code_reader.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MedicationTeste {
  String key;
  bool active;
  String patientName;
  String doctorName;
  String doctorRegistration;
  String medicationName; //nome do remédio. "Paracetamol"
  String medicationDosage; //posologia do remédio. "500 MG/ML"
  int doseAmount; //quantidade do remédio que devem ser consumidas por vez. "5"
  //DoseUnitOption doseUnit; //unidade da quantidade de remédio que deve ser consumida por vez. "ML"
  int interval;
  //TimeUnitOption intervalUnit; //quantidade, em minutos, entre 2 doses
  int occurrences; //quantidade total de doses que o paciente irá consumir pra esta medicação
  String comments; //orientações gerais livres para o uso do medicamento a critério do médico

  MedicationTeste({
    required this.key,
    required this.active,
    required this.patientName,
    required this.doctorName,
    required this.doctorRegistration,
    required this.medicationName,
    required this.medicationDosage,
    required this.doseAmount,
    required this.interval,
    required this.occurrences,
    required this.comments
  });

  factory MedicationTeste.fromJson(Map<String, dynamic> json) {
    return MedicationTeste(
      key: json['key'],
      active: json['active'],
      patientName: json['patientName'],
      doctorName: json['doctorName'],
      doctorRegistration: json['doctorRegistration'],
      medicationName: json['medicationName'],
      medicationDosage: json['medicationDosage'],
      doseAmount: json['doseAmount'],
      interval: json['interval'],
      occurrences: json['occurrences'],
      comments: json['comments']
    );
  }
}

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final String _scanResult = '';

  Future<void> _scanQRCode() async {
    String? barcodeScanRes;
    // leitura do QR Code
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.QR);
      print(barcodeScanRes);
    } catch (e) {
      print(e.toString());
    }

    if (barcodeScanRes != null) {
      dynamic jsonResult = jsonDecode(barcodeScanRes);

      var medicationsJson = jsonResult['medications'];

      medicationsJson.forEach((m) => {
          m['doctorName'] = jsonResult['doctorName'];
          m['doctorRegistration'] = jsonResult['doctorRegistration'];
          m['patientName'] = jsonResult['patientName'];
          m['active'] = true;

          var medication = MedicationTeste.fromJson(m);
          medication.save();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Receita lida com sucesso'),
      ));

      /*if (medicationsJson is Map<String, dynamic>) {


        String key = jsonResult['key'];
        bool active = jsonResult['active'];
        String patientName = jsonResult['patientName'];
        String doctorName = jsonResult['doctorName'];
        String doctorRegistration = jsonResult['doctorRegistration'];
        String medicationName = jsonResult['medicationName'];
        String medicationDosage = jsonResult['medicationDosage'];
        int doseAmount = jsonResult['doseAmount'];
        int interval = jsonResult['interval'];
        int occurrences = jsonResult['occurrences'];
        String comments = jsonResult['comments'];
        print('key: $key, active: $active, patientName: $patientName');


      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitor de QR Code'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQRCode,
        tooltip: 'Ler QR Code',
        child: Icon(Icons.qr_code),
      ),
    );
  }
}
