public class Kalman
{
  float Xk_1 = 0;
  float Pk_1 = 1;
  float Xk,Xk_,Pk,Pk_,Kk ;
  float a = 1;
  float h = 1;
  float Q = 0.1;
  float R = 10;


    public float Kalmanfilter(float angle)
    {
        //------Predictor Updata........
        Xk_ = a * Xk_1;  //  Xk_ = a Xk_1 + b Uk 
        Pk_ = sq(a) * Pk_1 + Q; //   Pk_= a^2 Pk_1 + Q
        
        //------Measurement Update.......
        Kk = h * Pk_/( sq(h)*Pk_+ R);  // R    Kk = h Pk_ / h^2 Pk_ + R
        Xk = Xk_+Kk*(angle - h*Xk_);    // Xk = Xk_ + Kk(Zk - h Xk_)
        Pk = (1-h*Kk)*Pk_;    // Pk = (1- hKk)*Pk_
    
        if ( Float.isNaN(Xk) ) 
         Xk = Xk_1 ;
    
        //---------Time Updata........
        Xk_1 = Xk;
        Pk_1 = Pk;
    //println(a+"   "+h+"   "+R+"   "+Q);
        return Xk;
    }
    
    public void var(float val1, float val2, float val3, float val14)
    {
      a = val1;
      h = val2;
      R = val3;
      Q = val14;
    }
    
}


/*float [] Kalman(float []angles)
{
  float Xk_,Pk_,Kk,Xk,Pk;
  float [] temp = new float [4]; 
  float a = slidera;
  float h = sliderh;
  for(int i=0; i<=3; i++)
  {
    //------Predictor Updata........
    Xk_ = a*Xk_1_Pk_1[i][0];  // A gain  Xk_ = a Xk_1 + b Uk 
    Pk_ = sq(a)*Xk_1_Pk_1[i][1] + sliderq; // Q  Pk_= a^2 Pk_1 + Q
    //println(sliderq);
    
    //------Measurement Update.......
    Kk = h * Pk_/( sq(h)*Pk_+ sliderR);  // R    Kk = h Pk_ / h^2 Pk_ + R
    Xk = Xk_+Kk*(angles[i]- h*Xk_);    // Xk = Xk_ + Kk(Zk - h Xk_)
    Pk = (1-Kk)*Pk_;    // Pk = (1- hKk)*Pk_
    
    if ( Float.isNaN(Xk) ) 
     Xk = Xk_1_Pk_1[i][0] ;
    
      //---------Time Updata........
    Xk_1_Pk_1[i][0] = Xk;
    Xk_1_Pk_1[i][1] = Pk;

    
    temp[i] = Xk;
  }
  return temp;
}*/
