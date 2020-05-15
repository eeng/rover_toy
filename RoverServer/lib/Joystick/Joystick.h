#ifndef Joystick_h
#define Joystick_h

class Joystick {
public:
  Joystick(int pinX, int pinY, int centerX, int centerY, int centerTolerance = 5);
  void readAxes();
  int x;
  int y;
private:
  int pinX;
  int pinY;
  int centerX;
  int centerY;
  int centerTolerance;
};

#endif
