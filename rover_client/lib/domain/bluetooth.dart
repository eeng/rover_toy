import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

enum BluetoothStatus { unavailable, disconnected, connecting, connected }

typedef StatusChangedCallback = void Function(BluetoothStatus status);
typedef MessageReceivedCallback = void Function(String message);

class Bluetooth {
  FlutterBluetoothSerial bts = FlutterBluetoothSerial.instance;
  BluetoothStatus status = BluetoothStatus.disconnected;
  List<StatusChangedCallback> statusChangeListeners = [];
  List<MessageReceivedCallback> messageReceivedListeners = [];
  String receivedSoFar = '';

  Bluetooth() {
    getDevices(); // To get initial status
    _listenToDeviceNotifications();
    _listenToDeviceMessages();
  }

  Future<List<BluetoothDevice>> getDevices() async {
    try {
      List<BluetoothDevice> devices = await bts.getBondedDevices();
      print('Bluetooth devices found: ${devices.length}');
      devices.forEach((d) => print(
          'Name: ${d.name}, Address: ${d.address}, Connected: ${d.connected}'));
      return devices;
    } catch (error) {
      if (error.code == 'bluetooth_unavailable')
        _changeStatus(BluetoothStatus.unavailable);
      else
        throw error;
      return [];
    }
  }

  void _listenToDeviceNotifications() {
    bts.onStateChanged().listen((state) {
      print('State changed: $state');
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          _changeStatus(BluetoothStatus.connected);
          break;
        case FlutterBluetoothSerial.DISCONNECTED:
          _changeStatus(BluetoothStatus.disconnected);
          break;
        default:
      }
    });
  }

  void _listenToDeviceMessages() {
    bts.onRead().listen((msg) {
      msg.runes.forEach((r) {
        var character = String.fromCharCode(r);
        if (character == "\n") {
          _notifyMessageReceived(receivedSoFar);
          receivedSoFar = '';
        } else
          receivedSoFar += character;
      });
    });
  }

  Future connect(BluetoothDevice device) async {
    try {
      _changeStatus(BluetoothStatus.connecting);
      await bts.connect(device);
      _changeStatus(BluetoothStatus.connected);
    } catch (error) {
      if (error.message == 'already connected')
        _changeStatus(BluetoothStatus.connected);
      else {
        _changeStatus(BluetoothStatus.disconnected);
        throw error;
      }
    }
  }

  Future disconnect() {
    _changeStatus(BluetoothStatus.disconnected);
    return bts.disconnect();
  }

  void _changeStatus(status) {
    this.status = status;
    print('Bluetooth status: $status');
    statusChangeListeners.forEach((listener) => listener(status));
  }

  StatusChangedCallback onStatusChanged(StatusChangedCallback listener) {
    statusChangeListeners.add(listener);
    _changeStatus(status); // Notify initial status;
    return listener;
  }

  void unlistenToStatusChanged(StatusChangedCallback listener) {
    statusChangeListeners.remove(listener);
  }

  MessageReceivedCallback onMessage(MessageReceivedCallback listener) {
    messageReceivedListeners.add(listener);
    return listener;
  }

  void unlistenToMessages(MessageReceivedCallback listener) {
    messageReceivedListeners.remove(listener);
  }

  void _notifyMessageReceived(String message) =>
      messageReceivedListeners.forEach((listener) => listener(message));

  void send(String message) async {
    try {
      if (status == BluetoothStatus.connected) await bts.write(message);
    } catch (error) {
      print('Error sending $error');
    }
  }

  void moveRover(int x, int y) => send('>$x,$y\n');
}
