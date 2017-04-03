class Coordinate {
  PVector origin;
  //color strokeColor = color(255);
  boolean isUndulating =false;
  
  float targetHeight;
  float prevTarget;
  
  //new height from the finger interaction  
  PVector targetHeightFinger;
  PVector prevTargetHeightFinger;
  
  //constructor
  Coordinate(float x, float y, float z, float _t) {
    origin = new PVector(x, y, z);
    targetHeight = _t;
    prevTarget =_t;
    
    //instantiating the currentPos and the targetHeightFinger 
    targetHeightFinger = new PVector(x, y, z);
    prevTargetHeightFinger = new PVector(origin.x, origin.y, origin.z);
  }

  //methods
  //keep track of the coordinates of the lanscape
  float getOx () { 
    return origin.x;
  }

  float getOy () {
    return origin.y;
  }

  float getOz () {
    return origin.z;
  }

  void calcDir() {
    
  }
  
 
  void calcZmesh() {
    
    float distance = abs(prevTarget - targetHeight);
    
    if (distance>1) {
      if (prevTarget>targetHeight)
        prevTarget-=.4;
      else
        prevTarget+=.4;
    }
  }
  
  //keep track of finger x,y,z position according to the landscape
  
  void calcXfinger() {
    
    float distance = abs(prevTargetHeightFinger.x - targetHeightFinger.x);
    
    if (distance>1) {
      if (prevTargetHeightFinger.x > targetHeightFinger.x)
        prevTargetHeightFinger.x -=.4;
      else
        prevTargetHeightFinger.x +=.4;
    }
  }
  
  void calcYfinger() {
    
    float distance = abs(prevTargetHeightFinger.y - targetHeightFinger.y);
    
    if (distance>1) {
      if (prevTargetHeightFinger.y > targetHeightFinger.y)
        prevTargetHeightFinger.y -=.4;
      else
        prevTargetHeightFinger.y +=.4;
    }
  }
  
  void calcZfinger() {
    
    float distance = abs(prevTargetHeightFinger.z - targetHeightFinger.z);
    
    if (distance>1) {
      if (prevTargetHeightFinger.z > targetHeightFinger.z)
        prevTargetHeightFinger.z -=.4;
      else
        prevTargetHeightFinger.z +=.4;
    }
  }
}