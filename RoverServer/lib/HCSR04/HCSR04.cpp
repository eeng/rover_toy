#include "Arduino.h"
#include "HCSR04.h"

HCSR04::HCSR04(int trigPin, int echoPin): trigPin(trigPin), echoPin(echoPin) {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

unsigned int HCSR04::readDistance() {
  digitalWrite(trigPin, HIGH);
  delay(1);
  digitalWrite(trigPin, LOW);
  unsigned int duration = pulseIn(echoPin, HIGH);
  return duration / 58.2;
}
