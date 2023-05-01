import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:medtrack/widgets/scanner_error_widget.dart';
import 'package:alarm/alarm.dart';

class ScanQrCode extends StatefulWidget {

  const ScanQrCode({Key? key}) : super(key: key);

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  BarcodeCapture? barcode;
  String message = "Escaneie o QR code!";

  final MobileScannerController controller = MobileScannerController(
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal
      // detectionTimeoutMs: 1000,
      // returnImage: false,
      );

  bool isStarted = true;

  void _startOrStop() {
    try {
      if (isStarted) {
        controller.stop();
      } else {
        controller.start();
      }
      setState(() {
        isStarted = !isStarted;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong! $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    final String confirmationKey = args['confirmationKey'];
    final int alarmId = args['alarmId'];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 48),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.contain,
                onDetect: (barcode) {
                  setState(() {
                    this.barcode = barcode;
                    if (this.barcode!.barcodes.first.rawValue == confirmationKey) {
                      Alarm.stop(alarmId).then((_) => Navigator.pushNamed(context, '/'));
                    } else {
                      setState(() => message = "Não reconhecido [${this.barcode!.barcodes.first.rawValue} != $confirmationKey]");
                    }
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: controller.hasTorchState,
                        builder: (context, state, child) {
                          if (state != true) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            color: Colors.white,
                            icon: ValueListenableBuilder(
                              valueListenable: controller.torchState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.grey,
                                  );
                                }
                                switch (state as TorchState) {
                                  case TorchState.off:
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  case TorchState.on:
                                    return const Icon(
                                      Icons.flash_on,
                                      color: Colors.yellow,
                                    );
                                }
                              },
                            ),
                            iconSize: 32.0,
                            onPressed: () => controller.toggleTorch(),
                          );
                        },
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: isStarted
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: () {
                          _startOrStop();
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Cancelar ação"),
                              content: const Text(
                                "Se você não tem acesso ao QRcode agora, clique em confirmar."
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar")
                                ),
                                TextButton(
                                  onPressed: () {
                                    Alarm.stop(alarmId).then((_) => Navigator.pushNamed(context, '/'));
                                  },
                                  child: const Text("Confirmar")
                                )
                              ],
                            )
                          );
                        },
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 200,
                          height: 50,
                          child: FittedBox(
                            child: Text(
                              message,
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.cameraFacingState,
                          builder: (context, state, child) {
                            if (state == null) {
                              return const Icon(Icons.camera_front);
                            }
                            switch (state as CameraFacing) {
                              case CameraFacing.front:
                                return const Icon(Icons.camera_front);
                              case CameraFacing.back:
                                return const Icon(Icons.camera_rear);
                            }
                          },
                        ),
                        iconSize: 32.0,
                        onPressed: () => controller.switchCamera(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
