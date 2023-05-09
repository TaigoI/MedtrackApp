// import 'package:flutter/material.dart';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';

// class Settings extends StatefulWidget {
//   const Settings({Key? key}) : super(key: key);

//   @override
//   State<Settings> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<Settings> {
//   bool _switchNecessaryValue = false;
//   bool _switchUnnecessaryValue = false;
//   bool _switchUnnecessaryOpValue = false;
//   String? _selectedRadioTile = 'Mozart';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Configurações'),
//       ),
//       body: SettingsList(
//         sections: [
//           SettingsSection(
//             title: Text('GERAL'),
//             tiles: [
//               SettingsTile(
//                 title: Text('Toque do alarme'),
//                 leading: Icon(Icons.music_note),
//                 onPressed: (BuildContext context) {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Defina um novo toque:'),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             RadioListTile(
//                               title: Text('Mozart'),
//                               value: 'Mozart',
//                               groupValue: _selectedRadioTile,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   _selectedRadioTile = value;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             RadioListTile(
//                               title: Text('Nokia'),
//                               value: 'Nokia',
//                               groupValue: _selectedRadioTile,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   _selectedRadioTile = value;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             RadioListTile(
//                               title: Text('One piece'),
//                               value: 'One piece',
//                               groupValue: _selectedRadioTile,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   _selectedRadioTile = value;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             RadioListTile(
//                               title: Text('Star Wars'),
//                               value: 'Star Wars',
//                               groupValue: _selectedRadioTile,
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   _selectedRadioTile = value;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//           SettingsSection(
//               title: Text('NOTIFICAÇÕES NECESSÁRIAS'),
//               tiles: [
//                 SettingsTile.switchTile(
//                   title: Text(
//                       'Desejo receber notificações quando der a hora de tomar meus remédios.'),
//                   initialValue: _switchNecessaryValue,
//                   onToggle: (bool value) {
//                     setState(() {
//                       _switchNecessaryValue = value;
//                     });
//                   },
//                 ),
//               ]
//           ),
//           SettingsSection(
//               title: Text('NOTIFICAÇÕES OPCIONAIS'),
//               tiles: [
//                 SettingsTile.switchTile(
//                   title: Text(
//                       'Desejo que o app solicite que eu faça alguma tarefa para comprovar que tomei o remédio.'),
//                   initialValue: _switchUnnecessaryValue,
//                   onToggle: (bool value) {
//                     setState(() {
//                       _switchUnnecessaryValue = value;
//                     });
//                   },
//                 ),
//                 SettingsTile.switchTile(
//                   title: Text(
//                       'Desejo continuar recebendo a cada 20 minutos o alarme de tomar um remédio enquanto não confirmar que já tomei.'),
//                   initialValue: _switchUnnecessaryOpValue,
//                   onToggle: (bool value) {
//                     setState(() {
//                       _switchUnnecessaryOpValue = value;
//                     });
//                   },
//                 ),
//               ]
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medtrack/models/settings.dart';
import 'package:medtrack/main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {
  final _preferenceBox = Hive.box('preference');
  // final List<String> _avalialeRingtones = ['mozart', 'star wars'...];

  //final String _selectedRingtoneRadioTile = settings.selectedRingtones;
  bool _switchReceiveNotificationsValue = settings.receiveNotifications;
  bool _switchConfirmAlarmQRCodeValue = settings.confirmAlarmQRCode;
  bool _switchReceiveNotificationsTwentyMinutesValue = settings.receiveNotificationsTwentyMinutes;

  void _savePreferences() {
    _preferenceBox.put(
        'user_prefs',
        Preference(
          key: 'key',
          //selectedRingtones: _selectedRingtoneRadioTile,
          receiveNotifications: _switchReceiveNotificationsValue,
          confirmAlarmQRCode: _switchConfirmAlarmQRCodeValue,
          receiveNotificationsTwentyMinutes: _switchReceiveNotificationsTwentyMinutesValue,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: SettingsList(
        sections: [
          //SettingsSection(
            //title: Text('GERAL'),
            //tiles: [
            //   SettingsTile(
            //     title: Text('Toque do alarme'),
            //     leading: Icon(Icons.music_note),
            //     onPressed: (BuildContext context) {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             title: Text('Defina um novo toque:'),
            //             content: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 RadioListTile(
            //                   title: Text('Mozart'),
            //                   value: 'Mozart',
            //                   groupValue: _selectedRingtoneRadioTile,
            //                   onChanged: (String? value) {
            //                     setState(() {
            //                       _selectedRingtoneRadioTile = value;
            //                     });
            //                     Navigator.pop(context);
            //                     _savePreferences();
            //                   },
            //                 ),
            //                 RadioListTile(
            //                   title: Text('Nokia'),
            //                   value: 'Nokia',
            //                   groupValue: _selectedRingtoneRadioTile,
            //                   onChanged: (String? value) {
            //                     setState(() {
            //                       _selectedRingtoneRadioTile = value;
            //                     });
            //                     Navigator.pop(context);
            //                     _savePreferences();
            //                   },
            //                 ),
            //                 RadioListTile(
            //                   title: Text('One piece'),
            //                   value: 'One piece',
            //                   groupValue: _selectedRingtoneRadioTile,
            //                   onChanged: (String? value) {
            //                     setState(() {
            //                       _selectedRingtoneRadioTile = value;
            //                     });
            //                     Navigator.pop(context);
            //                     _savePreferences();
            //                   },
            //                 ),
            //                 RadioListTile(
            //                   title: Text('Star Wars'),
            //                   value: 'Star Wars',
            //                   groupValue: _selectedRingtoneRadioTile,
            //                   onChanged: (String? value) {
            //                     setState(() {
            //                       _selectedRingtoneRadioTile = value;
            //                       settings.selectedRingtones = value;
            //                     });
            //                     await _savePreferences();
            //                     Navigator.pop(context);
            //                     _savePreferences();
            //                   },
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ],
          //),
          SettingsSection(title: Text('NOTIFICAÇÕES NECESSÁRIAS'), tiles: [
            SettingsTile.switchTile(
              title: Text(
                  'Desejo receber notificações quando der a hora de tomar meus remédios.'),
              initialValue: _switchReceiveNotificationsValue,
              onToggle: (bool value) async {
                setState(() {
                  _switchReceiveNotificationsValue = value;
                });
                settings.receiveNotifications = value;
                await settings.save();
              },
            ),
          ]),
          SettingsSection(title: Text('NOTIFICAÇÕES OPCIONAIS'), tiles: [
            SettingsTile.switchTile(
              title: Text(
                  'Desejo que o app solicite que eu faça alguma tarefa para comprovar que tomei o remédio.'),
              initialValue: _switchConfirmAlarmQRCodeValue,
              onToggle: (bool value) async {
                setState(() {
                  _switchConfirmAlarmQRCodeValue = value;
                });
                settings.confirmAlarmQRCode = value;
                await settings.save();

                String mensagem = value ? 'A tarefa será solicitada!' : 'A tarefa não será solicitada.';
                print(mensagem);
              },
            ),
            SettingsTile.switchTile(
              title: Text(
                  'Desejo continuar recebendo a cada 20 minutos o alarme de tomar um remédio enquanto não confirmar que já tomei.'),
              initialValue: _switchReceiveNotificationsTwentyMinutesValue,
              onToggle: (bool value) async {
                setState(() {
                  _switchReceiveNotificationsTwentyMinutesValue = value;
                });
                settings.receiveNotificationsTwentyMinutes = value;
                await settings.save();
              },
            ),
          ]),
        ],
      ),
    );
  }
}

