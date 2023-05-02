import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import '../models/settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medtrack/utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {
  bool _switchNecessaryValue = false;
  bool _switchUnnecessaryValue = false;
  bool _switchUnnecessaryOpValue = false;
  String? _selectedRadioTile = 'Mozart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('GERAL'),
            tiles: [
              SettingsTile(
                title: Text('Toque do alarme'),
                leading: Icon(Icons.music_note),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Defina um novo toque:'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                              title: Text('Mozart'),
                              value: 'Mozart',
                              groupValue: _selectedRadioTile,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedRadioTile = value;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              title: Text('Nokia'),
                              value: 'Nokia',
                              groupValue: _selectedRadioTile,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedRadioTile = value;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              title: Text('One piece'),
                              value: 'One piece',
                              groupValue: _selectedRadioTile,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedRadioTile = value;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              title: Text('Star Wars'),
                              value: 'Star Wars',
                              groupValue: _selectedRadioTile,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedRadioTile = value;
                                });
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
          SettingsSection(
            title: Text('NOTIFICAÇÕES NECESSÁRIAS'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Desejo receber notificações quando der a hora de tomar meus remédios.'),
                initialValue: _switchNecessaryValue,
                onToggle: (bool value) {
                  setState(() {
                    _switchNecessaryValue = value;
                  });
                },
              ),
            ]
          ),
          SettingsSection(
            title: Text('NOTIFICAÇÕES OPCIONAIS'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Desejo que o app solicite que eu faça alguma tarefa para comprovar que tomei o remédio.'),
                initialValue: _switchUnnecessaryValue,
                onToggle: (bool value) {
                  setState(() {
                    _switchUnnecessaryValue = value;
                });
              },
            ),
              SettingsTile.switchTile(
                title: Text('Desejo continuar recebendo a cada 20 minutos o alarme de tomar um remédio enquanto não confirmar que já tomei.'),
                initialValue: _switchUnnecessaryOpValue,
                onToggle: (bool value) {
                  setState(() {
                    _switchUnnecessaryOpValue = value;
                  });
                },
              ),
            ]
          ),
        ],
      ),
    );
  }
}
