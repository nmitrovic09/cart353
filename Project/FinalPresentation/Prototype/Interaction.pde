class Interaction extends Landscape {

  //arraylists for the returning leap coordinates
  ArrayList<Float> fingerHeightArray;
  ArrayList<PVector> fingerPosArray;

  /*variables to store the values of 
   arrayList from Leap Motion*/
  float fingerHeight;
  PVector fingerPos;

  /*only finger y coordinate and finger 
   (x,y,z) coordinates for the mapping 
   of fingers*/
  float mapFingerHeight;
  PVector mapFingerSpace;

  /*the positon of finger in the correct 
   cell on the landscape*/
  int indexX;
  int indexY;

  //timer
  float interval = 50;

  Interaction() {
    super();

    fingerPos = new PVector();
    mapFingerSpace = new PVector();
  }

  void run() {
    //store Leap finger y coordinante array in this array
    fingerHeightArray = getLeapFingerPosY();
    //store Leap finger position array into this array
    fingerPosArray = getLeapFinger();

    /*if the arraylists contain at least one or more values 
     of the fingers, run the interaction*/
    if (fingerHeightArray.size() != 0 && fingerPosArray.size() != 0) {
      //get the first values of both arraylist of Leap motion
      fingerHeight = fingerHeightArray.get(0);
      fingerPos = fingerPosArray.get(0);

      //mapping the values from the finger data position to the correct landscape values
      mapFingerHeight = map(fingerHeight, 100, 300, 200, 0);
      //mapFingerHeight = constrain(fingerHeight, 0, height);
      mapFingerSpace = new PVector(map(fingerPos.x, 200, 400, 0, width), map(fingerPos.y, 150, 350, 300, 0), map(fingerPos.z, 30, 90, height, 0));
      //mapFingerSpace = constrain(fingerHeight, 0, width);

      //update the interaction to the landcape
      fingerHeightUpdate();
      fingerMeshInteraction();

      /*detect and control the place of the finger
       in relation to landscape*/
      int testVertexResult = testFingerAgainstVertex();

      /*decreasing vertex from the finger posititon
       after the time has passed*/
      // get time
      timePassed = millis()-currentTime;

      //if the time has passed change the inputted data value
      if (timePassed > interval) {

        if (testVertexResult > 0) {

          
          //reset the timer
          timePassed = 0;
          currentTime = millis();
        }
      }
    }
  }


  void update() {
    super.update();
  }

  int testFingerAgainstVertex() {

    indexX = ceil(mapFingerSpace.x/10);
    indexY = ceil(mapFingerSpace.z/10);

    int counter = 0;

    //find the matching one
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {

        //if the finger is in the area
        if (int(terrain[x][y].screenCoordinate.y/10) == indexY && int(terrain[x][y].screenCoordinate.x/10) == indexX) {
          terrain[x][y].isActive = true;
          terrain[x][y].strokeColor = color(255, 0, 0);
          counter++;
        } else {

          //terrain[x][y].isActive = false;
          //terrain[x][y].strokeColor = color(255);
        }
      }
    }
    return counter;
  }

  void fingerMeshInteraction() {
    //going backwards in the y axes in three dimension
    //to get a sense of movement in 3d space
    flying -= 0.01;
    float yoff = flying;

    //float yoff =+ 0.1;

    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0.1;
      for (int x = 0; x < cols; x++) {

        if (terrain[x][y].isActive) {
          //easing value on y axes according to new position from the leap motion
          //float r = mapFingerSpace.y/(float)500;
          //fingerInSpace.y-(y*r)

          //Target Position of finger according to the leap motion values
          PVector fingerCoordinate = new PVector(mapFingerSpace.x, mapFingerSpace.y, mapFingerSpace.z);

          // limit local height
          //if (localHeightTarget <= 5) {
          //localHeightTarget = 5;
          //}

          //set the new height target to the landscape
          terrain[x][y].fingerTarget = fingerCoordinate;

          terrain[x][y].origin.z = lerp(terrain[x][y].prevFingerTarget.y, fingerCoordinate.y, 0.2);
          terrain[x][y].prevFingerTarget.y = terrain[x][y].origin.z ;

          //terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevFingerTarget.y, terrain[x][y].prevFingerTarget.y);
        } else {
          //easing formula for each vertex after the interaction
          terrain[x][y].calcZ();
          terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevFingerTarget.y, terrain[x][y].prevFingerTarget.y);       
          terrain[x][y].prevFingerTarget.y = terrain[x][y].origin.z ;
        }
        xoff += 0.1;
      }
      yoff += 0.1;
    }
  }

  //movement of landscape with the height of the hand finger
  void fingerHeightUpdate() {
    /*going backwards in the y axes in three dimension
     to get a sense of movement in 3d space*/
    flying -= 0.01;
    float yoff = flying;

    //float yoff =+ 0.1;

    /*nested for loop for the terrain oscillation 
     and control of mesh with the fingers height */
    for (int y = 0; y < rows; y++) {
      float xoff = 0.1;
      for (int x = 0; x < cols; x++) {

        //easing formula
        float r = mapFingerHeight/(float)125;
        localHeightTarget = (mapFingerHeight-(y*r));

        // limit local height
        if (localHeightTarget <= 5) {
          localHeightTarget = 5;
        }

        //set the new height target
        terrain[x][y].targetHeight = localHeightTarget;

        //the easing calculation
        terrain[x][y].calcZ();

        //update the movement of the terrain
        terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);

        xoff += 0.1;
      }
      yoff += 0.1;
    }
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
        stroke(0, 200, 250);

        //stroke(terrain[x][y].strokeColor);

        //create the vertex of landscape
        vertex(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        vertex(terrain[x][y+1].getOx(), terrain[x][y+1].getOy(), terrain[x][y+1].getOz());

        //get the landscape from the screen coordinates
        terrain[x][y].screenCoordinate.x = screenX(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        terrain[x][y].screenCoordinate.y = screenY(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
        terrain[x][y].screenCoordinate.z = screenZ(terrain[x][y].getOx(), terrain[x][y].getOy(), terrain[x][y].getOz());
      }
      endShape();
    }
    //fill(0, 0, 255);
    //ellipse(mapFingerSpace.x, mapFingerSpace.z, 50, 50);
  }

  //get the finger coordinates and store in arraylist
  ArrayList<PVector> getLeapFinger() {

    //how many hands are detected (for the println only)
    int handi = 0;

    //instantiate the returning array list
    ArrayList<PVector> values = new ArrayList<PVector>();

    //check if there is any hands detected
    for (Hand hand : leap.getHands()) {
      //check for how many fingers are detected
      for (int i = 0; i < 5; i++) {

        //get the current index finger coordinates
        Finger fingerCurrent = hand.getIndexFinger();

        //get the tip(end) of the index finger coordinates
        PVector joint = fingerCurrent.getPositionOfJointTip();

        //println("handId:: "+handi+" finger"+ i+":: "+joint);

        //add the index finger position to the returning arraylist
        values.add(joint);
      }
      //increment to find which hand is detected (for the println only)
      handi++;
    }
    return values;
  }

  //get the finger Y coordinate and store in arraylist
  ArrayList<Float> getLeapFingerPosY() {

    //how many hands are detected (for the println only)
    int handi = 0;

    //instantiate the returning array list
    ArrayList<Float> values = new ArrayList<Float>();

    //check if there is any hands detected
    for (Hand hand : leap.getHands()) {
      //check for how many fingers are detected
      for (int i = 0; i < 5; i++) {

        //get the current index finger coordinates
        Finger fingerCurrent = hand.getIndexFinger();

        //get only the y value of the index finger
        Float fingerY = fingerCurrent.getPositionOfJointTip().y;

        //println("handId:: "+handi+" finger"+ i+":: "+ fingerY);

        //add the index finger y value to the returning arraylist
        values.add(fingerY);
      }
      //increment to find which hand is detected (for the println only)
      handi++;
    }
    return values;
  }
}