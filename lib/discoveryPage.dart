import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'bluetoothDeviceListEntry.dart';

typedef SavedCallback = void Function();

class DiscoveryPage extends StatefulWidget {
  final bool start;
  final SavedCallback onSaved;

  DiscoveryPage({
    this.start = true,
    this.onSaved,
  });

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  @override
  void initState() {
    super.initState();

    this.isDiscovering = this.widget.start;
    if (this.isDiscovering) {
      this._startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      this.results.clear();
      this.isDiscovering = true;
    });

    this._startDiscovery();
  }

  void _startDiscovery() {
    this._streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      setState(() {
        this.results.add(result);
      });
    });

    this._streamSubscription.onDone(() {
      setState(() {
        this.isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    this._streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      titlePadding: EdgeInsets.all(0),
      title: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        title: Text(
          'Conectar dispositivo',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          this.isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).iconTheme.color),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.replay,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: this._restartDiscovery,
                ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 200,
        height: 200,
        child: ListView.builder(
          itemCount: this.results.length,
          itemBuilder: (context, index) {
            BluetoothDiscoveryResult result = results[index];
            return BluetoothDeviceListEntry(
              device: result.device,
              rssi: result.rssi,
              onTap: () async {
                try {
                  bool bonded = false;
                  if (!result.device.isBonded) {
                    bonded = await FlutterBluetoothSerial.instance
                        .bondDeviceAtAddress(result.device.address);
                  }

                  if (bonded || result.device.isBonded) {
                    widget.onSaved();
                    Navigator.of(context).pop(result.device);
                  }
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text('Ocurrio un error enlazando este dispositivo'),
                        content: Text('${error.toString()}'),
                        actions: <Widget>[
                          new FlatButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              widget.onSaved();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
