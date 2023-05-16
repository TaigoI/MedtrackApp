import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:medtrack/main.dart';
import 'package:medtrack/services/generate_qr_code.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {
  final _preferenceBox = Hive.box('preference');

  String _selectedRingtoneRadioTile = settings!.selectedRingtone;
  bool _switchConfirmAlarmQRCodeValue = settings!.confirmAlarmQRCode;
  bool _switchReceiveNotificationsValue = settings!.receiveNotifications;
  //bool isOptionEnabledQRCode = true;
  //bool isOptionEnabledNotify = true;

  Future<void> _savePreferences() async {
    await settings!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('GERAL'),
              tiles: [
                SettingsTile(
                  title: const Text('Toque do alarme'),
                  leading: const Icon(Icons.music_note),
                  onPressed: (BuildContext context) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Defina um novo toque:'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                title: const Text('Mozart'),
                                value: 'sounds/mozart.mp3',
                                groupValue: _selectedRingtoneRadioTile,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRingtoneRadioTile = value!;
                                    settings!.selectedRingtone = value;
                                  });
                                  //_savePreferences();
                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile(
                                title: const Text('Nokia'),
                                value: 'sounds/nokia.mp3',
                                groupValue: _selectedRingtoneRadioTile,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRingtoneRadioTile = value!;
                                    settings!.selectedRingtone = value;
                                  });
                                  _savePreferences();
                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile(
                                title: const Text('One piece'),
                                value: 'sounds/one_piece.mp3',
                                groupValue: _selectedRingtoneRadioTile,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRingtoneRadioTile = value!;
                                    settings!.selectedRingtone = value;
                                  });
                                  _savePreferences();
                                  Navigator.pop(context);
                                },
                              ),
                              RadioListTile(
                                title: const Text('Star Wars'),
                                value: 'sounds/star_wars.mp3',
                                groupValue: _selectedRingtoneRadioTile,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedRingtoneRadioTile = value!;
                                    settings!.selectedRingtone = value;
                                  });
                                  _savePreferences();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(title: const Text('NOTIFICAÇÕES'), tiles: [
              SettingsTile.switchTile(
                title: const Text(
                    'Desejo que o app solicite que eu faça alguma tarefa para comprovar que tomei o remédio.'),
                initialValue: _switchConfirmAlarmQRCodeValue,
                //enabled: isOptionEnabledQRCode,
                onToggle: (bool value) async {
                  setState(() {
                    _switchConfirmAlarmQRCodeValue = value;
                  });

                  if (value == true) {
                    settings!.keyQRCode = await generateQrCodeAndShareIt();
                    //isOptionEnabledQRCode = true;
                  } //else {
                  //   isOptionEnabledQRCode = false;
                  // }

                  settings!.confirmAlarmQRCode = value;
                  await settings!.save();

                  String mensagem = value
                      ? 'A tarefa será solicitada!'
                      : 'A tarefa não será solicitada.';
                  print(mensagem);
                },
              ),
              SettingsTile.switchTile(
                title: const Text(
                    'Desejo continuar recebendo a cada 20 minutos o alarme de tomar um remédio enquanto não confirmar que já tomei.'),
                initialValue: _switchReceiveNotificationsValue,
                //enabled: isOptionEnabledNotify,
                onToggle: (bool value) async {
                  setState(() {
                    _switchReceiveNotificationsValue = value;
                  });

                  // if (value == true) {
                  //   isOptionEnabledNotify = true; //chamar a função de soneca do helder
                  // } else {
                  //   isOptionEnabledNotify = false;
                  // }

                  settings!.receiveNotifications = value;
                  await settings!.save();
                },
              ),
            ]),
          ],
        ),
    );
  }
}
