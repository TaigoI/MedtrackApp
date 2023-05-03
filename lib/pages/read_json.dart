import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:medtrack/models/medication.dart';

class QRCodeScanner {
  Future<void> scanQRCode() async {
    String? barcodeScanRes;

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
      // ScaffoldMessenger.of().showSnackBar(SnackBar(
      //   content: Text('Receita importada com sucesso!'),
      // ));
    }
  }
}
