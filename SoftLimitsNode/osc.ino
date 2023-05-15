void onPacketOSC(AsyncUDPPacket packet) {
  if (LOCK_UDP_REICEIVER) { // lock from firmware flash process
    packet.flush();
    return; // do no shit!
  }
  OSCMessage msgIn;
  if ((packet.length() > 0)) {
    msgIn.fill(packet.data(), packet.length());
    packet.flush();
    if (!msgIn.hasError()) {
      //msgIn.route("/command", OSCcommand);
      msgIn.route("/direction", OSCchangeDirection);
      msgIn.route("/shooterSpeed", OSCupdateShooterSpeed);
      msgIn.route("/updatefirmware", OSCupdateFirmware);
      msgIn.route("/ufversionurl", OSCupdateFirmwareSetVersionURL);
      msgIn.route("/ufbinaryurl", OSCupdateFirmwareSetBinaryURL);
      msgIn.route("/home", OSChomming);
      msgIn.route("/goTo", OSCgoTo);
      msgIn.route("/jog", OSCjog);
      msgIn.route("/stopStepper", OSCstopStepper);
      msgIn.route("/servoAngle", OSCservoAngle);
      msgIn.route("/stepperSpeed", OSCstepperSpeed);
      

      packet.flush();
    }
  }
  packet.flush();
}

void OSCcommand(OSCMessage &msg, int addrOffset) {
  Serial.print("received parapmeters: ");
  Serial.println( msg.size());
  if (msg.size() == 3) {
    Serial.print("/command ");
    Serial.print(msg.getFloat(0));
    Serial.print(" ");
    Serial.print(msg.getInt(1));
    Serial.print(" ");
    Serial.println(msg.getFloat(2));
  }
}

void OSCchangeDirection(OSCMessage &msg, int addrOffset) {
  changeStepperDirection(msg.getInt(0));
}



void OSCupdateShooterSpeed(OSCMessage &msg, int addrOffset) {
  if (msg.size() == 1) {
    //Serial.print("/shooterSpeed ");
    Serial.print(msg.getInt(0));
    shooterSpeed = msg.getInt(0);
    
  }

}

void OSCupdateFirmware(OSCMessage &msg, int addrOffset) {
  Serial.print("/updatefirmware");
  char tmpstr[512];
  int retlength = msg.getString(0, tmpstr, 512);
  Serial.print(tmpstr);
  Serial.print(" ( ");
  Serial.print(retlength);
  Serial.println(" )");
  if (retlength > 20) {
    strncpy(URL_FW_VERSION, tmpstr, retlength);
    Serial.print("new URL_FW_VERSION = ");
    Serial.println(URL_FW_VERSION);
  }

    char tmpstrf[512];
  int retlengthf = msg.getString(1, tmpstrf, 512); // xxx.xxx.xxx.xxx = 15 + string ende char = 16
  Serial.print(tmpstrf);
  Serial.print(" ( ");
  Serial.print(retlengthf);
  Serial.println(" )");
  if (retlength > 20) {
    strncpy(URL_FW_BINARY, tmpstrf, retlengthf);
    Serial.print("new URL_FW_BINARY = ");
    Serial.println(URL_FW_BINARY);
  }

  

  UPDATE_FIRMWARE = true; // set the hook for the main loooooop
  // update procedure has to be initiated from the "main" loop other wise memory acces is limited.
}

void OSCupdateFirmwareSetVersionURL(OSCMessage &msg, int addrOffset) {
 
  char tmpstr[512];
  int retlength = msg.getString(0, tmpstr, 512);
  Serial.print(tmpstr);
  Serial.print(" ( ");
  Serial.print(retlength);
  Serial.println(" )");
  if (retlength > 20) {
    strncpy(URL_FW_VERSION, tmpstr, retlength);
    Serial.print("new URL_FW_VERSION = ");
    Serial.println(URL_FW_VERSION);
  }
}

void OSCupdateFirmwareSetBinaryURL(OSCMessage &msg, int addrOffset) {
  Serial.print(">> /ufbinaryurl ");
  char tmpstr[512];
  int retlength = msg.getString(0, tmpstr, 512); // xxx.xxx.xxx.xxx = 15 + string ende char = 16
  Serial.print(tmpstr);
  Serial.print(" ( ");
  Serial.print(retlength);
  Serial.println(" )");
  if (retlength > 20) {
    strncpy(URL_FW_BINARY, tmpstr, retlength);
    Serial.print("new URL_FW_BINARY = ");
    Serial.println(URL_FW_BINARY);
  }
}

void OSChomming(OSCMessage &msg, int addrOffset) {
  HOMING = true;
  //Serial.print("/home ");
}

void OSCgoTo(OSCMessage &msg, int addrOffset) {
   if (msg.size() == 1){
    //Serial.print("/goTo ");
    //Serial.println(msg.getInt(0));
   }
   Serial.println(msg.getInt(0));
   goTo(msg.getInt(0));
}

void OSCjog(OSCMessage &msg, int addrOffset) {
   jog();
}

void OSCstopStepper(OSCMessage &msg, int addrOffset) {
   
   stepper.stop();
   stopper = true;
}


void OSCservoAngle(OSCMessage &msg, int addrOffset) {
      if (msg.size() == 1){  
   servo.write((msg.getInt(0)));
      }
}

void OSCstepperSpeed(OSCMessage &msg, int addrOffset) {
      if (msg.size() == 1){
        stepperSpeed = msg.getInt(0);
        stepper.setSpeed(stepperSpeed * stepperDirection*microStep);
        Serial.println(stepperSpeed);
      }
 
}

void sendPingOSC() {
  int currpos = stepper.currentPosition();
  AsyncUDPMessage udpMsg;
  OSCMessage oscMsg("/ping");
  oscMsg.add(int(millis()));
  oscMsg.add(MY_NODE_ID);
  oscMsg.add(WiFi.localIP().toString().c_str());
  oscMsg.add(WiFi.macAddress().c_str());
  oscMsg.add(FW_VERSION);
  oscMsg.add(stepperRealPosition); // send some other data
  oscMsg.add(currpos);
  oscMsg.add(shooterSpeed);
  oscMsg.add(isJogging);
  oscMsg.send(udpMsg);
  oscMsg.empty();
  udpOut.broadcastTo(udpMsg, networkOutPort);

}
