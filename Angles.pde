import SimpleOpenNI.*;
import cc.arduino.*;
import controlP5.*;
import processing.serial.*;

SimpleOpenNI kinect;
Arduino arduino;
ControlP5 cp5;

PVector shoulder = new PVector();
PVector elbow = new PVector();
PVector hand = new PVector();

     //-----Sliders.......
float slidera,sliderh,sliderR,sliderq;
boolean  screenFlag = true;

Kalman QR0 = new Kalman();
Kalman QR1 = new Kalman();
Kalman QR2 = new Kalman();
Kalman QR3 = new Kalman();
Kalman QL0 = new Kalman();
Kalman QL1 = new Kalman();
Kalman QL2 = new Kalman();
Kalman QL3 = new Kalman();

void setup() 
{ 
  size(1000, 680);
  textSize(32);
  
  //------Kinect config.......   
  initKinect();
  
  //------Arduino config.......   
  initServo();
 
  //------Slider config....... 
  initControl();
  
  //-----Graph....... 
  smooth();
}

void draw() 
{
   background(127,127,127);
    kinect.update();
    
    if(screenFlag)
        image(kinect.depthImage(),0,0);
     else 
        image(kinect.rgbImage(),0,0);
        
       // Feedback();
        //Drawgraph(180,sensors[0]);
        
    //arduino.servoWrite(5,(int)sliderR);   // for Manual Testing
    //Feedback() ;
    //println(sensors[0] +"  "+ sensors[1] +"  "+ sensors[2] +"  "+ sensors[3]);
    
    IntVector userList = new IntVector();
    kinect.getUsers(userList);
    //---------------------------------------------------------
    
    if (userList.size() > 0)
    {
      int userId = userList.get(0);
  
      if ( kinect.isTrackingSkeleton(userId))
        {
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, shoulder);
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, elbow);
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, hand);
            SendRight( CalAngles(shoulder,elbow, hand) ); 
            
            kinect.getJointPositionSkeleton(userId ,SimpleOpenNI.SKEL_LEFT_SHOULDER, shoulder);
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, elbow);
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, hand);
            SendLeft( CalAngles(shoulder,elbow, hand) );

                 //------Drawing-----
            Draw(userId);     
      }
    }
}

void Draw(int userId)
{
  strokeWeight(1);
  stroke(0,0,0);
              // right hand
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
              // left hand
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
    
    /* 
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
    
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
    
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    
    */
}

float [ ] CalAngles(PVector Shoulder, PVector Elbwo, PVector hand)
{
     float [ ] temp = new float [4];
     
     //-----calculate difference by subtracting one vector from another...... 
     
     //Shoulder.x = Shoulder.x + 30;
     //Shoulder.z = Shoulder.z + 0.15;
     PVector l1  = PVector.sub(Elbwo , Shoulder);
    
     PVector l2 = PVector.sub(hand , Elbwo);
     
     PVector tg = PVector.sub(hand , Shoulder);

     temp[0]  = map( asin(l1.y / sqrt( sq(l1.x)+ sq(l1.y)+ sq(l1.z) ) ) ,-PI/2,PI/2,0,180 ) ; //J1 servo A                             //temp[0]  = asin(l1.x/(sin( temp[1] )*a1));
     temp[1]  = map( asin(l1.x / sqrt( sq(l1.x)+ sq(l1.y) +sq(l1.z) ) ) ,-PI/2,PI/2,0,180 ) ; // Tn servo B                            //temp[1]  = acos(-l1.y / a1);
     temp[2]  = map( asin(l2.x / sqrt( sq(l2.x)+ sq(l2.y) +sq(l2.z) ) ) ,-PI/2,PI/2,0,180 ) ; // J1 servo C                            //temp[2]  = acos((tg.y + cos( temp[1] )*(a1+cos(temp[3])))/(a2*sin( temp[1] )*sin(temp[3])));
     temp[3]  = map( acos( (sq(tg.mag()) - sq(l1.mag()) - sq(l2.mag()) ) / (2*l1.mag()*l2.mag()) ) ,0,PI,0,180) ; // Tn servo D        //temp[3]  = map( asin(l2.y / sqrt( sq(l2.x)+ sq(l2.y)+ sq(l2.z) ) ) ,-PI/2,PI/2,0,180 ) ; // J1 servo C     

     //temp[2] += 180 - temp[1];
     //temp[1] += -20; 
            
     return temp;
}


