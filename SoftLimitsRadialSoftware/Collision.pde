class Collision{
  
  ArrayList<Entity> members;
  boolean tick = false;
  int setTime;
  
  Collision(Entity ent1, Entity ent2){
    
    members = new ArrayList<Entity>() ;
    members.add(ent1);
    members.add(ent2);

  }
  
  
  boolean checkMembers(Entity member1, Entity member2){
    if(members.contains(member1) && members.contains(member2)){
      return false;
    }
    return true; 
    
  }
 
  void swap(){
    Behaviour temp = members.get(0).behaviour;
    members.get(0).behaviour = members.get(1).behaviour;
    members.get(1).behaviour = temp;
    //println("swap");
  }
  
  
  void mark(){
    //println("mark");
    tick = true;
    setTime = millis();
  }
  
  boolean postCollision(){
    if(millis()-setTime > 2000 && tick){
      swap();
      return true;
    }
    return false;
    
  
}
}
