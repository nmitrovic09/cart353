class Interaction extends Landscape {

  float fingersY;

  //height target array
  ArrayList<Float> heightTargetArray;
  ArrayList<PVector> fingerPos;

  //target array values
  float localHeightTarget;
  PVector fingerTargetPos;
  
  float newFingerPosY;
  PVector newFingerPos;
  
  float fingerHeightY;
  PVector fingerHeight;

  Interaction() {
    super();

    //store finger height data in this variable
    // ArrayList<Float> heightTargetArray = new ArrayList<Float>(getFingers().size());
    //println("list size:: "+getFingers().size());
    //start at the first value in the heightTargetArray
    // localHeightTarget = heightTargetArray.get(0);
  }

  void run() {
    //store finger y coordinante array in this variable
    heightTargetArray = getFingerPosY();
    //store finger position array into this variable
    fingerPos = getFingerPos();

    /*this boolean controls when we should change 
     the sea data value elevation*/
    boolean changeState = false;

    // get time
    timePassed = millis()-currentTime;

    //if the time has passed change the inputted data value
    if (timePassed > interval) {
      //change the elevation
      changeState = true;

      if (heightTargetArray.size() > 0 && fingerPos.size() > 0) {
        //println("list size:: "+heightTargetArray.size());
        newFingerPosY = heightTargetArray.get(0);
        newFingerPos = fingerPos.get(0, 0, 0);
      }
      
      //reset the timer
      timePassed = 0;
      currentTime = millis();
    }
  }
  
  ArrayList<PVector> getFingerPos() {
    int fps = leap.getFrameRate();

    int handi = 0;
    //println("here");
    ArrayList<PVector> returnValues = new ArrayList<PVector>();

    for (Hand hand : leap.getHands()) {
      //PVector handPosition = hand.getPosition();
      //println("handId:: "+handi+" finger");

      for (int i = 0; i < 5; i++) {
        Finger fingerCurrent = hand.getIndexFinger();
        PVector joint = fingerCurrent.getPositionOfJointTip();

        //Float fingersY = fingerCurrent.getPositionOfJointTip();

        println("handId:: "+handi+" finger"+ i+":: "+fingersY);
        //println("handId:: "+handi+" finger"+ i+":: "+joint);
        returnValues.add(joint);
      }
      handi++;
    }
    return returnValues;
  }

  ArrayList<Float> getFingerPosY() {
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
    flying -= 0.05;
    float yoff = flying;

    //float yoff =+ 0.02;

    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        
        //mapping the values from the finger data position to the correct landscape values
        fingerHeightY = map(newFingerPosY, 350, 200, 0, 200);
        
        float r = fingerHeightY/(float)125;
        //height formula with the array list for the landscape movement
        localHeightTarget = (fingerHeightY-(y*r));
        
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
  
  void meshMovement() {
    //going backwards in the y axes in three dimension
    //to get a sense of movement in 3d space
    flying -= 0.05;
    float yoff = flying;

    //float yoff =+ 0.02;
    
    //nested for loop for the terrain oscillation 
    //and control of mesh with vertex
    for (int y = 0; y < rows; y++) {
      float xoff = 0;
      for (int x = 0; x < cols; x++) {
        
        //mapping the values from the finger data position to the correct landscape values
        //these values need to be changed in order to map the leap motion space according to the landscape
        fingerHeight = new PVector(map(newFingerPos.x, 350, 200, 0, 200), map(newFingerPos.y, 350, 200, 0, 200), map(newFingerPos.z, 350, 200, 0, 200));
        
        //easing value on y axes according to new position form the leap motion
        float r = newFingerPos.y/(float)125;
        //finger values from the leap motion in space 
        //switch the values according to the landscape???
        PVector fingerTargetPos = new PVector(newFingerPos.x, newFingerPos.z, newFingerPos.y-(y*r));
        
        // limit local height
        //if (localHeightTarget <= 5) {
          //localHeightTarget = 5;
        //}
        
        //set the new height target to the landscape
        terrain[x][y].targetHeightFinger = fingerTargetPos;
        
        //update the movement of z values by keep as well the previous value
        terrain[x][y].calcZ();
        //change the initial values of the landscape generated by seaData to the new values of the fingers
        terrain[x][y].origin.x = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
        terrain[x][y].origin.y = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
        terrain[x][y].origin.z = map(noise(xoff, yoff), 0, 1, -terrain[x][y].prevTarget, terrain[x][y].prevTarget);
              
        xoff += 0.1;
      }
      yoff += 0.1;
    }
    
    
  }
}