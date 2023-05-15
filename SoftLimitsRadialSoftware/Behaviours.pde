class Behaviour{
  int id;
  int servoAngle;
  int shooterSpeed;
  int stepperSpeed;
  color bcolor;
  int dir;
  
  
  Behaviour(int ide,int sa, int ss, int sts, color bc, int di){
  
    id = ide;
    servoAngle = sa;
    shooterSpeed = ss;
    stepperSpeed = sts;
    bcolor = bc;
    dir = di;

}
}




ArrayList<Behaviour> behaviours = new ArrayList<Behaviour>();

void behaviourCreator(){
  
  Behaviour bA = new Behaviour(0,90,600,10,#987284,-1);
  behaviours.add(bA);
  Behaviour bB = new Behaviour(1,80,600,6,#037971,1);
  behaviours.add(bB);
  Behaviour bC = new Behaviour(2,85,600,7,#BEB7A4,1);
  behaviours.add(bC);
  Behaviour bD = new Behaviour(3,95,600,9,#FF7F11,-1);
  behaviours.add(bD);
  Behaviour bE = new Behaviour(4,90,600,20,#114B5F,1);
  behaviours.add(bE);
  
  
}

void assignBehaviours(){
  for(int i = 0; i<entities.size(); i++){
    entities.get(i).behaviour = behaviours.get(i);
  }
}
