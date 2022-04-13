import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'discoveryPage.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  InitializationSettings initializationSettings;

  bool isConnecting = true;
  String fact;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  bool _autoAcceptPairingRequests = false;
  BluetoothDevice _selectedDevice;
  BluetoothConnection connection;
  bool ledState = false;
  var list;
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    // Obtenemos el estado actual del bluetooth
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        return this._bluetoothState = state;
      });
    });

    // Escuchar por futuros cambios
    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        this._bluetoothState = state;
      });
    });

    initializing();
    tz.initializeTimeZones();
  }

  void initializing() async {
    androidInitializationSettings =
        AndroidInitializationSettings('ic_launcher_foreground');
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsZoneSchedule() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await notificationZoneSchedule();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      'Channel body',
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Tomar pastilla',
      'Tiene que tomar la pastilla x',
      notificationDetails,
      payload: 'Item X',
    );
  }

  notificationZoneSchedule() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      'Channel body',
      priority: Priority.high,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Tomar pastilla en cierto tiempo',
      'Tiene que tomar la pastilla x',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    return null;
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuraciones',
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: Theme.of(context).appBarTheme.elevation,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'CONEXIÓN BLUETOOTH AL DISPOSITIVO',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Habilitar Bluetooth',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                value: this._bluetoothState.isEnabled,
                activeColor: Theme.of(context).accentColor,
                onChanged: (value) {
                  future() async {
                    if (value)
                      await FlutterBluetoothSerial.instance.requestEnable();
                    else
                      await FlutterBluetoothSerial.instance.requestDisable();
                  }

                  future().then((_) {
                    setState(() {});
                  });
                },
              ),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text(
                  'Intentar el siguiente pin especifico',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  'Pin 1234',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).textTheme.overline.color,
                      ),
                ),
                value: this._autoAcceptPairingRequests,
                onChanged: (value) {
                  setState(() {
                    this._autoAcceptPairingRequests = value;
                  });
                  if (value) {
                    FlutterBluetoothSerial.instance
                        .setPairingRequestHandler((request) {
                      if (request.pairingVariant == PairingVariant.Pin) {
                        return Future.value('1234');
                      }
                      return null;
                    });
                  } else {
                    FlutterBluetoothSerial.instance
                        .setPairingRequestHandler(null);
                  }
                },
              ),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text(
                  'Prueba de LED',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text('Cambia el estado del LED de prueba en ON/OFF'),
                value: this.ledState,
                onChanged: (value) {
                  setState(() => this.ledState = value);
                  if (value) {
                    fact = 'a';
                    _factSent();
                  } else {
                    fact = 'b';
                    _factSent();
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Dispositivo conectado',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  '${this._selectedDevice?.name == 'HC-05' ? 'Smart Pillbox' : this._selectedDevice?.name ?? 'No hay dispositivo conectado'}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).textTheme.overline.color,
                      ),
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  child: Text(
                    'Enlazar dispositivo',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  onPressed: () async {
                    this._selectedDevice = await _discoveryPage();

                    if (this._selectedDevice != null) {
                      BluetoothConnection.toAddress(
                              this._selectedDevice.address)
                          .then((_connection) {
                        print('Connected to the device');
                        connection = _connection;
                        print(connection == null ? 'yes' : 'no');
                        setState(() {
                          isConnecting = false;
                          isDisconnecting = false;
                        });
                      }).catchError((error) {
                        print('Cannot connect, exception occured');
                        print(error);
                      });
                      print(
                          'Discovery -> selected ${this._selectedDevice.name}');
                    } else {
                      print('Discovery -> no device selected');
                    }
                  },
                ),
              ),
              Divider(thickness: 1),
              ListTile(
                title: Text(
                  'PRUEBA DE SERVOMOTOR',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 8, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'c';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 1',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'd';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 2',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 16, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'e';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 3',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 8, 4),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'f';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 4',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'g';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 5',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 16, 4),
                      child: ElevatedButton(
                        onPressed: () {
                          fact = 'h';
                          _factSent();
                        },
                        child: Text(
                          'Prueba 6',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              ListTile(
                title: Text(
                  'MOSTRAR NOTIFICACIÓN',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  onPressed: () => _showNotifications(),
                  child: Text(
                    'Mostrar notificación',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  onPressed: () => _showNotificationsZoneSchedule(),
                  child: Text(
                    'Mostrar notificación con retraso de 5 segundos',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BluetoothDevice> _discoveryPage() async {
    return showDialog<BluetoothDevice>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DiscoveryPage(
          onSaved: () => setState(() {}),
        );
      },
    );
  }

  void _factSent() async {
    connection.output.add(
      utf8.encode(fact),
    );
    print('Dato $fact enviado');
    print(connection.output.isConnected);
    await connection.output.allSent;
    print(connection.output.allSent == null ? 'yes' : 'no');
  }
}
