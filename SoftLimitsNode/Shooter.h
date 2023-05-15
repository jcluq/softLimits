  // LED.h
#ifndef Shooter_h
#define Shooter_h

#include <Arduino.h>

class Shooter {
  private:
    int shooterSpeed;
    boolean isShooting;
    int shooterPin;

  public:
    Shooter(int pin);
    void runShooter(int sp);
    void stopShooter();
    boolean getState();
};

#endif
