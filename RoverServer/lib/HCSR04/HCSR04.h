#ifndef HCSR04_h
#define HCSR04_h

class HCSR04 {
public:
  HCSR04(int trigPin, int echoPin);
  unsigned int readDistance();
private:
  int trigPin;
  int echoPin;
};

#endif
