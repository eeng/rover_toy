import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../domain/bluetooth.dart';

class BluetoothButton extends StatefulWidget {
  final Bluetooth bluetooth;
  final void Function(String sensor, String value) onSensorValueReceived;
  final void Function() onDeviceDisconnected;

  BluetoothButton({
    @required this.bluetooth,
    this.onSensorValueReceived,
    this.onDeviceDisconnected,
  });

  @override
  BluetoothButtonState createState() => BluetoothButtonState();
}

class BluetoothButtonState extends State<BluetoothButton> {
  BluetoothStatus _status = BluetoothStatus.disconnected;
  List<BluetoothDevice> _devices = [];
  StatusChangedCallback _statusChangedListener;
  MessageReceivedCallback _messageReceivedListener;

  alert(msg) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  _connect(device) {
    widget.bluetooth
        .connect(device)
        .catchError((error) => alert('Error connecting: ${error.message}'));
  }

  _disconnect() {
    widget.bluetooth
        .disconnect()
        .catchError((error) => alert('Error disconnecting: ${error.message}'));
  }

  _showDevices() async {
    widget.bluetooth // Reload the devices just in case a new one appear
        .getDevices()
        .then((devices) => setState(() => _devices = devices));
    var device = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: Text('Select device'),
          children: _devices.map((device) {
            return new SimpleDialogOption(
              onPressed: () => Navigator.pop(context, device),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7.0),
                child: Text(device.name),
              ),
            );
          }).toList(),
        );
      },
    );
    if (device != null) _connect(device);
  }

  void parseMessage(String message) {
    var parts = message.split("|");
    if (parts.first == 'S' && parts.length == 3)
      widget.onSensorValueReceived(parts[1], parts[2]);
    else
      alert(message);
  }

  @override
  void initState() {
    _statusChangedListener = widget.bluetooth.onStatusChanged((status) {
      setState(() => _status = status);
      if (status == BluetoothStatus.disconnected) widget.onDeviceDisconnected();
    });
    _messageReceivedListener = widget.bluetooth.onMessage(parseMessage);
    super.initState();
  }

  @override
  void dispose() {
    widget.bluetooth.unlistenToStatusChanged(_statusChangedListener);
    widget.bluetooth.unlistenToMessages(_messageReceivedListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _status == BluetoothStatus.connected
            ? Icons.bluetooth_connected
            : _status == BluetoothStatus.unavailable
                ? Icons.bluetooth_disabled
                : Icons.bluetooth,
        color:
            _status == BluetoothStatus.connected ? Colors.blue : Colors.white,
      ),
      onPressed:
          _status == BluetoothStatus.connected ? _disconnect : _showDevices,
    );
  }
}
