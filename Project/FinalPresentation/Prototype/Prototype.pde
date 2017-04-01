/* 
 Final Prototype
 Nikola Mitrovic
 April 11th, 2017
 */

//imported libraries
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import de.voidplus.leapmotion.*;
import processing.video.*;
import java.util.*;

//visual, sound and video variables
Landscape land;
Minim m;
AudioPlayer p;
Movie movie;
LeapMotion leap;
Interaction i;

void setup() {
  //set display
  background(0);
  //fullScreen(P3D);
  size(1200, 800, P3D);
  //hide mouse
  noCursor();

  //sound instantiation
  //m = new Minim(this);
  //p = m.loadFile("sound.mp3");
  //p.loop();

  //video instantiation
  //movie = new Movie(this, "water.mov");
  //movie.loop();

  //landscape instantiation
  land = new Landscape();

  //leap instantiation
  leap = new LeapMotion(this);

  i = new Interaction();
}

// ======================================================
// 1. Callbacks

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

void draw() {
  background(0);

  //Here I have to say which one to control the landscape with the interaction or seaData
  
  //display and update the landscape
  i.display();
  i.update();

  //video display horizontal
  //display();

  i.run();
}

//display the movie on the landscape
void display() {
  image(movie, 0, 0);
}

//read the movie video
void movieEvent(Movie movie) {
  movie.read();
}