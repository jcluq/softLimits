void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/ping") == true) {
    int id = theOscMessage.get(1).intValue();
    String ip = theOscMessage.get(2).stringValue();
    String mac = theOscMessage.get(3).stringValue();
    float fw_version = theOscMessage.get(4).floatValue();
    int stepperPosition = theOscMessage.get(5).intValue();
    int realPosition = theOscMessage.get(6).intValue();
    int shooterSpeed = theOscMessage.get(7).intValue();
    
    
    println("got a ping from:");
    println(" id         : "+id);
    //println(" ip         : "+ip);
    //println(" mac        : "+mac);
    println(" fw_version : "+fw_version);
    println(" rotation   : "+stepperPosition);
    println(" stepperPos   : "+realPosition);
    println(" shooterSpeed      : "+shooterSpeed);
    //println(" isJogging      : "+isJogging);
    //remoteIP = ip; // we send some stuff back
    for (Entity e : entities){
      if(e.id == id){
        e.angleStep=stepperPosition;
        e.ip = ip;
        
      }
    }
  } else {
    print("### received an osc message.");
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());
  }
}

void changeDirectionMessage(String ip, int dir){
 OscMessage myMessage = new OscMessage("/direction");
  myMessage.add(dir);
  
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
}

void changeShooterSpeedMessage(String ip,int sp){
  OscMessage myMessage = new OscMessage("/shooterSpeed");
  myMessage.add(sp);
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
}


void jogMessage(String ip){
  OscMessage myMessage = new OscMessage("/jog");
  
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  println("jog");
}

void goToMessage(String ip,int pos){
  OscMessage myMessage = new OscMessage("/goTo");
  myMessage.add(pos);
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
}

void stopStepperMessage(String ip){
  OscMessage myMessage = new OscMessage("/stopStepper");
   NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  println("stop");
}

void changeServoAngleMessage(String ip, int angle){
  
  OscMessage myMessage = new OscMessage("/servoAngle");
  myMessage.add(angle);
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  
}

void homeMessage(String ip){
  OscMessage myMessage = new OscMessage("/home");
   NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  println("stop");
}

void updateMessage(String ip, String address){
    String version = "http://"+address+":8080/release/version.txt";
    String firmware = "http://"+address+":8080/release/firmware.bin";
    
  OscMessage myMessage = new OscMessage("/updatefirmware");
  myMessage.add(version);
  myMessage.add(firmware);
   NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  println("firmware update" + version + firmware );
}

void stepperSpeedMessage(String ip, int ssp){
   OscMessage myMessage = new OscMessage("/stepperSpeed");
  myMessage.add(ssp);
  NetAddress myRemoteLocation= new NetAddress(ip, remotePort);
  oscP5.send(myMessage, myRemoteLocation);
  
}
