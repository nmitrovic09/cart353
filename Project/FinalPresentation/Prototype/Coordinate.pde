class Coordinate {
  PVector origin;
  //color strokeColor = color(255);
  boolean isUndulating =false;
  float targetHeight;
  float prevTarget;

  //constructor
  Coordinate(float x, float y, float z, float _t) {
    origin = new PVector(x, y, z);
    targetHeight = _t;
    prevTarget =_t;
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

  void calcZ() {
    float distance = abs(prevTarget - targetHeight);
    if (distance>1)
    {
      if (prevTarget>targetHeight)
        prevTarget-=.4;
      else
        prevTarget+=.4;
    }
  }
}