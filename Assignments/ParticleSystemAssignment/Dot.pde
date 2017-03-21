class Dot extends Particle {

  //constructor with position, mass and strength of collision
  Dot(float bC, float m, PVector l) {
    super(bC, m, l);

  }
  
  // Draw Mover
  void display() {
    stroke(0, lifespan);
    strokeWeight(1);
    fill(200, lifespan);
    ellipse(position.x, position.y, mass*20, mass*2); 
  }
  
  //check when at the bottom of the display
  void checkEdges() {

    //keep the particle at the bottom of the screen
    if (position.y > height - mass*2) {
      //velocity.y *= -0.9;  // A little dampening when hitting the bottom
      velocity.y = 0;
      //println("here");
      // position.y = height-(mass*16);
      //vel

      //decrease the life span when it hits the bottom
      //lifespan -= 1;
    }
  }
}