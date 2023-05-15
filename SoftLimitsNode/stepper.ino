void microStepSetup()
{
  pinMode(M1_PIN,OUTPUT);
  pinMode(M2_PIN,OUTPUT);
  pinMode(M3_PIN,OUTPUT);

  digitalWrite(M1_PIN,HIGH);
  digitalWrite(M2_PIN,HIGH);
  digitalWrite(M3_PIN,HIGH);
}




void changeStepperDirection(int dir) {
  stopper = false;
  stepper.stop();
  stepperDirection = dir;
  stepper.moveTo(jogVal * stepperDirection*microStep);
  stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
  Serial.println(stepperDirection);
}

void beginHomming(){
  HOMING = true;
  homingSet=false;
}

void homingSequence() {
  stopper = false;
   
  if (!homingSet) {
    stepper.stop();
    stepperDirection = 1;
    stepper.moveTo(jogVal * stepperDirection);
    stepper.setSpeed(10*microStep * stepperDirection);
    LOCK_UDP_REICEIVER = true;
    homingSet = true;
  }
  if (digitalRead(HOME_PIN)==0) {
    stepper.stop();
    stepper.setCurrentPosition(0);
    HOMING = false;
    homingSet = false;
    stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
    LOCK_UDP_REICEIVER = false;
    //jog();
  }
} 

void jog() {
  stopper = false;
  stepper.stop();
  stepper.moveTo(jogVal * stepperDirection);
  stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
  isJogging = true;
}

void goTo(int pos) {
  stopper = false;
  pos = pos*microStep;
  stepper.setCurrentPosition(stepperRealPosition*microStep);
  if (pos > stepper.currentPosition()) {
    if ((stepper.currentPosition() + stepNum - pos) < (pos - stepper.currentPosition())) {
      stepper.stop();
      stepperDirection = -1;
      stepper.moveTo(pos - stepNum - 1 );
      stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
    }  else {
      stepper.stop();
      stepperDirection = 1;
      stepper.moveTo(pos);
      stepper.setSpeed(stepperSpeed * stepperDirection*microStep);

    }
  }
    else {
      if ((stepNum + pos - stepper.currentPosition()) < (stepper.currentPosition() - pos)) {
        stepper.stop();
        stepperDirection = +1;
        stepper.moveTo(pos + stepNum - 1);
        stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
      }  else {
        stepper.stop();
        stepperDirection = -1;
        stepper.moveTo(pos);
        stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
      }
    }

    
    isJogging = false;
  }
