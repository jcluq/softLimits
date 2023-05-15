class EntityController {
  int id;
  float value;
  int shootingSpeed = 400;
  controlP5.Group group;
  int relSize;
  
  controlP5.Slider shooterSlider;
  controlP5.Toggle stepperToggle;
  controlP5.Knob stepperKnob;
  controlP5.Slider servoSlider;
  controlP5.Slider stepperSpeedSlider;
  
  int stepperValue;
  int servoAngle;
  boolean manualPos = false;
  Entity entity;




  EntityController(Entity ent, int iden ) {
    entity = ent;
    id = iden;
    relSize=5;

    group = cp5
      .addGroup("Node"+id)
      .setWidth(500)
      .open()
      .setBarHeight(20)
      .setCaptionLabel("node "+id)
      //.setColorBackground(color(120))
      .setColorForeground(color(120))
      ;

    group.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);


       stepperToggle = cp5.addToggle("stepperToggle"+id)
      .setPosition(40, 135)
      .setLabelVisible(false)
      .plugTo(this, "manualPos")
      .moveTo(group);




    shooterSlider = cp5.addSlider("shootingSpeed"+id)
      .setPosition(120, 10)
      .moveTo(group)
      .setWidth(relSize*50)
      .setHeight(relSize*5)
      .setMin(360)
      .setMax(600)
      .plugTo(this, "shootingSpeed")
      .setLabel("ShootingSpeed");
      
    servoSlider = cp5.addSlider("servoAngle"+id)
      .setPosition(120, 40)
      .moveTo(group)
      .setWidth(relSize*50)
      .setHeight(relSize*5)
      .setMin(45)
      .setMax(110)
      .plugTo(this, "servoAngle")
      .setLabel("servoAngle");
      
      stepperSpeedSlider = cp5.addSlider("stepperSpeed"+id)
      .setPosition(120, 70)
      .moveTo(group)
      .setWidth(relSize*50)
      .setHeight(relSize*5)
      .setMin(0)
      .setMax(50)
      .plugTo(this, "stepperSpeed")
      .setLabel("stepperSpeed");

    stepperKnob =  cp5.addKnob("positionKnob"+id)
      .setViewStyle(2)
      .plugTo(this, "stepperValue")
      .setPosition(10, 10)
      .setSize(100, 100)
      .setRange(0, 500)
      .setAngleRange(6.2831853072)
      .setStartAngle(1.57079)
      .setColorBackground(color(100,100))
      .moveTo(group)
      .setLabel("stepper")
      .setConstrained(false)
      .setDecimalPrecision(1)
      .lock()
      .setId(id)
      ;

    
    
    
    
    stepperToggle.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
          stepperKnob.setLock(!manualPos);
         
          if(stepperKnob.isLock()){
          stepperKnob.setColorBackground(color(100,100));
          entity.jog();
          }
          else{
          stepperKnob.setColorBackground(cp5.getColor().getBackground());
          entity.stopRotation();
          }
        }
      }
    });




    nodeControls.addItem(group);
  }
}
