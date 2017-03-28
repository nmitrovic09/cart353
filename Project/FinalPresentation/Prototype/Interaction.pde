class Interaction extends Landscape {

  float fingersY;

  //height target array
  ArrayList<Float> heightTargetArray;

  //target array value
  float localHeightTarget;
  
  float newFingerPos;
  
  float fingerHeight;

  Interaction() {
    super();

    //store finger height data in this variable
    // ArrayList<Float> heightTargetArray = new ArrayList<Float>(getFingers().size());
    //println("list size:: "+getFingers().size());
    //start at the first value in the heightTargetArray
    // localHeightTarget = heightTargetArray.get(0);
  }

  void run() {
    //store finger height data array in this variable
    heightTargetArray = getFingers();

    /*this boolean controls when we should change 
     the sea data value elevation*/
    boolean changeState = false;

    // get time
    timePassed = millis()-currentTime;

    //if the time has passed change the inputted data value
    if (timePassed > interval) {
      //change the elevation
      changeState = true;

      if (heightTargetArray.size() > 0) {
        //println("list size:: "+heightTargetArray.size());
        newFingerPos = heightTargetArray.get(0);
        //decreasing offset
        
      }
      
      //reset the timer
      timePassed = 0;
      currentTime = millis();
    }
  }

  ArrayList<Float> getFingers() {
    int fps = leap.getFrameRate();

    int handi = 0;
    //println("here");
    ArrayList<Float> returnValues = new ArrayList<Float>();

    for (Hand hand : leap.getHands()) {
      //PVector handPosition = hand.getPosition();
      //println("handId:: "+handi+" finger");

      for (int i = 0; i < 5; i++) {
        Finger fingerCurrent = hand.getIndexFinger();
        //PVector joint = fingerCurrent.getPositionOfJointTip();

        Float fingersY = fingerCurrent.getPositionOfJointTip().y;

        println("handId:: "+handi+" finger"+ i+":: "+fingersY);
        //println("handId:: "+handi+" finger"+ i+":: "+joint);
        returnValues.add(fingersY);
      }
      handi++;
    }
    return returnValues;
  }

  //movement of landscape
  void update() {
    //going backwards in the y axes in three dimension
    //to get a sense of movement in 3d space
    flying -= 0.02;
    float yoff = flying;

    //float yoff =+ 0.02;

    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        
        //mapping the values from the finger data position to the correct landscape values
        fingerHeight = map(newFingerPos, 250, 350, -50, 100);
        
        float r = fingerHeight/(float)125;
        //height formula with the array list for the landscape movement
        localHeightTarget = (fingerHeight-(y*r))*30;
        
        // limit local height
        if (localHeightTarget <= 5) {
          localHeightTarget = 5;
        }
        
        //set the new height target
        terrain[x][y].targetHeight = localHeightTarget;

        //update the movement of z values by keep as well the previous value
        terrain[x][y].calcZ();
        terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
        xoff += 0.1;
      }
      yoff += 0.1;
    }
  }
}