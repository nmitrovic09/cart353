/* 
 Prototype
 Nikola Mitrovic
 April 11th, 2017
 */

//imported libraries
import java.util.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim m;
AudioPlayer p;

//leap motion
import de.voidplus.leapmotion.*;
LeapMotion leap;

//video
import processing.video.*;
Movie movie;

//visual, sound and video variables
Landscape land;
Interaction i;

Random generator;

void setup() {
  //set display
  background(0);
  //fullScreen(P3D);
  size(640,360,P3D);
  //hide mouse
  //noCursor();
  
  //sound instantiation
  //m = new Minim(this);
  //p = m.loadFile("sound.mp3");
  //p.loop();
  
  //video instantiation
  //movie = new Movie(this, "water.mov");
  //movie.loop();
  
  //instantiate the landscape and leap
  land = new Landscape();
  i = new Interaction();
  leap = new LeapMotion(this);
}

void draw() {
  background(0);

  //display and update the landscape
  //land.display();
  //land.update();
  //land.run();
  
  i.display();
  i.run();
  i.update();
  
  //video display horizontal
  //display();
}

//display the movie on the landscape
void display() {
  image(movie, 0, 0);
}

//read the movie video
void movieEvent(Movie movie) {
  movie.read();
}