#include "Arduino.h"
#include "Motor.h"

Motor::Motor(int pinA, int pinB, int minimumSpeed): pinA(pinA), pinB(pinB), minimumSpeed(minimumSpeed) {
  pinMode(pinA, OUTPUT);
  pinMode(pinB, OUTPUT);
}

void Motor::move(int speed) {
  if (speed > 0) {
    analogWrite(pinA, map(speed, 0, 100, minimumSpeed, 255));
    digitalWrite(pinB, LOW);
  } else if (speed < 0) {
    digitalWrite(pinA, LOW);
    analogWrite(pinB, map(-speed, 0, 100, minimumSpeed, 255));
  } else {
    digitalWrite(pinA, LOW);
    digitalWrite(pinB, LOW);
  }
}
