class CollisionManager {

  ArrayList<Collision> collisions;

  CollisionManager() {
    collisions = new ArrayList<Collision>();
  }


  void checkCollisions() {
    Entity collEnt2=null;
    Entity collEnt1=null;
    cleanCollisions();
    for (int i = 0; i<entities.size(); i++) {
      Entity ent1 = entities.get(i);
      for (int j = 0; j<entities.size(); j++) {
        Entity ent2 = entities.get(j);
        cleanCollisions();
        if (ent1!=ent2) {
          boolean collchecks = false;
          if(collisions.isEmpty()){
                collchecks=true;
                //println("reached");
              } else{
            for (int cls = 0; cls < collisions.size();cls++){
              
              if (!collisions.get(cls).checkMembers(ent1,ent2)){
                collchecks = true;
                
                println(collisions.size());
                break;
              }
            }
              }

          float uA = ((ent2.end.x-ent2.pos.x)*(ent1.pos.y-ent2.pos.y) - (ent2.end.y-ent2.pos.y)*(ent1.pos.x-ent2.pos.x)) / ((ent2.end.y-ent2.pos.y)*(ent1.end.x-ent1.pos.x) - (ent2.end.x-ent2.pos.x)*(ent1.end.y-ent1.pos.y));
          float uB = ((ent1.end.x-ent1.pos.x)*(ent1.pos.y-ent2.pos.y) - (ent1.end.y-ent1.pos.y)*(ent1.pos.x-ent2.pos.x)) / ((ent2.end.y-ent2.pos.y)*(ent1.end.x-ent1.pos.x) - (ent2.end.x-ent2.pos.x)*(ent1.end.y-ent1.pos.y));

          if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

            // optionally, draw a circle where the lines meet
            float intersectionX = ent1.pos.x + (uA * (ent1.end.x-ent1.pos.x));
            float intersectionY = ent1.pos.y + (uA * (ent1.end.y-ent1.pos.y));
            fill(255, 0, 0);
            noStroke();
            ellipse(intersectionX, intersectionY, 20, 20);
            if(collchecks==true){
              
            collEnt1 = entities.get(i);
            collEnt2 = entities.get(j);
            }
          }
        }
        
      }
    }
    if (collEnt1!=null&&collEnt2!=null) {
      addCollision(collEnt1, collEnt2);
    }
  }

  void addCollision(Entity ent1, Entity ent2) {
    if (collisions.size()<1) {
      collisions.add(new Collision(ent1, ent2));
      
    } else {
      int arraySize=collisions.size();
      for ( int cl = 0; cl<arraySize; cl++) {
        if (collisions.get(cl).checkMembers(ent1, ent2)) {
          collisions.add(new Collision(ent1, ent2));
          println(collisions.size());
          
        }
      }
    }
  
  for ( int c = 0; c<collisions.size(); c++) {
    if (!collisions.get(c).checkMembers(ent1, ent2)&&!collisions.get(c).tick) {
      collisions.get(c).mark();
      break;
    }
  }
  }




void cleanCollisions() {

  for ( int c = 0; c<collisions.size(); c++) {
    if (collisions.get(c).postCollision()) {
      collisions.remove(c);
      collisions.trimToSize();
    }
  }
}
}
