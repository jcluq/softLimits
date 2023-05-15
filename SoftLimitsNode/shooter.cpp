#include "Shooter.h"

Shooter::Shooter(int pin){
  isShooting = false;
  shooterSpeed = 350;
  shooterPin = pin;
  
      
}

void Shooter::runShooter(int sp){
    if(sp!=shooterSpeed)
      isShooting = true;
      analogWrite(shooterPin,sp);
      shooterSpeed = sp;
     
  }
  
void Shooter::stopShooter(){
    isShooting = false;
      analogWrite(shooterPin,0);
      
  }
  

boolean Shooter::getState(){
  return isShooting;
  
}
