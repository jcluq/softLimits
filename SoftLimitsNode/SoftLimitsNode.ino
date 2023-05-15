/*
   StringNode
    
   Code based in ralfs beacker boilerplate  
   https://github.com/rlfbckr/simple-node

*/

#include <ESP32Servo.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <HTTPUpdate.h>
#include "AsyncUDP.h"
#include "Shooter.h"


#include <Chrono.h>
#include <OSCBundle.h>
#include <EEPROM.h>
#include <AccelStepper.h>

#define EEPROM_SIZE 12
#define DIR_PIN 2
#define STEP_PIN 4
#define SH_PIN 33
#define M1_PIN 19
#define M2_PIN 18
#define M3_PIN 5
#define HOME_PIN 21
#define SERVO_PIN 14
#define CUR_PIN 32


int MY_NODE_ID = -1;

float FW_VERSION = 0.17; /// increment for next upload



//const char DEFAULT_URL_FW_VERSION[] = "http://192.168.0.113:8080/release/version.txt";
//const char  DEFAULT_URL_FW_BINARY[] = "http://192.168.0.113:8080/release/firmware.bin";

const char DEFAULT_URL_FW_VERSION[] = "http://192.168.4.100:8080/release/version.txt";
const char  DEFAULT_URL_FW_BINARY[] = "http://192.168.4.100:8080/release/firmware.bin";

boolean LOCK_UDP_REICEIVER = false; // lock UDP/OSC receiver to avoid shit while flashing a new firmware
char URL_FW_VERSION[512];
char URL_FW_BINARY[512];
boolean UPDATE_FIRMWARE = false; // hook in firmwareupdate

long pingInterval = 5; // every 2 seconds
int networkLocalPort = 8888;
int networkOutPort = 9999; // remote port to receive OSC

int stepNum = 500;
int microStep = 16;
int jogVal = 2000000;
int stepperSpeed = 10 * microStep;
int stepperDirection = 1;
int stepperRealPosition;

boolean HALL_SENSOR = false;
boolean isJogging = false;
int shooterSpeed = 450;

boolean HOMING = false;
boolean homingSet = false;
boolean stopper = false;



WiFiMulti wifiMulti;
Chrono pingTimer;
AsyncUDP udp;
AsyncUDP udpOut;
AccelStepper stepper(AccelStepper::DRIVER, STEP_PIN, DIR_PIN);
Servo servo;
Shooter shooter(SH_PIN);

void setup() {
  strncpy(URL_FW_VERSION, DEFAULT_URL_FW_VERSION, strlen(DEFAULT_URL_FW_VERSION));
  strncpy(URL_FW_BINARY, DEFAULT_URL_FW_BINARY, strlen(DEFAULT_URL_FW_BINARY));
  MY_NODE_ID = readNodeIDfromEEPROM();
  Serial.begin(115200);
  Serial.print("--> NODE  v:");
  Serial.println(FW_VERSION);
  initWIFI();
  initUDP();
  microStepSetup();
  
  servo.attach(SERVO_PIN);
  stepper.setMaxSpeed(1500);
  stepper.setCurrentPosition(0);
  stepper.setSpeed(stepperSpeed* stepperDirection*microStep);
  stepper.stop();

  servo.write(90);
  beginHomming();
  
}

void loop() {
  Serial.println(digitalRead(HOME_PIN));
  if (UPDATE_FIRMWARE) {
    if (getFirmwareVersionFromServer()) { // check if a new version is avaiable on the server
      updateFirmwareFromServer(); // get binary and flash it.
    }
    UPDATE_FIRMWARE = false; // update done
  }

  if (pingTimer.hasPassed(pingInterval)) {
    pingTimer.restart();
    sendPingOSC();
  }

  if (HOMING) {
    homingSequence();
      
    }
    
    


 // Serial.println(digitalRead(HOME_PIN));
 if(stopper){
  stepper.stop();
 }
 else {
  stepper.runSpeedToPosition();
 }
 //currentMeasurement();
  stepperRealPosition = (((stepper.currentPosition()/microStep)%stepNum)+stepNum)%stepNum;
  //stepper.setCurrentPosition(stepperRealPosition);
  shooter.runShooter(shooterSpeed);
  //Serial.println(((stepper.currentPosition()%stepNum)+stepNum)%stepNum);
}
