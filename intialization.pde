void initKinect()
{
  kinect = new SimpleOpenNI(this);
  if ( kinect.enableDepth() == false )
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }
  if (kinect.enableRGB() == false)
  {
    println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
    exit();
    return;
  }
  kinect.enableUser();
  kinect.setMirror(true);
  //kinect.setSmoothingHand(6);
}

void initServo()
{
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  arduino.pinMode(2, Arduino.SERVO);
  arduino.pinMode(3, Arduino.SERVO);
  arduino.pinMode(4, Arduino.SERVO);
  arduino.pinMode(5, Arduino.SERVO);
  arduino.pinMode(6, Arduino.SERVO);
  arduino.pinMode(7, Arduino.SERVO);
  arduino.pinMode(8, Arduino.SERVO);
  arduino.pinMode(9, Arduino.SERVO);

  //Servoinit(); 
}

void Servoinit()
{
  arduino.servoWrite(2,0);
  arduino.servoWrite(3,90);   // Right Hand
  arduino.servoWrite(4,90);
  arduino.servoWrite(5,0);
  
  arduino.servoWrite(6,180);
  arduino.servoWrite(7,90);   // Left Hand
  arduino.servoWrite(8,115);
  arduino.servoWrite(9,180);
}
void Servoinit(int a,int b,int c,int d)
{
  arduino.servoWrite(2,a);
  arduino.servoWrite(3,b);   // Right Hand
  arduino.servoWrite(4,c);
  arduino.servoWrite(5,d); 
}

void initControl()
{
  cp5 = new ControlP5(this);
  
  cp5.addSlider("sliderq").setPosition(645,0).setSize(200,20).setRange(0.1,1).setValue(0.1);
  //cp5.addSlider("sliderR").setPosition(645,25).setSize(200,20).setRange(1,180).setValue(10);
  cp5.addSlider("sliderR").setPosition(645,25).setSize(200,20).setRange(0,180).setValue(0);
  cp5.addSlider("slidera").setPosition(645,50).setSize(200,20).setRange(1,10).setValue(1);
  cp5.addSlider("sliderh").setPosition(645,75).setSize(200,20).setRange(1,10).setValue(1);
  //------button config.......
  cp5.addButton("RGB_Depth").setPosition(645,100).setSize(50,50).setValue(0);
  cp5.addButton("AutoCal").setPosition(645,160).setSize(50,50).setValue(0);
  cp5.addButton("Measure").setPosition(645,220).setSize(50,50).setValue(0);
    
  cp5.addTextfield("in1").setPosition(645,270).setSize(200,40).setFocus(true).setColor(color(255,0,0));
  cp5.addTextfield("in2").setPosition(645,310).setSize(200,40).setFocus(true).setColor(color(255,0,0));
  cp5.addTextfield("in3").setPosition(645,350).setSize(200,40).setFocus(true).setColor(color(255,0,0));
  cp5.addTextfield("in4").setPosition(645,390).setSize(200,40).setFocus(true).setColor(color(255,0,0));

}
