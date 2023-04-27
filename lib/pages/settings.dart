import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Configurações gerais', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white,
              ),
            ),
          ),
          ListTile(
            title: Text('Notificações necessárias', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white,
              ),
            ),
          ),
          SwitchListTile(
            value: true,
            onChanged: (bool value) {
              // Atualize o estado da opção
            },
            title: Text('Alarmes de remédios'),
            subtitle: Text('Desejo receber notificações quando der a hora de tomar meus remédios.'),
          ),
          ListTile(
            title: Text('Notificações opcionais', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white,
              ),
            ),
          ),
          SwitchListTile(
            value: false,
            onChanged: (bool value) {
              // Atualize o estado da opção
            },
            title: Text('Solicitar tarefa de confirmação'),
            subtitle: Text('Desejo que o app solicite que eu faça alguma tarefa para comprovar que tomei o remédio, assim não dispensarei a notificação sem realmente ter tomado.'),
          ),
          SwitchListTile(
            value: false,
            onChanged: (bool value) {
              // Atualize o estado da opção
            },
            title: Text('Repetição de Alarmes'),
            subtitle: Text('Desejo continuar recebendo a cada 20 minutos o alarme de tomar um remédio enquanto não confirmar que já tomei.'),
          ),
        ],
      ),
    );
  }
}
