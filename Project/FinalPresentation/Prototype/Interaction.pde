class Interaction extends Landscape {

  float fingerY;

  //height target array
  ArrayList<Float> heightTargetArray;
  ArrayList<PVector> fingerPos;

  //target array values
  float localHeightTarget;
  PVector fingerTargetPos;

  float newFingerPosY;
  PVector newFingerPos;

  float fingerHeightY;

  PVector fingerInSpace = new PVector();

  boolean fingerMovement;

  float indexX;
  float indexY;

  Interaction() {
    super();

    //instantiate the new finger position from the leap motion
    newFingerPos = new PVector();
  }

  void run() {
    //store finger y coordinante array in this variable
    heightTargetArray = getFingerPosY();
    //store finger position array into this variable
    fingerPos = getFingerPos();



    if (heightTargetArray.size() > 0 && fingerPos.size() > 0) {
     // println("list size:: "+heightTargetArray.size());
      newFingerPosY = heightTargetArray.get(0);
      newFingerPos = fingerPos.get(0);
      
      getAction();
      meshFingerMovement();
    }
  }

  //movement of landscape
  void update() {
    //going backwards in the y axes in three dimension
    //to get a sense of movement in 3d space
    flying -= 0.01;
    float yoff = flying;

    //float yoff =+ 0.02;

    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0.1;
      for (int x = 0; x < cols; x++) {

        //mapping the values from the finger data position to the correct landscape values
        fingerHeightY = map(newFingerPosY, 300, 700, 200, 0);

        float r = fingerHeightY/(float)125;
        //height formula with the array list for the landscape movement
        localHeightTarget = (fingerHeightY-(y*r));

        // limit local height
        if (localHeightTarget <= 5) {
          localHeightTarget = 5;
        }

        //set the new height target
        terrain[x][y].targetHeight = localHeightTarget;

        //keep track of the previous and transition of the movement
        terrain[x][y].calcZmesh();

        //update the movement of the terrain
        terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
        xoff += 0.1;
      }
      yoff += 0.1;
    }
  }

  void meshFingerMovement() {
    //going backwards in the y axes in three dimension
    //to get a sense of movement in 3d space
   // flying -= 0.01;
    float yoff = flying;

    //float yoff =+ 0.02;

    fingerInSpace = new PVector(map(newFingerPos.x, 200, 1000, 0, width), map(newFingerPos.y, 300, 700, 0, 200), map(newFingerPos.z, 30, 60, height, 0));
    //println(newFingerPos.x);

    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0.1;
      for (int x = 0; x < cols; x++) {

        if (terrain[x][y].isActive) {
          //println(x);
          //mapping the values from the finger data position to the correct landscape values
          //these values need to be changed in order to map the leap motion space according to the landscape

          //easing value on y axes according to new position from the leap motion
          //float r = fingerInSpace.y/(float)500;
          //fingerInSpace.y-(y*r)

          //finger values from the leap motion in space 
          PVector fingerTargetPos = new PVector(fingerInSpace.x, fingerInSpace.y, fingerInSpace.z);

          // limit local height
          //if (localHeightTarget <= 5) {
          //localHeightTarget = 5;
          //}

          //set the new height target to the landscape
          terrain[x][y].targetHeightFinger = fingerTargetPos;

          //terrain[x][y].origin.x = lerp(terrain[x][y].prevTargetHeightFinger.x, fingerTargetPos.x, 0.03);
          //terrain[x][y].prevTargetHeightFinger.x = terrain[x][y].origin.x ;

          //terrain[x][y].origin.y = lerp(terrain[x][y].prevTargetHeightFinger.z, fingerTargetPos.z, 0.03);
          //terrain[x][y].prevTargetHeightFinger.z = terrain[x][y].origin.z ;

          terrain[x][y].origin.z = lerp(terrain[x][y].prevTargetHeightFinger.y, fingerTargetPos.y, 0.03);
          terrain[x][y].prevTargetHeightFinger.y = terrain[x][y].origin.y ;
        } else { 
          //calculate the Z value and update it to the movement of the lanscape

          terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
          terrain[x][y].prevTargetHeightFinger.y = terrain[x][y].origin.z ;
        }

        xoff += 0.1;
      }
      yoff += 0.1;
    }
  }


  void getAction() {

    indexX = ceil(fingerInSpace.x/10);
    indexY = ceil(fingerInSpace.z/10);

    //find the matching one
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {

        //if the finger is in the area
        if (int(terrain[x][y].screenCoordinate.y/10) == indexY && int(terrain[x][y].screenCoordinate.x/10) == indexX) {
          terrain[x][y].isActive = true;
          terrain[x][y].strokeColor = color(255,0,0);
          
         // print("active");
       
        } else {
          terrain[x][y].isActive = false;
          terrain[x][y].strokeColor = color(255);
        }
      }
    }
  }

  void releasedAction() {
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (terrain[x][y].isActive == true)
        {
          terrain[x][y].isActive = false;
        }
      }
    }

    fingerMovement =false;
    indexX =-1;
    indexY =-1;
  }

  //displaying the landscape on the screen
  void display() {

    //load video to the landscape
    //movie.loadPixels();

    //positioning the landscape in a horizontal position 
    //close to the bottom edge
    translate(width/2, height/2);
    rotateX(PI/2.3);
    translate(-w/2, -h/15);

    //nested for loop to create the landscape with vertex
    for (int y = 0; y < rows-1; y++) {

      //triangle changes
      beginShape(TRIANGLE_STRIP);

      for (int x = 0; x < cols-1; x++) {

        //fill and stroke colors of landscape
        strokeWeight(1);

        //video has a fill of landscape
        //variable for the pixel on the window
        //int multiplier = width/rows;

        //various formulas to put each pixel of video into mesh
        //int loc = (rows - y*multiplier -1) + y*multiplier * rows;
        //int loc = (movie.width - y - 1) + x * movie.width;
        //int loc = x + y * movie.width;
        //loc = constrain(loc, 0, movie.pixels.length-1);
        //color c = movie.pixels[loc];

        //int i = x*scl;
        //int j = y*scl;
        //color c = movie.pixels[i + j*movie.width];

        //noFill();
        //fill(c);

        //various color possibilities
        //blue possibiity 1
        fill(0, 150, 200);
       // stroke(0, 200, 250);
        stroke( terrain[x][y].strokeColor);

        //create the vertex of landscape
        vertex(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        vertex(terrain[x][y+1].getOx(), terrain[x][y+1].getOy(), terrain[x][y+1].getOz());

        //get the landscape from the screen coordinate
        terrain[x][y].screenCoordinate.x = screenX(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        terrain[x][y].screenCoordinate.y = screenY(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        terrain[x][y].screenCoordinate.z = screenZ(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
      }
      endShape();
    }
    fill(0, 0, 255);
    ellipse(fingerInSpace.x, fingerInSpace.z, 50, 50);
  }

  /*array list that return the index finger's x,y and z position 
   in order to control specific vertex in the landscape*/
  ArrayList<PVector> getFingerPos() {

    //how many hands are detected (for the println only)
    int handi = 0;

    //instantiate the returned array list
    ArrayList<PVector> returnValues = new ArrayList<PVector>();

    //check if there is any hands detected
    for (Hand hand : leap.getHands()) {
      //PVector handPosition = hand.getPosition();
      //println("handId:: "+handi+" finger");

      //check for how many fingers are detected
      for (int i = 0; i < 5; i++) {

        //get the current index finger values
        Finger fingerCurrent = hand.getIndexFinger();

        //get the tip(end) of the index finger with its x, y and position
        PVector joint = fingerCurrent.getPositionOfJointTip();

        //println("handId:: "+handi+" finger"+ i+":: "+joint);

        //add the index finger position to the returning arraylist
        returnValues.add(joint);
      }
      //increment to find which hand is detected (for the println only)
      handi++;
    }
    return returnValues;
  }

  /*array list that return the index finger's y position 
   in order to control the height of landscape*/
  ArrayList<Float> getFingerPosY() {

    //how many hands are detected (for the println only)
    int handi = 0;

    //instantiate the returned array list
    ArrayList<Float> returnValues = new ArrayList<Float>();

    //check if there is any hands detected
    for (Hand hand : leap.getHands()) {
      //PVector handPosition = hand.getPosition();
      //println("handId:: "+handi+" finger");

      //check for how many fingers are detected
      for (int i = 0; i < 5; i++) {
        //get the current index finger values
        Finger fingerCurrent = hand.getIndexFinger();

        //get only the y value of the index finger
        Float fingerY = fingerCurrent.getPositionOfJointTip().y;

        //println("handId:: "+handi+" finger"+ i+":: "+fingerY);

        //add the index finger y value to the returning arraylist
        returnValues.add(fingerY);
      }
      //increment to find which hand is detected (for the println only)
      handi++;
    }
    return returnValues;
  }
}