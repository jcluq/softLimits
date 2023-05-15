import oscP5.*;
import netP5.*;
import controlP5.*;



OscP5 oscP5;
ControlP5 cp5;

boolean manualAdd = false;

int remotePort = 8888;
long lastsend = 0;



int lastMillis = millis();
int currentMillis = millis();
float deltaTime;

float scalar = 300;
float limit = scalar * 1.70;
float radius = (scalar * 2)-limit;

float steps = 500;
float stepsPerDegree = steps/360;

PVector mouseP;

ArrayList<Entity> entities = new ArrayList<Entity>();

CollisionManager cm;



void setup() {


  cp5 = new ControlP5( this );
  cm = new CollisionManager();
  gui();
  fullScreen();
  smooth();
  textSize(18);
  fill(0);
  mouseP = new PVector(mouseX, mouseY);

  for (int i=0; i<5; i++) {
    int tempangle = 360/5;
    int xRad = int(width/2 + sin(tempangle*(radians(i+1)))*scalar);
    int yRad = int(height/2 + cos(tempangle*(radians(i+1)))*scalar);
    
    Entity enti;
    if(i!=4){
     enti = new Entity(i, xRad, yRad, false);
    }
    else {
     enti = new Entity(i, xRad, yRad, false);
    }
    entities.add(enti);
  }

  behaviourCreator();
  assignBehaviours();




  PFont p = createFont("consolas", 15);
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);

  oscP5 = new OscP5(this, 9999);
  for (int i = 0; i<entities.size(); i++) {
    entities.get(i).jog();
  }
}

void draw() {
  background(0);
  mouseP.set(mouseX, mouseY);
  strokeWeight(3);
  stroke(255);
  currentMillis = millis();
  deltaTime = (currentMillis - lastMillis) / 1000.0;
  for (int i = 0; i<entities.size(); i++) {
    entities.get(i).display();
   // entities.get(i).displayCollisionCircle();
    entities.get(i).update();
   // entities.get(i).checkCollisions();
   // entities.get(i).displayPerimeter();


    if (manualAdd) {
      drawNeighborLines(i);
    }
  }
  if (entities.size()>0) {
    // entities.get(0).printNei();
    if (entities.get(0).neighbors.size()>0) {
      //println(entities.get(0).neighbors.get(0).angle);
    }
  }
  
  cm.checkCollisions();
}



void mouseReleased() {
  if (manualAdd == true&&mouseX>500&&mouseX<width-500) {
    if (entities.size()==0) {
      Entity enti = new Entity(0, mouseX, mouseY, true);
      entities.add(enti);
    } else {
      boolean valid = true;
      for (int i = 0; i<entities.size(); i++) {
        if ( dist(entities.get(i).pos.x, entities.get(i).pos.y, mouseX, mouseY)<limit) {
          valid = false;
        }
      }
      if (valid) {
        Entity newEnt = new Entity(entities.size(), mouseX, mouseY, true);
        entities.add(newEnt);
        for (Entity ents : entities) {
          ents.addNeighbors(newEnt);
          //ents.printNei();
        }
      }
    }
  }
}
