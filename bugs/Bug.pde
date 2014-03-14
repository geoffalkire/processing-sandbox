public class Bug { 
  
  //movement-related variables
  PVector velocity;
  PVector acceleration;
  float metabolism;
  PVector randomDir;
  PVector birthPlace;
  
  //bug stats
  public float bugHealth;
  public float birthHealth;
  
  float radius;
  float growth;
  float agro;
  PVector target;
  color c;
  PVector loc;
  
  float age;
  float lifespan;
  boolean isPredator;
  
  //reproduction modifiers
  float birthCost;
  float reproPeriod; // reproduction frequency
  float litterSize;
  

  //Constructor for setting location of the bug initially
  public Bug(float tempXpos, float tempYpos) 
  {     
    loc = new PVector(tempXpos,tempYpos);
    Initialize(null);
  }
  
  //Constructor for setting a random start location for the bug initially
  public Bug() 
  {
    loc = new PVector(random(width),random(height));
    Initialize(null);
  }
  
  //Constructor for inheriting traits of parent bug
   public Bug(Bug parentBug) 
   {
   
     //randomDir = new PVector(random(width),random(height));
     
     birthPlace = new PVector(parentBug.loc.x,parentBug.loc.y);
     birthPlace.normalize();
     birthPlace.mult(parentBug.radius);
     
     
     loc = new PVector(birthPlace.x,birthPlace.y);
     Initialize(parentBug);
   }
  
  //initialization of bug's properties
  private void Initialize(Bug parentBug)
  {

    velocity = new PVector(0,0);
    age = 0;
    growth=0;
    radius = 1;
    if(parentBug != null)
    {
      metabolism = modify(parentBug.metabolism);
      reproPeriod = modify(parentBug.reproPeriod);
      agro = modify(parentBug.agro);
      //radius = modify(parentBug.radius);
      bugHealth = modify(parentBug.birthHealth);
      lifespan = modify(parentBug.lifespan);
      growth = modify(parentBug.growth);
      birthCost = modify(parentBug.birthCost);
      litterSize = modify(parentBug.litterSize);
    }
    else
    {
      metabolism = random(10);
      reproPeriod = int(((500+random(300))/metabolism));
      agro = random(100);
      bugHealth = 50+random(100);
      lifespan = 1000+random(-500,500)/metabolism;
      growth=random(1)*.1*(metabolism*.02);
      birthCost = random(bugHealth)/2;
      litterSize = random(10);
    }
    if (agro>75){
    isPredator = true;
    }
    birthHealth = bugHealth;
  }
  
  //calculates inheritance values from parent to child
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
    bugHealth-=metabolism*.1;
    age++;
    if (bugHealth<=0 || age>=lifespan || radius<=.01){
      //killed = true;
     die(); 
    }
    
    checkBoundaries();
    
    reproduce();

    decideActions();
    
    grow();
      
    
  }
  private void grow(){
    if (age < lifespan*.1){
    radius+= growth;
    }
  }
  
  
  private void checkBoundaries()
  {
        //check if out of bounds by 1000px, kill if so
    if (loc.y<-1000 || loc.y>height+1000 || loc.x<-1000 || loc.x>width+1000){ 
     //killed = true;
      die(); 
    }
  }
  
  private void reproduce()
  {
    // reproduce
    //print("time=" + time + " and reproPeriod =" + reproPeriod + "\n");
    if(age % int(reproPeriod) == 0)
    {
     //reproduce with variations of self
     int ls = int(round(litterSize));
     for (int i = ls; i<= ls; i++){
       babyBugs.add(new Bug(loc.x, loc.y));
       print ("A bug reproduced!\n");
       bugHealth -= birthCost;
     }
    }
  }
  
  private void decideActions()
  {
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
      velocity.limit(metabolism);
      loc.add(velocity);
  }

  public void die()
  {
    print(this+" has died.  ");
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


  
  



