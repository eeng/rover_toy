#include "Arduino.h"
#include "SoftwareSerial.h"
#include "Joystick.h"
#include "Rover.h"
#include "HCSR04.h"
#include "Utils.h"

const int btStatePin = 2;

Joystick joystick(A0, A1, 504, 527);
SoftwareSerial bt(3, 4);
Motor motorL(5, 6, 45);
Motor motorR(10, 11, 45);
Rover rover(motorL, motorR);
HCSR04 distanceSensor(8, 9);

int x = 0, y = 0;
bool btConnected, btWasConnected;
unsigned int distance;

void setup() {
  Serial.begin(9600);
  bt.begin(38400);
  bt.setTimeout(10);
}

void logState() {
  runEvery(500, millis()) {
    debug("BT %d\tPos (%d, %d)\tSpeed (%d, %d)\tDist %d\n", btConnected, x, y, rover.speedL, rover.speedR, distance);
  }
}

void readPositionFromLocalJoystick() {
  joystick.readAxes();
  x = joystick.x;
  y = joystick.y;
}

bool readPositionFromSerial(Stream &serial) {
  while (serial.available()) {
    String msg = serial.readStringUntil('\n');
    if (msg.indexOf('>') == msg.lastIndexOf('>')) {
      x = msg.substring(msg.indexOf('>') + 1, msg.indexOf(',')).toInt();
      y = msg.substring(msg.indexOf(',') + 1, msg.length()).toInt();
    } else {
      Serial.print("Discarding message: ");
      Serial.println(msg);
    }
    return true;
  }
  return false;
}

bool readPositionFromBluetooth() {
  btConnected = digitalRead(btStatePin);
  if (btConnected) {
    if (!btWasConnected) {
      btWasConnected = true;
      bt.println("Connected!");
    }
    return readPositionFromSerial(bt);
  } else if (btWasConnected) {
    x = y = 0; // Make sure we stop the robot if bt is disconnected
    btWasConnected = false;
    return true;
  } else
    return false;
}

void readAndSendSensorData() {
  runEvery(1000, millis()) {
    distance = distanceSensor.readDistance();
    if (btConnected) {
      bt.print("S|Distance|");
      bt.println(distance);
    }
  }
}

void loop() {
  bool incomingData = readPositionFromSerial(Serial);
  incomingData |= readPositionFromBluetooth();
  rover.move(x, y);

  readAndSendSensorData();

  logState();
}
