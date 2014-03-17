public class Bug { 
  
  //movement-related variables
  PVector velocity;
  PVector acceleration;
  float metabolism;
  PVector randomDir;
  PVector birthPlace;
  
  //bug stats
  public float bugHealth;
  public float bugMaxHealth;
  public float birthHealth;
  public float offense;
  public float defense;
  color bugColor;
  
  float originalRadius;
  float radius;
  float maxRadius;
  float growth;
  float agro;
  PVector target;
  PVector loc;
  PVector locMod;
  
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
     Initialize(parentBug);
   }
  
  //initialization of bug's properties
  private void Initialize(Bug parentBug)
  {

    velocity = new PVector(0,0);
    age = 0;
    growth=0;
    radius=1;
    originalRadius = radius;
    
    if(parentBug != null)
    {
      metabolism = modify(parentBug.metabolism);
      loc = parentBug.loc;
      locMod =  new PVector(random(-10,10), random(-10,10));
      loc.add(locMod);
      reproPeriod = modify(parentBug.reproPeriod);
      agro = modify(parentBug.agro);
      //radius = modify(parentBug.radius);
      bugHealth = modify(parentBug.birthHealth);
      bugMaxHealth =  modify(parentBug.bugMaxHealth);
      lifespan = modify(parentBug.lifespan);
      growth = modify(parentBug.growth);
      birthCost = modify(parentBug.birthCost);
      litterSize = modify(parentBug.litterSize);
      offense = modify(parentBug.offense);
      defense = modify(parentBug.defense);
      bugColor = parentBug.bugColor;
    }
    else
    {
      metabolism = random(10);
      reproPeriod = int(((500+random(300))/(metabolism*.5)));
      agro = random(100);
      lifespan = (1000+random(1000));
      growth=random(1)*.1*(metabolism*.02);
      birthCost = random(bugHealth)/2;
      litterSize = random(1,4);
      offense = random(100);
      defense = random(100);
      bugColor = color(random(255),random(255),random(255));
      bugMaxHealth = 100+random(100);
      bugHealth = random(bugMaxHealth);
    }
    if (agro>50){
    isPredator = true;
    }
    birthHealth = bugHealth;
    maxRadius = (lifespan/age)*((offense + defense)/80);
  }
  
  //calculates inheritance values from parent to child
  public float modify(float val){
   return val+= random(val*.01)*random(-1,1);
  }

  public void display() {
    noStroke();
    //fill(agro*4,bugHealth,0);
    fill(bugColor);
    ellipse(loc.x,loc.y,radius,radius);
  }


  public void drive() {
    if (bugHealth> bugMaxHealth){
      bugHealth = bugMaxHealth;
    }
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
    if (age < lifespan*.1 && radius<maxRadius){
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
  
  private boolean _isBirthing = false;
  private boolean _isBirthingAnimationFinished = false;
  private int _birthingFrameCount = 0;
  private void reproduce()
  {
    if(age % int(reproPeriod) == 0)
    {
      _isBirthing = true;
    }
    // reproduce
    //print("time=" + time + " and reproPeriod =" + reproPeriod + "\n");
    if(_isBirthing)
    {
      //show animation based on frame count since start of animation
      showBirthingAnimation();
      
     //reproduce with variations of self
     if(_isBirthingAnimationFinished)
     {
       int ls = int(round(litterSize));
       for (int i = ls; i<= ls; i++){
         babyBugs.add(new Bug(this));
         //print ("A bug reproduced!\n");
         bugHealth -= birthCost;
       }
     }
    }
  }
  

  private void showBirthingAnimation()
  {
    if(_birthingFrameCount < 5)
    {
      radius+=1;
      _birthingFrameCount++;
    }
    else
    {
      radius = originalRadius;
      _isBirthingAnimationFinished = true;
      _isBirthing = false;
      _birthingFrameCount = 0;
    }
  }
  
 
  
  private void decideActions()
  {
          //define target
      if (isPredator){
          //look for near by things to eat.
          //target = new PVector(mouseX,mouseY);
         Bug targetBug = getClosestBug(this, bugs);
         
         
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
      //compare bugs size.  larger bug will win likely win
      //float attackRatio = offense - targetBug.defense;
      //absorb the bug's health based on agro
      float bugAttackOutcome = offense * agro/targetBug.defense;
      
      bugHealth +=bugAttackOutcome;
      
      //print ("bugAttackOutcome is "+bugAttackOutcome);
      //print ("targetBug.bugHealth is "+targetBug.bugHealth);
      
      //hurt the target more. loss of energy overall.
      targetBug.bugHealth-=bugAttackOutcome*8;
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
    //print(this+" has died.  ");
    bugs.remove(this);
  }


  // A function that returns the closest point from a set
  Bug getClosestBug(Bug hunter, ArrayList preyList) {
  
    // some impossibly high distance (ie something is always closer)
    float distClosest = 999999;
    // the closest point
    Bug theClosestBug = null;
    // Loop to find the closest point
    //print("PTS.size() = "+PTS.size());
    for(int i = preyList.size()-1; i >= 0; i--){
      // get the prey
      Bug prey = (Bug)preyList.get(i);
      PVector huntPos = hunter.loc;
      PVector preyPos = prey.loc;
      
      // get the distance
      float d2 = PVector.dist(huntPos, preyPos);
      
      // ask the question
      if(d2 < distClosest && hunter != prey){ // && hunter.offense>prey.defense
        // update the closest distance
        distClosest = d2;
        // remember the closest pos
        theClosestBug = prey;
      }
    }
  
    // return the closest point
    //print(theClosestBug);
    return theClosestBug;
  
  }

}


  
  



