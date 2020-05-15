#include "Arduino.h"
#include "Rover.h"

Rover::Rover(Motor &motorL, Motor &motorR): motorL(motorL), motorR(motorR) {
}

void Rover::translateXYtoSpeeds(int x, int y) {
  speedR = speedL = y;
  speedL += x;
  speedR -= x;
  speedL = constrain(speedL, -100, 100);
  speedR = constrain(speedR, -100, 100);
}

void Rover::move(int x, int y) {
  translateXYtoSpeeds(x, y);
#ifndef DEBUG_MODE
  motorL.move(speedL);
  motorR.move(speedR);
#endif
}
