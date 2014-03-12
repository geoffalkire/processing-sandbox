// Even though there are multiple objects, we still only need one class. 
// No matter how many cookies we make, only one cookie cutter is needed.
public class Bug { 
  
  //PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float bugHealth;
  float radius;
  float agro;
  PVector target;
  color c;
  public PVector loc;

     // The Constructor 
  public Bug(float tempXpos, float tempYpos) { 
    agro = random(100);
    
    radius = 10;
    bugHealth = 50+random(100);
    loc = new PVector(random(width),random(height));
    //location = new PVector(random(width),random(height));
    velocity = new PVector(0,0);
    topspeed = random(10);
  }

  public void display() {
    noStroke();
    fill(bugHealth,0,0);
    ellipse(loc.x,loc.y,radius*2,radius*2);
  }


  public void drive() {
    
    //bug life
    bugHealth-=topspeed*.1;
    if (bugHealth<=0){
     die(); 
    }
    
 
      //define target
      if (agro>50){
        //look for near by things to eat.
       //target = new PVector(mouseX,mouseY);
     target = getClosestPoint(loc, bugs);
      
      }
      else 
      {

      //if agression is below threshold, go for light
        target = light.loc;//new PVector(mouseX,mouseY);
      }
      
      // Our algorithm for calculating acceleration:
      PVector dir = PVector.sub(target,loc);  // Find vector pointing towards target
      float d = loc.dist(target);
      

      if (d < (light.radius+radius)){
       //feed
       bugHealth++;
      }
      
      dir.normalize();     // Normalize
      dir.mult(0.5);       // Scale 
      acceleration = dir;  // Set to acceleration
      
      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      velocity.add(acceleration);
      velocity.limit(topspeed);
      loc.add(velocity);
      
      
    
  }

public void die()
  {
  
  bugs.remove(this);
  }


// A function that returns the closest point from a set
PVector getClosestPoint(PVector TESTPT, ArrayList PTS) {

  // some impossibly high distance (ie something is always closer)
  float distClosest = 999999;
  // the closest point
  PVector theClosestPt = null;
  // Loop to find the closest point
  print("PTS.size() = "+PTS.size());
  for(int i = PTS.size()-1; i >= 0; i--){
    // get a object

    PVector testPos = (PVector) ((Bug)PTS.get(i)).loc;
    
    print(TESTPT);
    print(testPos);
    
    // get the distance
    float d2 = PVector.dist(TESTPT, testPos);
    // ask the question
    if(d2 < distClosest && TESTPT != testPos){
      // update the closest distance
      distClosest = d2;
      // remember the closest pos
      theClosestPt = testPos.get();
    }
  }

  // return the closest point
  print(theClosestPt);
  return theClosestPt;

}

}


  
  



