class ParticleSystem {
  //array list of particles
  ArrayList<Particle> particles;
  PVector origin;
  float spring = 0.05;

  //constructor
  ParticleSystem() {
    //position
    origin = new PVector();
    //instantiation of particle array
    particles = new ArrayList<Particle>();

    //instantiation of various particle systems
    addParticle();
  }

  //various probabilities with different 
  //characteristics according to day and night
  void addParticle() {

    //Key A for first particle system
    if (key == 'a' || key == 'A') { 
      //different properties for day and night
      if (day) {
        particles.add(new Particle(0.1, 1, new PVector(random(width), -80)));
      } else {
        particles.add(new Particle(0.2, 1, new PVector(random(width), -80)));
      }
    } 
    //Key S for second particle system
    else if (key == 's' || key == 'S') {
      //different properties for day and night
      if (day) {
       particles.add(new Triangle(0.1, 1, new PVector(random(width), -80)));
      } else {
       particles.add(new Triangle(0.2, 1, new PVector(random(width), -80)));
      }
    } 
    //Key D for third particle system
    else if (key == 'd' || key == 'D') {
      //different properties for day and night
      if (day) {
       particles.add(new Quad(0.12, 2, new PVector(random(width), -80)));
      } else {
       particles.add(new Quad(0.2, 2, new PVector(random(width), -80)));
      }
    } 
    //Key F for fourth particle system
    else if (key == 'f' || key == 'F') {
      //different properties for day and night
      if (day) {
       particles.add(new Dot(0.1, 1, new PVector(random(width), -80)));
      } else {
       particles.add(new Dot(0.2, 1, new PVector(random(width), -80)));
      }
    }
  }

  //if the particle is in the water
  void inWater() {
    //go throught all the particle array
    for (Particle p : particles) {
      //if the liquid contains the particle
      if (liquid.contains(p)) {
        // Calculate drag force
        PVector dragForce = liquid.drag(p);

        // Apply drag force to particle
        //if (p.numberNeighbors < 3) {
          p.applyForce(dragForce);
        //}
      }

      // Gravity is scaled by mass
      PVector gravity = new PVector(0, p.bounceCollisionwithWater * p.mass);

      // Apply gravity 
      if (p.numberNeighbors < 3) {
        p.applyForce(gravity);
      }
    }
  }

  //apply the movement of particles
  void run() {
    particlesCollision();
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void particlesCollision() {

    /*---------------STEP 1-----------------
     check how many neighbors the particle has*/
    for (Particle p : particles) {

      //if the particle has less than 3 neighbors
      if (p.numberNeighbors < 3) {

        p.numberNeighbors = 0;

        //check all the neighbors array
        for (Particle q : particles) {

          if (p.equals(q) == false) {

            //distances between p and q particles
            PVector dist = PVector.sub(p.position, q.position);
            //transform into magnitude
            float distanceMag = dist.mag();
            //distance of radius of both particles that is the minimum distance
            //we need for collision
            float minDist = p.pSize/2 + q.pSize/2;

            //if we have a collision we increment the nrighbor count
            if (distanceMag < minDist) {
              p.numberNeighbors++;
            }
          }
        }
      }
    }

    /*--------------STEP 2----------------
     we go through the particles and calculate the force
     based on the collision with other particles*/
    //NOTE:: the particle will stop moving if he has 4 neighbors

    //particles array
    for (Particle p : particles) {
      //look through the neighbors particles
      for (Particle q : particles) {

        if (p.equals(q) == false) {

          //get distance
          PVector dist = PVector.sub(p.position, q.position);
          float distanceMag = dist.mag();

          //calculate the rebounce
          //get the slope alone the x and along the the y
          float dx = p.position.x - q.position.x;
          float dy = p.position.y - q.position.y;
          //get the min distance
          float minDist = p.pSize/2 + q.pSize/2;

          /*if particle q collides with particle p and
           has less than 4 neighbors*/
          if (distanceMag < minDist && q.numberNeighbors < 4) {

            //get the angle between the slopes
            float angle = atan2(dy, dx);

            //where it should go
            float targetX = p.position.x + cos(angle) * minDist;
            float targetY = p.position.y + cos(angle) * minDist;

            //calculate acceleration based on the target
            float ax = (targetX = p.position.x) * 0.02;
            float ay = (targetY = p.position.y) * 0.02;

            //alter the veloctiy of particle q by the acceleration calculated
            q.velocity.x -= ax;
            q.velocity.y -= ay;

            //if the particle q collided with, is not at the bottom
            //then he bounces as well
            if (p.isAtBottom == false) {
              p.velocity.x += ax;
              p.velocity.y += ay;
            }

            //if the particle p is at the bottom and q collided with it
            //that means q is at the bottom as welll
            if (p.isAtBottom == true) {
              q.isAtBottom = true;
            } 
            //if the number of neighbors that q has == 4 
            //then just turn of the velocity
            else if (q.numberNeighbors >= 3) {
              q.velocity.x = 0;
              q.velocity.y = 0;
            }
          }
        }
      }
    }
  }
}