#ifndef Rover_h
#define Rover_h

#include "Motor.h"

class Rover {
public:
  Rover(Motor &motorL, Motor &motorR);
  void move(int x, int y); // x and y should be between 0 and 255
  int speedL;
  int speedR;
private:
  Motor motorL;
  Motor motorR;
  void translateXYtoSpeeds(int x, int y);
};

#endif
