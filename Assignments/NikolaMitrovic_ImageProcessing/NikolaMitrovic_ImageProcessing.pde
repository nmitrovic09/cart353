/*     Nikola Mitrovic
CART 353 - A1 Image Processing
Press Keys:
A and S ---> to alternate the opacities between the images
D ---> to saturate the image
F ---> to blur the first image
G ---> to blur the second image
H ---> to save the image         */

//create two insect objects
Insect bug;
SecondInsect bug2;

//create booleans for the opacity control
boolean bugOpacity = false;
boolean bug2Opacity = false;

void setup() {
  //set display
  size(340, 340);
  //instantiate the two insect objects
  bug = new Insect();
  bug2 = new SecondInsect();
}

void draw() {
  background(255);

  //draw the images on the screen
  bug.display();
  bug2.display();
 
  
  /*increase the opacity of first bug 
  when the boolean is true*/
  if (bugOpacity) {
    bug.increaseOpacity();
    bug2.decreaseOpacity();
    
  }
  /*increase the opacity of second bug
  when the boolean is true*/
  if (bug2Opacity) {
    bug2.increaseOpacity();
    bug.decreaseOpacity();
  }
}

//when the keys are pressed
void keyPressed() {
  //save image of sketch with key h
  if (key == 'h' || key == 'H') {
    saveFrame("insect-####.jpg");
    println("Image Saved");
  }
  
  //blur for first insect with key f
  if (key == 'f' || key == 'F') {
    bug.blur();
  }
  //blur for first insect with key g
  if (key == 'g' || key == 'G') {
    bug2.blur();
  }
  //increase the opacity of the second insect with key s
  if (key == 's' || key == 'S') {
    bugOpacity = true;
  }
  //decrease the opacity of the first insect with key a
  if (key == 'a' || key == 'A') {
    bug2Opacity = true;
  }
  /*process the pixels with saturation 
  when key d is pressed*/
  if (key == 'd' || key == 'D') {
    bug.sat();
    bug2.sat();
  }
}

//when the keys are released
void keyReleased() {
  /*reverse the booleans to switch 
  opacities between the two images*/
  if (key == 's' || key == 'S') {
    bugOpacity = false;
  }
  if (key == 'a' || key == 'A') {
    bug2Opacity = false;
  }
}