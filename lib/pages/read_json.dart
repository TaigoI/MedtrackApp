import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:medtrack/models/medication.dart';

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

      medicationsJson.forEach((m) {
        m['doctorName'] = jsonResult['doctorName'];
        m['doctorRegistration'] = jsonResult['doctorRegistration'];
        m['patientName'] = jsonResult['patientName'];
        m['active'] = true;

        var medication = Medication.fromMap(m);
        medication.save();
     });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Receita lida com sucesso'),
    ));
  }

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
