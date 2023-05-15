Accordion nodeControls;
Group generalControl;
Toggle generalStepControl;
boolean generalST = false;
Knob generalSK;
Textfield ipAddress;


void gui() {

  nodeControls = cp5.addAccordion("acc")
    .setPosition(0, 0)
    .setWidth(500)
    .setCollapseMode(Accordion.MULTI)
    .setMinItemHeight(height/7);




  generalControl = cp5.addGroup("general")
    .setPosition(width-500,20)
    .setWidth(500)
    .setBarHeight(20);
    
   cp5.addBang("home")
     .moveTo(generalControl)
     .setPosition(10,10);
     
     cp5.addToggle("Dummies")
     .moveTo(generalControl)
     .setPosition(100,10);
     
     cp5.addBang("Update")
     .moveTo(generalControl)
     .setPosition(200,10);
     
     ipAddress = cp5.addTextfield("ipdir")
     .moveTo(generalControl)
     .setPosition(300,10)
     .setWidth(150)
     .setValue("192.168.1.2");
     
    cp5.addSlider("steppersSpeed")
      .setPosition(10, 70)
      .moveTo(generalControl)
      .setWidth(250)
      .setHeight(25)
      .setMin(0)
      .setMax(50)
      //.plugTo(this, "stepperSpeed")
      .setLabel("steppersSpeed");
      
      cp5.addSlider("shootersSpeed")
      .setPosition(10, 100)
      .moveTo(generalControl)
      .setWidth(250)
      .setHeight(25)
      .setMin(350)
      .setMax(600)
      //.plugTo(this, "stepperSpeed")
      .setLabel("shootersSpeed");
      
      cp5.addSlider("shootersAngle")
      .setPosition(10, 130)
      .moveTo(generalControl)
      .setWidth(250)
      .setHeight(25)
      .setMin(45)
      .setMax(110)
      //.plugTo(this, "stepperSpeed")
      .setLabel("servoAngles");
      
      generalSK=cp5.addKnob("positionsKnobGen")
      .setViewStyle(2)
     
      .setPosition(125, 200)
      .setSize(200, 200)
      .setRange(0, 500)
      .setAngleRange(6.2831853072)
      .setStartAngle(1.57079)
      .setColorBackground(color(100,100))
      .moveTo(generalControl)
      .setLabel("stepper")
      .setConstrained(false)
      .setDecimalPrecision(1)
      .lock()     
      ;
      
      generalStepControl = cp5.addToggle("generalStepperControl")
      .moveTo(generalControl)
      .setPosition(210,430)
      .setLabelVisible(false)
      .plugTo(this, "generalST")

      ;
      
      
       generalStepControl.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
          generalSK.setLock(!generalST);
         
          if(generalSK.isLock()){
          generalSK.setColorBackground(color(100,100));
          for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.entityController.stepperToggle.setValue(0);
          }
          }
          else{
          generalSK.setColorBackground(cp5.getColor().getBackground());
           for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.entityController.stepperToggle.setValue(1);
          }
          //entity.stopRotation();
          }
        }
      }
    });

}


void controlEvent( ControlEvent ce) {
  println(ce);
  if (ce.getName().contains("positionKnob")) {
    int newP = int((((ce.getValue()%steps)+steps)%steps));
    ce.getController().changeValue(newP);
    entities.get(ce.getId()).goTo(newP);
  }
  
  if (ce.getName()=="Dummies") {
    if(ce.getValue()==1.0){
      manualAdd=true;
    }else{
      manualAdd=false;
    }
  }
  if (ce.getName()=="positionsKnobGen"){
    println("check");
    for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.entityController.stepperKnob.setValue(ce.getValue());
          }
  }
  
  if (ce.getName()=="shootersAngle"){
     int newP = int((((ce.getValue()%steps)+steps)%steps));
    ce.getController().changeValue(newP);
    println("check");
    for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.entityController.servoSlider.setValue(ce.getValue());
          }
  }
  
   if (ce.getName()=="home"){
    println("homeButton");
    for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.home();
          }
  }
  
   if (ce.getName()=="Update"){
    println("UpdateButton");
    String address = ipAddress.getText();
  
    for(int i = 0;i<entities.size();i++){
            Entity e = entities.get(i);
            e.updateFirmware(address);
          }
  }

 
}
