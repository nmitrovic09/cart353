class Liquid {
  // Liquid is a rectangle
  float x, y, w, h;
  // Coefficient of drag
  float c;
  
  //formula for the area collsion with the liquid
  float area;

  //constructor
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }

  //methods
  // boolean that finds the position that contains the particle
  boolean contains(Particle p) {
    PVector l = p.position;
    return l.x > x && l.x < x + w && l.y > y && l.y < y + h;
  }


  //drag force on the particle
  PVector drag(Particle p) {

    // simplified drag magnitude is coefficient * speed * speed
    // more accurate drag magnitude includes area too: coefficient * speed * speed * area
    // we will model area based on box length, which is m.mass * 16
    // then scale it by 0.1 as otherwise drag force is hilariously too strong

    //differnt formulancollision when its the day and night
    if (day) {
      area = p.mass * 10 * 0.1;
    } else {
      area = p.mass * 15 * 0.1;
    }
    
    //calculate the speed of the fall
    float speed = p.velocity.mag();
    float dragMagnitude = c * speed * speed * area;

    // Direction is inverse of velocity
    PVector dragForce = p.velocity.get();
    dragForce.mult(-1);

    // Scale according to magnitude
    // dragForce.setMag(dragMagnitude);
    dragForce.normalize();
    dragForce.mult(dragMagnitude);
    return dragForce;
  }

  //display the liquid
  void display() {
    noStroke();
    if (day) {
      fill(0, 150, 200);
    } else {
      fill(0, 175, 200);
    }
    rect(x, y, w, h);
  }
}