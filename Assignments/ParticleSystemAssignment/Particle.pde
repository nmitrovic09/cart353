class Particle {

  // position, velocity, acceleration, and size
  PVector position;
  PVector velocity;
  PVector acceleration;
  float pSize;

  //bounce collision on the liquid
  float bounceCollisionwithWater;
  float lifespan = 255;

  // Mass is tied to size
  float mass;

  boolean  isAtBottom = false;
  int numberNeighbors;

  //constructor
  Particle(float bC, float m, PVector l) {
    bounceCollisionwithWater = bC;
    mass = m;
    position = l.get();
    velocity = new PVector(0, 0.001);
    acceleration = new PVector(0, 0);
    pSize = mass*16;
    numberNeighbors = 0;
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }

  void run() {
    update();
    display();
    checkEdges();
  }

  void update() {
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // position changes by velocity
    position.add(velocity);
    // We must clear acceleration each frame
    acceleration.mult(0);
  }

  // Draw Particle
  void display() {
    stroke(0, lifespan);
    strokeWeight(1);
    fill(200, lifespan);
    rect(position.x, position.y, pSize, pSize);
  }

  //check when at the bottom of the display
  void checkEdges() {

    //keep the particle at the bottom of the screen
    if (position.y > height - pSize) {
      //velocity.y *= -0.9;  // A little dampening when hitting the bottom
      velocity.y =0;
      velocity.x=0;
      position.y = height;
      isAtBottom = true;

      //decrease the life span when it hits the bottom
      //lifespan -= 1;
    }
  }

  //boolean for the particle that is alive or dead
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}