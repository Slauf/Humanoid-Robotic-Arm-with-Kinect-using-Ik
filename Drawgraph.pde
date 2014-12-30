
int width = 800;                                                 
int height = 200;
float[] data1 = new float[width];
float[] data2 = new float[width];
float[] data3 = new float[width];
float[] data4 = new float[width];
float newDataPoint1,newDataPoint2,newDataPoint3,newDataPoint4 = 0;


void Drawgraph(float val1 ,float val2)
{
    //----Line Graph...... 
    fill(255,255,255);
    rect(0,480,1000,680); 
    stroke(0,0,0);
    strokeWeight(1);
    line(200,480,200,680);     // Horizntal   
    //line(width/4,0,width/4,height);  // Vertical
    
    //---------------------------------------------------
    newDataPoint1 = height + 480 - val1;    // Green without filtering
    newDataPoint2 = height + 480 - val2;    // Red with filtering
     for(int i = 0; i < width-1; i++)                                
         {
          data1[i] = data1[i+1];
          data2[i] = data2[i+1];

         }
          data1[width-1] = newDataPoint1;
          data2[width-1] = newDataPoint2;
           strokeWeight(2);                                                
  
          for(int i = width-1; i > 0; i--)                                
          {
           stroke(0,255,0);                       // green Original value
            line(i,data1[i-1], i+1, data1[i]);
           stroke(255,0,0);                       // red kalman value
            line(i,data2[i-1], i+1, data2[i]);
          }
}

void Drawgraph(float val1 ,float val2,float val3 )
{
  //----Line Graph...... 
    fill(255,255,255);
    rect(0,480,1000,680); 
    stroke(0,0,0);
    strokeWeight(2);
    line(200,480,200,680);     // Horizntal   
    //line(width/4,0,width/4,height);  // Vertical
    
    //---------------------------------------------------
    newDataPoint1 = height + 480 - val1;    // Green without filtering
    newDataPoint2 = height + 480 - val2;    // Red with filtering
    newDataPoint3 = height + 480 - val3;
     for(int i = 0; i < width-1; i++)                                
         {
          data1[i] = data1[i+1];
          data2[i] = data2[i+1];
          data3[i] = data3[i+1];

         }
          data1[width-1] = newDataPoint1;
          data2[width-1] = newDataPoint2;
          data3[width-1] = newDataPoint3;
           strokeWeight(2);                                                
  
          for(int i = width-1; i > 0; i--)                                
          {
           stroke(0,255,0);                       // green Original value
            line(i,data1[i-1], i+1, data1[i]);
           stroke(255,0,0);                       // red kalman value
            line(i,data2[i-1], i+1, data2[i]);
           stroke(0,0,0);                       
            line(i,data3[i-1], i+1, data3[i]);
          }
}

void Drawgraph(float val1 ,float val2,float val3 ,float val4)
{
  //----Line Graph...... 
    fill(255,255,255);
    rect(0,480,1000,680); 
    stroke(0,0,0);
    strokeWeight(2);
    line(200,480,200,680);     // Horizntal   
    //line(width/4,0,width/4,height);  // Vertical
    
    //---------------------------------------------------
    newDataPoint1 = height + 480 - val1;    // Green without filtering
    newDataPoint2 = height + 480 - val2;    // Red with filtering
    newDataPoint3 = height + 480 - val3;
    newDataPoint4 = height + 480 - val4;
     for(int i = 0; i < width-1; i++)                                
         {
          data1[i] = data1[i+1];
          data2[i] = data2[i+1];
          data3[i] = data3[i+1];
          data4[i] = data4[i+1];

         }
          data1[width-1] = newDataPoint1;
          data2[width-1] = newDataPoint2;
          data3[width-1] = newDataPoint3;
          data4[width-1] = newDataPoint4;
           strokeWeight(2);                                                
  
          for(int i = width-1; i > 0; i--)                                
          {
           stroke(0,255,0);                       // green Original value
            line(i,data1[i-1], i+1, data1[i]);
           stroke(255,0,0);                       // red kalman value
            line(i,data2[i-1], i+1, data2[i]);
           stroke(0,0,0);                       
            line(i,data3[i-1], i+1, data3[i]);
           stroke(0,0,255);                       
            line(i,data4[i-1], i+1, data4[i]);
          }
}