void SendRight(float [ ]angles)
{
            //----for the right hand.....
      float e = angles[0];
      angles[0] = QR0.Kalmanfilter(angles[0]) ;
      angles[1] = QR1.Kalmanfilter(angles[1]) ;
      angles[2] = QR2.Kalmanfilter(angles[2]) ;
      angles[3] = QR3.Kalmanfilter(angles[3]) ;
      
     arduino.servoWrite(2,(int) angles[0]);
     arduino.servoWrite(3,(int) angles[1]);  
     arduino.servoWrite(4,(int) map(angles[2],0,180,180,0) ); 
     arduino.servoWrite(5,(int) angles[3]);

      text("Q1   " + angles[0], 10, 30); 
      text("Q2   " + angles[1], 10, 60);
      text("Q3   " + angles[2], 10, 90);
      text("Q4   " + angles[3], 10, 120);
     
     
      //Q1.var(slidera,sliderh,sliderR,sliderq);
      //Feedback();
      //Drawgraph(angles[0],sensors[0]);
}

void SendLeft(float [ ]angles)
{
            //----for the left hand.....
      angles[0] = QL0.Kalmanfilter(angles[0]) ;
      angles[1] = QL1.Kalmanfilter(angles[1]) ;
      angles[2] = QL2.Kalmanfilter(angles[2]) ;
      angles[3] = QL3.Kalmanfilter(angles[3]) ;
      
      arduino.servoWrite(6,(int) map(angles[0],0,180,180,0)); 
      arduino.servoWrite(7,(int) angles[1]);  
      arduino.servoWrite(8,(int) map(angles[2] -25,0,180,180,0)); // 20 for miss calibration
      arduino.servoWrite(9,(int) map(angles[3],0,180,180,0));

      text("Q1   " + angles[0], 400, 30);
      text("Q2   " + map(angles[1],0,180,180,0), 400, 60);   
      text("Q3   " + map(angles[2],0,180,180,0), 400, 90); 
      text("Q4   " + angles[3], 400, 120);
      
      //Q1.var(slidera,sliderh,sliderR,sliderq);
      //Drawgraph(angles[2],angles[0]);
}



// user-tracking callbacks!
void onNewUser(SimpleOpenNI curContext, int userId )
{
  println("start pose detection");
  kinect.startTrackingSkeleton(userId);
}

void onEndCalibration(int userId, boolean successful)
{
  if (successful)
  {
      println(" User calibrated !!!");
      kinect.startTrackingSkeleton(userId);
   }
  else 
  {
      println(" Failed to calibrate user !!!");
      kinect.startTrackingSkeleton(userId);
   }
}

void onStartPose(String pose, int userId)
{
  println("Started pose for user");
  kinect.startTrackingSkeleton(userId);
}

void keyPressed()
{
  if(key == ' ')
    {
      if(screenFlag)
         screenFlag = false;
      else 
         screenFlag = true;
    }
}

void sliderq(float q) 
{ sliderq = q; }
void sliderR(float r) 
{ sliderR = r; }
void slidera(float a) 
{ slidera = a; }
void sliderh(float h) 
{ sliderh = h; }
void RGB_Depth(int theValue) 
{
  if(screenFlag)
     screenFlag = false;
  else 
     screenFlag = true; 
}
void AutoCal(int theValue) 
{
  if(autoFlag == true)
     autoCalibrate(); 
  else
     autoFlag = true; 
}
void Measure(int theValue) 
{
  if(meFlag == true)
    {
      //Servoinit(180,180,180,90);
    }
  else
     meFlag = true; 
}
