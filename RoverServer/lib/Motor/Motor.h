#ifndef Motor_h
#define Motor_h

class Motor {
public:
  Motor(int pinA, int pinB, int minimumSpeed = 0);
  void move(int speed);
private:
  int pinA;
  int pinB;
  int minimumSpeed;
};

#endif
