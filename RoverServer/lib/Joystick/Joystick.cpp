#include "Arduino.h"
#include "Joystick.h"

Joystick::Joystick(int pinX, int pinY, int centerX, int centerY, int centerTolerance):
  pinX(pinX), pinY(pinY), centerX(centerX), centerY(centerY), centerTolerance(centerTolerance)
{
}

// Reads a joystick axis and translate the coordinate to a -255 to 255 value, with 0 as the center
int readAxis(int pin, int centerPos, int centerTolerance) {
  int pos = analogRead(pin);
  if (pos < centerPos - centerTolerance)
    return -map(pos, centerPos - centerTolerance, 0, 0, 255);
  else if (pos > centerPos + centerTolerance)
    return map(pos, centerPos + centerTolerance, 1023, 0, 255);
  else
    return 0;
}

void Joystick::readAxes() {
  x = readAxis(pinX, centerX, centerTolerance);
  y = readAxis(pinY, centerY, centerTolerance);
}
