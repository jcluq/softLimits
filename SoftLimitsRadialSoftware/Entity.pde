class Entity {
  int id;
  String ip;
  PVector pos;
  PVector end;
  PVector pivot;

  float angleSpeed;
  int shooterSpeed;
  int servoAngle;
  int stepperSpeed; 
  boolean collided = false;
  boolean dummy;

  boolean jogging;

  float angle = 0.01;
  float angledeg ;
  float angleStep;
  int dir;
  ArrayList<Neighbor> neighbors = new ArrayList<Neighbor>();
  EntityController entityController;
  
  Behaviour behaviour;



  Entity (int ide, int pX, int pY, boolean dum) {
    id = ide;
    pos = new PVector(pX, pY);
    end = new PVector(pX, pY);
    pivot = new PVector(pX, pY);
    angleSpeed = 0.10;
    stepperSpeed = 10;
    
    dummy = dum;
    entityController = new EntityController(this, id);
    shooterSpeed = 400;
  }
  
 

  void update() {
    if (!dummy) {
      angledeg = angleStep*(360/steps); // 0.72 is the ratio between 360 and 500
      float angleRadians = radians(angledeg+180);
      end.set(pos.x + sin(angleRadians) * scalar, pos.y + cos(angleRadians) * scalar);
      pivot.set(pos.x + sin(angleRadians) * (scalar - radius), pos.y + cos(angleRadians) * (scalar - radius));
      if (entityController.manualPos == false) {
        entityController.stepperKnob.changeValue(angleStep);
      }
    } else {
      
      angleSpeed = radians(behaviour.stepperSpeed*0.72/10)*behaviour.dir;
      angle = angle + angleSpeed;
      angledeg = abs(degrees(angle))%360;
      end.set(pos.x + sin(angle) * scalar, pos.y + cos(angle) * scalar);
      pivot.set(pos.x + sin(angle) * (scalar - radius), pos.y + cos(angle) * (scalar - radius));
      if (entityController.manualPos == false) {
        entityController.stepperKnob.changeValue(((degrees(angle)*(steps/360)*(angleSpeed/-angleSpeed)%steps)+steps)%steps);
      }
    }
    updateShooterSpeedFromBehaviour();
    updateServoAngleFromBehaviour();
    updateStepperSpeedFromBehaviour();
    updateDirectionFromBehaviour();
  }

  void updateShooterSpeedFromBehaviour(){
    if(shooterSpeed!=behaviour.shooterSpeed){
      shooterSpeed = behaviour.shooterSpeed;
      changeShooterSpeedMessage(ip, shooterSpeed);
    }
  }
  
  void updateServoAngleFromBehaviour(){
    if(servoAngle!=behaviour.servoAngle){
      servoAngle = behaviour.servoAngle;
      changeServoAngleMessage(ip,servoAngle);
  }
  }
  
  void updateStepperSpeedFromBehaviour(){
    if(stepperSpeed!=behaviour.stepperSpeed){
      stepperSpeed=behaviour.stepperSpeed;
      stepperSpeedMessage(ip,stepperSpeed);
    }
      
  }
  
  void updateDirectionFromBehaviour(){
    if(dir!=behaviour.dir){
      dir=behaviour.dir;
      changeDirectionMessage(ip,dir);
    }
    
  }
  


  void updateSpeed() {
    if (shooterSpeed!=entityController.shootingSpeed) {
      shooterSpeed = entityController.shootingSpeed;
      changeShooterSpeedMessage(ip, shooterSpeed);
    }
  }

  void updateServoAngle() {
    if (servoAngle!=entityController.servoAngle) {
      servoAngle = entityController.servoAngle;
      changeServoAngleMessage(ip, servoAngle);
    }
  }

  void goTo(int pos) {
    jogging = false;
    if (pos!=angleStep) {
      goToMessage(ip, pos);
    }
  }

  void jog() {
    jogMessage(ip);
  }

  void stopRotation() {
    stopStepperMessage(ip);
  }

  void home(){
    homeMessage(ip);
  }
  
  void updateFirmware(String address){
    updateMessage(ip,address);
  }
  
  void changeStepperSpeed(int ssp){
    stepperSpeed = ssp;
    stepperSpeedMessage(ip,stepperSpeed);
  }

  void display() {
    strokeWeight(3);
    if(behaviour!=null){
    
    stroke(behaviour.bcolor);
    fill(behaviour.bcolor);
    }
    else{
    fill(behaviour.bcolor);
    stroke(255);
    }
    line(pos.x, pos.y, end.x, end.y);   
    textSize(30);
    
    circle(pos.x,pos.y,20);
    //text(angleStep, end.x, end.y);
  }

  void displayPerimeter() {
    noFill();
     if(behaviour!=null){
    stroke(behaviour.bcolor);
    }
    else{
    stroke(255);
    }
    circle(pos.x, pos.y, scalar*2);
    stroke(255);
  }


  void displayCollisionCircle() {
    fill(0, 100);
    circle(pivot.x, pivot.y, radius*2);
  }


  void dispLines(int x, int y) {
    line(x, y, pos.x, pos.y);
  }


  void addNeighbors(Entity newEnt) {
    for (Neighbor n : neighbors) {
      if (n.enti == newEnt) {
        break;
      }
    }
    if ( dist(newEnt.pos.x, newEnt.pos.y, pos.x, pos.y)<scalar*2+radius && dist(newEnt.pos.x, newEnt.pos.y, pos.x, pos.y) !=0 ) {
      float ang = (-(atan2(pos.x - newEnt.pos.x, pos.y - newEnt.pos.y)* 180/ PI )+360)%360;
      Neighbor newNei = new Neighbor(newEnt, ang);
      neighbors.add(newNei);
    }
  }


  float getAngleDeg() {
    return(angle*180/PI)%360;
  }

  void checkCollisions() {
    if (neighbors.size()>0) {
      for (Neighbor ne : neighbors) {

        float distance = pivot.dist(ne.enti.pivot);

        if (distance <= radius*2&&!collided) {
          changeDirection();
          ne.enti.changeDirection();
        }
        if (distance > radius*2+5 && collided) {
          collided = false;
        }
      }
    }
  }






  void changeDirection() {
    println(this);
    collided = true;
    if (!dummy) {
      changeDirectionMessage(ip,dir);
    }
    if (dummy) {
      angleSpeed = -angleSpeed;
    }
  }

  void printNei() {
    if (neighbors.size()>0) {
      for (Neighbor nei : neighbors) {
        println(nei.enti.id);
      }
    }
  }
}
