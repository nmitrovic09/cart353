/* 
 A3 - Forces
 Nikola Mitrovic
 March 21th, 2017
 Description: Press on ASDF keys to drop various 
 particles. What I tried to do is simulate the objects to
 fall and pile up when they hit each other and the bottom.
 */

//boolean for day and night
boolean day = true;

//create the particle system for the sketch
ParticleSystem ps;

//create liquid
Liquid liquid;

void setup() {
  size(640, 360);

  //initialize the variables
  day = true;

  //initialize the particle system
  ps = new ParticleSystem();

  // Create liquid object
  liquid = new Liquid(0, height/2, width, height/2, 0.1);
}

void draw() {
  //backgrounds for day and night
  if (day) {
    background(240, 248, 255);
  } else {
    background(45,60,60);
  }


  // Draw water
  liquid.display();

  //run the particle system
  ps.run();
}

//whne mouse clicked
void mousePressed() {
  //switch between day and night
  day = !day;
}

//when key pressed create the objects
void keyPressed() {
  ps.addParticle();
}