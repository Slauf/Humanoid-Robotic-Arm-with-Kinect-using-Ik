int [] sensors = new int [4];
int [] min = new int [4];
int [] max = new int [4];

boolean autoFlag = false;
boolean meFlag = false;


int [] Feedback()
{
  for (int i = 0; i <= 3; i++) 
  {
    sensors[i] = (int) map(arduino.analogRead(i),min[i],max[i],0,180);
    //sensors[2] = (int) map(sensors[2],0,180,180,0);
  }
  
  return sensors ;
}

void ServoTestFeed(int a, int b, int c, int d)
{
  //int begin = 0;
  //int end = 0;
  //begin = millis();
  arduino.servoWrite(2,a);
  arduino.servoWrite(3,b);   // Right Hand
  arduino.servoWrite(4,c);
  arduino.servoWrite(5,d);
     
   while (sensors[0] != a && sensors[1] != b && sensors[2] != c && sensors[3] != d)
    {
      Feedback();
      println(sensors[0] +"  "+ sensors[1] +"  "+ sensors[2] +"  "+ sensors[3]);     //println(a+"   "+h+"   "+R+"   "+Q);
    }
    
   //end = millis();
   //println(end - begin);
  
}


public void autoCalibrate()
{
    arduino.servoWrite(2,0);            //Right hand Servo1
      delay(1000);
      min[0] = arduino.analogRead(0);
    
    arduino.servoWrite(2,180);
      delay(1000);
      max[0] = arduino.analogRead(0);     
  //---------------------------------------// 
    arduino.servoWrite(3,180);
      delay(1000);
      max[1] = arduino.analogRead(1);
      
    arduino.servoWrite(3,90);         //Right hand Servo2
      delay(1000);
      min[1] = arduino.analogRead(1);
      min[1] -= max[1] - min[1] ;
  //---------------------------------------// 
    arduino.servoWrite(4,0);            //Right hand Servo3
      delay(1000);
      min[2] = arduino.analogRead(2);
    
    arduino.servoWrite(4,180);
      delay(1000);
      max[2] = arduino.analogRead(2);
  //---------------------------------------// 
    arduino.servoWrite(5,90);
      delay(1000);
      max[3] = arduino.analogRead(3);
      
    arduino.servoWrite(5,0);         //Right hand Servo4
      delay(1000);
      min[3] = arduino.analogRead(3);
      max[3] += max[3] - min[3] ;
  //---------------------------------------// 
  
   for(int i=0;i<=3;i++)
     println(min[i] +"   "+ max[i]);
 
 Servoinit();
}
