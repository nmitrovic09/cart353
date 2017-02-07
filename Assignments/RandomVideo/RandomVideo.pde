/* 
 A2 - Random Video
 Nikola Mitrovic
 February 7th, 2017
 Description: camera video on mesh that has a 
 controlled oscillation of mesh with noise and 
 Gaussian formula.
 */

//import libraries
import processing.video.*;
import java.util.*;

//java random class
Random generator;

//depth variable for 3d
float zoff;
//number of cells for mesh
float cell;
//2d array for mesh
float[][] heights;

Capture video;

int cols;
int rows;

void setup() {
  size(640, 480, P3D); 

  /*start at depth, number of cells with number of rows
   and columns in landscape*/
  zoff = 1000.0;
  cell = 10;
  cols = 100;
  rows = 120;

  //instantiate video and start it
  video = new Capture(this, width, height);
  video.start();

  //fill the array with number of rows and columns
  heights = new float[cols][rows];

  //instantiate random class
  generator = new Random();
}

//read the camera video capture
void captureEvent(Capture c) {
  video.read();
}

// calculate variation effect of lanscape based on x,y and z
void calcVariation() {

  //go through each mesh
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {

      //gaussian algorithm to control the mesh oscillation
      float num = (float) generator.nextGaussian();
      //effect amplitude
      float sd = 0.01;
      //range of effect
      float mean = 40;
      //formula
      float h = sd * num + mean;

      //controle the z value 3D by converting the noise effect with gaussian algorithm
      float z = noise(map(i, 0, cols, 0, h), map(j, 0, rows, 0, h), zoff);
      //control the depth variable of the mesh
      heights[i][j] = map(z, 0, 1, -50, 50);
    }
  }
  //increase the 3d effect
  zoff += 0.01;
}

void draw() {
  background(255);

  // fill our heights array with a new set of z vals
  calcVariation();

  video.loadPixels();

  //change the position of the mesh in x, y and z position
  pushMatrix();
  translate(-100, -150, -100);
  rotateX(PI/4);

  //run a mesh through the columns and rows of arrray
  for (int i = 0; i < (cols-1); i++) { 
    for (int j = 0; j < (rows-1); j++) { 
      noStroke();

      //variable for the pixel on the window
      int multiplier = width/cols;
      //formula to push each pixel of video into mesh
      int loc = (cols - i*multiplier - 1) + j*multiplier * cols;
      loc = constrain(loc, 0, video.pixels.length-1);
      color c = video.pixels[loc];
      fill(c);

      //create the mesh with vertex
      pushMatrix();
      //change positon to where each cell is
      translate(i * cell, j * cell, 0);

      beginShape(QUADS);

      //mesh of each vertex with their positon with array
      vertex(0, 0, heights[i][j]);
      vertex(cell, 0, heights[i+1][j]);
      vertex(cell, cell, heights[i+1][j+1]);
      vertex(0, cell, heights[i][j+1]);
      endShape();

      popMatrix();
    }
  }
  popMatrix();
}