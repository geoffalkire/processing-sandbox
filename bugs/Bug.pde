// Even though there are multiple objects, we still only need one class. 
// No matter how many cookies we make, only one cookie cutter is needed.
public class Bug { 
  
  //PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  public float bugHealth;
  float radius;
  float agro;
  PVector target;
  color c;
  PVector loc;
  
  PVector randomDir;
  PVector birthPlace;
  
  float reproPeriod; // reproduction frequency
  float age;
  float lifespan;
  boolean killed;
  boolean isPredator;
  
  

  
  public boolean isPredator()
  {
      return agro > 70;
  }

     // The Constructor 
  public Bug(float tempXpos, float tempYpos) 
  {     
    loc = new PVector(tempXpos,tempYpos);
    Initialize();
  }
  
  public Bug() 
  {
    loc = new PVector(random(width),random(height));
    Initialize();
  }
  
   public Bug(Bug parentBug) {
     
     randomDir = new PVector(random(width),random(height));
     birthPlace = new PVector(parentBug.loc.x,parentBug.loc.y);
     birthPlace.normalize();
     birthPlace.mult(parentBug.radius);
     
     
     loc = new PVector(birthPlace.x,birthPlace.y);
     Initialize(parentBug);
   }
  
  
  private void Initialize()
  {
    killed=false;
    topspeed = random(10);
    agro = random(100);
    isPredator = isPredator();
    radius = 1;
    bugHealth = 50+random(100);
    velocity = new PVector(0,0);
    age = 0;
    lifespan = 1000+random(-500,500)/topspeed;
    reproPeriod = int(500+random(300))/topspeed;
  }
  
    private void Initialize(Bug parentBug)
  {
    killed=false;
    agro = modify(parentBug.agro);
    radius = modify(parentBug.radius);
    bugHealth = modify(parentBug.bugHealth);
    velocity = new PVector(0,0);
    topspeed = modify(parentBug.topspeed);
    age = 0;
    lifespan = modify(parentBug.lifespan);
    reproPeriod = modify(parentBug.reproPeriod);
  }
  

  public float modify(float val){
   return val+= random(val*.1)*random(-1,1);
  }

  public void display() {
    noStroke();
    fill(agro*4,bugHealth,0);
    
    ellipse(loc.x,loc.y,radius,radius);
  }


  public void drive() {
    
    //bug life and energy spent
    bugHealth-=topspeed*.1;
    age++;
    if (bugHealth<=0 || age>=lifespan){
      killed = true;
     //die(); 
    }
    
    //check if out of bounds by 1000px, kill if so
    if (loc.y<-1000 || loc.y>height+1000 || loc.x<-1000 || loc.x>width+1000){ 
     killed = true;
      //die(); 
    }
    
    
    // reproduce
    
    if( time % int(reproPeriod) == 0)
    {
     //reproduce with variations of self
     int litterSize= int(random(1, 5));
     for (int i = litterSize; i<= litterSize; i++){
       babyBugs.add(new Bug(loc.x, loc.y));
       print (""+this+" reproduced");
       bugHealth -= 30;//bugHeatlh/(litterSize+1);
     }
    }
    
 
      //define target
      if (isPredator){
          //look for near by things to eat.
          //target = new PVector(mouseX,mouseY);
         Bug targetBug = getClosestBug(loc, bugs);
         
         
         if(targetBug != null)
         {
           target = targetBug.loc;
           
           //if it's close enough and we are hungry, eat it
           eat(targetBug);
         }
         else
         {
           //if I'm the only bug left, stop moving
           target = loc;
         }

      
      }
      else 
      {

      //if agression is below threshold, go for light
        target = light.loc;//new PVector(mouseX,mouseY);
        
        //if the light is close enough, heal
        heal(target);
      }
      
      //move towards the target
      move(target);
      
    
  }
  
  private void heal(PVector target)
  {
    float d = loc.dist(target);
    if (d < (light.radius+radius))
    {
     //heal
     bugHealth++;
    }
  }
  
  private void eat(Bug targetBug)
  {
    //if the other bug is within our radius, eat it
    float d = loc.dist(targetBug.loc);
    if(d < radius && radius < 10)
    {
      //absorb the bug's health based on agro
      bugHealth += agro*2;
      //hurt the target more. loss of energy overall.
      targetBug.bugHealth-=agro*4;
    }
  }
  
  private void move(PVector target)
  {
      // Our algorithm for calculating acceleration:
      //print("In move. Target = "+target+"\n");
      //print ("Loc = "+loc+"\n");
      PVector dir = PVector.sub(target,loc);  // Find vector pointing towards target
      float d = loc.dist(target);
      
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
Bug getClosestBug(PVector TESTPT, ArrayList PTS) {

  // some impossibly high distance (ie something is always closer)
  float distClosest = 999999;
  // the closest point
  Bug theClosestBug = null;
  // Loop to find the closest point
  //print("PTS.size() = "+PTS.size());
  for(int i = PTS.size()-1; i >= 0; i--){
    // get a object
    PVector testPos = (PVector) ((Bug)PTS.get(i)).loc;
    
    // get the distance
    float d2 = PVector.dist(TESTPT, testPos);
    // ask the question
    if(d2 < distClosest && TESTPT != testPos){
      // update the closest distance
      distClosest = d2;
      // remember the closest pos
      theClosestBug = (Bug)PTS.get(i);
    }
  }

  // return the closest point
  //print(theClosestBug);
  return theClosestBug;

}

}


  
  



