
  

void currentMeasurement(){
  float ACSValue = 0.0, Samples = 0.0, AvgACS = 0.0, BaseVol = 2.43; //Change BaseVol as per your reading in the first step.
  
float currentSensor;
for (int x = 0; x < 500; x++) { //This would take 500 Samples
    ACSValue = analogRead(CUR_PIN);
    Samples = Samples + ACSValue;
    
  }
  AvgACS = Samples/500;

  currentSensor = (((AvgACS) * (3.3 / 4095.0)) - BaseVol ) / 0.100 ;


  Serial.println(currentSensor);

}
