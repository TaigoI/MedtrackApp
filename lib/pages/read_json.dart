// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:medtrack/models/medication.dart';
//
// class QRCodeScanner {
//   Future<void> scanQRCode(BuildContext context) async {
//     try {
//       String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666",
//         "Cancelar",
//         true,
//         ScanMode.QR,
//       );
//
//       if (barcodeScanRes != '-1') {
//         dynamic jsonResult = jsonDecode(barcodeScanRes);
//         var medicationsJson = jsonResult['medications'];
//
//         medicationsJson.forEach((m) {
//           m['doctorName'] = jsonResult['doctorName'];
//           m['doctorRegistration'] = jsonResult['doctorRegistration'];
//           m['patientName'] = jsonResult['patientName'];
//           m['active'] = true;
//
//           var medication = Medication.fromJson(m);
//           medication.save();
//         });
//       } else {
//         showErrorMessage(context, 'Falha ao ler o QRCode.');
//       }
//     } catch (e) {
//       print(e.toString());
//       showErrorMessage(context, 'Ocorreu um erro inesperado. Tente novamente.');
//     }
//   }
//
//   void showErrorMessage(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: Text(message),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }



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

        var medication = Medication.fromJson(m);
        medication.save();
      });
    }
  }
}
