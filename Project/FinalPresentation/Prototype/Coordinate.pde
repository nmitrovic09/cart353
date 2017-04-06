class Coordinate {
  PVector origin;
  color strokeColor = color(255);
  boolean isUndulating = false;
  
  float targetHeight;
  float prevTarget;
  
  //new height from the finger interaction  
  PVector targetHeightFinger;
  //previous finger interaction
  PVector prevTargetHeightFinger;
  
  PVector screenCoordinate;
  
  //check if the vertex is active
  boolean isActive;
  

  
  //constructor
  Coordinate(float x, float y, float z, float _t) {
    origin = new PVector(x, y, z);
    targetHeight = _t;
    prevTarget =_t;
    
    //instantiating the currentPos and the targetHeightFinger 
    targetHeightFinger = new PVector();
    prevTargetHeightFinger = new PVector(origin.x, origin.y, origin.z);
    screenCoordinate = new PVector();
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
}