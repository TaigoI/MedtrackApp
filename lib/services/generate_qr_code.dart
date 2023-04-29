import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

Future<String> generateQrCodeAndShareIt() async {
  String code = UniqueKey().toString();
  String path = await generateQrPicture(code);

  await Share.shareFiles(
    [path],
    mimeTypes: ["image/png"],
    subject: 'Medtrack QRCode',
    text: "Imprima para fazer a verificação"
  );

  return code;
} 

Future<String> generateQrPicture(String code) async {
  final qrValidationResult = QrValidator.validate(
    data: code,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L
  );

  if (qrValidationResult.status == QrValidationStatus.error) {
    print("Erro na validação");
  }

  final QrCode qrCode = qrValidationResult.qrCode!;
  final painter = QrPainter.withQr(
    qr: qrCode,
    color: const Color(0xFFFFFFFF),
    gapless: false,
    embeddedImage: null,
    embeddedImageStyle: null
  );

  Directory tempDir = await getTemporaryDirectory();
  final ts = DateTime.now().millisecondsSinceEpoch.toString();
  String path = '${tempDir.path}/$ts.png';

  final picData = await painter.toImageData(2048, 
    format: ImageByteFormat.png,
  );
  await writeToFile(picData!, path);

  return path;
}

Future<void> writeToFile(ByteData picData, String path) async {
  final buffer = picData.buffer;
  await File(path).writeAsBytes(
    buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes)
  );
}