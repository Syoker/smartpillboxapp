import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    @required BluetoothDevice device,
    int rssi,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
    bool enabled = true,
  }) : super(
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          leading: Icon(
            Icons.bluetooth,
            color: rssi != null ? _computeColordBm(rssi) : Colors.white,
          ),
          title: Text(
            device.address.toString() == '00:19:12:BC:5B:92'
                ? 'Smart Pillbox'
                : device.name ?? 'Unknown device',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              device.isConnected
                  ? Icon(Icons.import_export)
                  : Container(width: 0, height: 0),
              device.isBonded
                  ? Icon(Icons.link)
                  : Container(width: 0, height: 0),
            ],
          ),
        );

  static Color _computeColordBm(int rssi) {
    if (rssi >= -35)
      return Colors.greenAccent[700];
    else if (rssi >= -45)
      return Color.lerp(
          Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10);
    else if (rssi >= -55)
      return Color.lerp(Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10);
    else if (rssi >= -65)
      return Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10);
    else if (rssi >= -75)
      return Color.lerp(
          Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10);
    else if (rssi >= -85)
      return Color.lerp(
          Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10);
    else
      return Colors.redAccent;
  }
}
