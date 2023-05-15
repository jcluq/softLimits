class Neighbor{
  PVector pos;
  float angle;
  Entity enti;
  
  Neighbor(Entity ent, float a){
   enti = ent;
   angle = a;
   pos  = ent.pos;
   
  }
  
  
  
  
  
}

void drawNeighborLines(int ent){
   PVector posi = entities.get(ent).pos;
    if(mouseP.dist(posi)<limit){// && mouseP.dist(posi)<scalar*2){
      stroke(255,0,0);
      line(mouseP.x,mouseP.y,posi.x,posi.y);
      stroke(255);
    }
    if (mouseP.dist(posi)>limit && mouseP.dist(posi)<scalar*2){
      stroke(0,255,0);
      line(mouseP.x,mouseP.y,posi.x,posi.y);
      stroke(255);
    }
}
