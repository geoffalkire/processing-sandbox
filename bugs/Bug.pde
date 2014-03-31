public class Bug { 
  
  //movement-related variables
  PVector velocity;
  PVector acceleration;
  float metabolism;
  float topSpeed;
  PVector randomDir;
  PVector birthPlace;
  
  //bug stats
  public float health;
  //public float bugMaxHealth;
  public float birthHealth;
  //public float offense;
  //public float defense;
  color bugColor;
  
  float originalRadius;
  float radius;
  float maxRadius;
  float growth;
  float aggro;
  PVector target;
  PVector loc;
  PVector locMod;
  float turnCost;
  
  
  int age;
  float lifespan;
  //boolean isPredator;
  
  //reproduction modifiers
  float birthCost;
  float reproPeriod; // reproduction frequency
  float litterSize;
  
  
  //emotional drivers
  float hungerAdd;
  float hateAdd;
  float hornyAdd;
  
  float hunger;
  float hate;
  float horny;
  
  boolean attack;
  boolean sexy;
  boolean run;
  
  
  
  /*--------------------------------------------Constructor----------------------------------------------*/

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
   public Bug(Bug parentBug, Bug otherBug) 
   {
     Initialize(parentBug, otherBug);
   }
  
  //initialization of bug's properties
  private void Initialize(Bug parentBug, Bug otherBug)
  {

    velocity = new PVector(0,0);
    age = 0;
    growth=0;
    radius=1;
    originalRadius = radius;
    
    if(parentBug != null)
    {
      metabolism = modify((parentBug.metabolism+otherBug.metabolism)/2);
      loc = parentBug.loc;
      locMod =  new PVector(random(-20,20), random(-20,20));
      loc.add(locMod);
      reproPeriod = modify((parentBug.reproPeriod+otherBug.reproPeriod)/2);
      aggro = modify((parentBug.aggro+ otherBug.aggro)/2);
      health = modify((parentBug.birthHealth+otherBug.birthHealth)/2);
      
      litterSize = modify((parentBug.litterSize+otherBug.litterSize)/2);
      bugColor = (parentBug.bugColor+other.bugColor)/2;
      
      hungerAdd = modify((parentBug.hungerAdd+otherBug.hungerAdd)/2);
      hornyAdd = modify((parentBug.hornyAdd+otherBug.hornyAdd)/2);
      hateAdd = modify((parentBug.hateAdd+otherBug.hateAdd)/2);
      
      
    }
    else
    {
      metabolism = random(10);
      reproPeriod = int(1000+(randomGaussian()*100));
      aggro = abs(randomGaussian()*1000);
      
      growth=random(1)*.1*(metabolism*.02);
      litterSize = 1;//random(1,3);
      bugColor = color(random(255),random(255),random(255));
      health = random(100);
      
      
      hungerAdd = int(random(10));
      hornyAdd = int(random(10));
      hateAdd = int(random(10));
      
      //birthCost = random(health)/2;
      //random(bugMaxHealth);
      //bugMaxHealth = 1000+random(100);
      //offense = random(100);
      //defense = random(100);
    }
    /*if (aggro>75){
      isPredator = true;
    }*/
    
    attack=false;
    sexy=false;
    run=false;
    
  
    hunger = 0;
    horny = -100;
    hate = 0;
  
  
    //metabolism affects the following
    lifespan = metabolism*(300+randomGaussian()*200);
    topSpeed = metabolism/2;
    birthHealth = health;
    maxRadius = 20;//(lifespan/age)*((offense + defense)/80);
    if(reproPeriod<24){
      reproPeriod=24;
    }
    
  }
  
  //calculates inheritance values from parent to child
  public float modify(float val){
   //return val+= random(val*.1)*random(-1,1);
   return val+= randomGaussian()*(val*.1);
  }

/*--------------------------------------------display----------------------------------------------*/

  public void display() {
    noStroke();
    //fill(aggro*4,health,0);
    fill(bugColor);
    ellipse(loc.x,loc.y,radius,radius);
  }


/*--------------------------------------------drive----------------------------------------------*/

  public void drive() {
   //increase goals goals 
    hunger += hungerAdd;
    horny += hornyAdd;
    hate += hateAdd;
    /*if (health> bugMaxHealth){
      health = bugMaxHealth;
    }*/
    
    //bug life and energy spent
    turnCost = metabolism*.05;
    //health-= turnCost;
    age++;
    if (health<=0 || age>=lifespan || radius<=0){
     die(); 
    }
    
    checkBoundaries();
    //reproduce();
    decideActions();
    grow();
  }
  
  
  
  private void grow(){
    if (age < lifespan*.1){
    radius+= growth;
    }
  }
  
  //check if out of bounds by 1000px, kill if so
  private void checkBoundaries()
  {
    
    if (loc.y<-boundary || loc.y>height+boundary || loc.x<-boundary || loc.x>width+boundary){ 
      die(); 
    }
  }
  
  private boolean _isBirthing = false;
  private boolean _isBirthingAnimationFinished = false;
  private int _birthingFrameCount = 0;
  
  private void reproduce(Bug targetBug)
  {
    
    
    float d = loc.dist(targetBug.loc);
    if(d < radius*1.2 && targetBug.age>lifespan*.2 && age>lifespan*.2 && horny>0 )
    {
      _isBirthing = true;
      horny=-300;
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
           babyBugs.add(new Bug(this,targetBug));
           //print ("A bug reproduced!\n");
           //health -= birthCost;
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
    
    Bug targetBug = getTarget(this, bugs);
     
    if(targetBug != null)
    {
       target = targetBug.loc;
       //if it's close enough and we are hungry, eat it
       if(sexy){
       
         reproduce(targetBug);
       }
       else if (attack)
       {
         eat(targetBug);
       }
       else if (run)
       {
        // print("run");
       }
       else
       {
         //if I'm the only bug left, stop moving
         target = loc;
       }
    
      //move towards the target
      move(target);
    }
  }
  
  
  private void heal(PVector target)
  {
    float d = loc.dist(target);
    if (d < (light.radius+radius))
    {
     //heal
     health++;
    }
  }
  
  private void eat(Bug targetBug)
  {
    //if the other bug is within our radius, eat it
    float d = loc.dist(targetBug.loc);
    if(d < radius*1.2)
    {
      health += 100;//targetBug.health*3;
      //hurt the target more. loss of energy overall.
      targetBug.health=0;
      hunger=0;
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
      if (run == true){
        //print ("run = true");
        dir.mult(-1);
        hate -=20;
      }
        
      acceleration = dir;  // Set to acceleration
      
      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      velocity.add(acceleration);
      velocity.limit(topSpeed);
      loc.add(velocity);
  }

  public void die()
  {
    //print(this+" has died.  ");
    bugs.remove(this);
  }


  // A function that returns the closest point from a set
  Bug getTarget(Bug self, ArrayList otherList) {
  
    // some impossibly high distance (ie something is always closer)
    float distClosest = 9999999;//metabolism*300;
    // the closest point
    Bug theTarget = null;
    
    // Loop to find the closest point
    //print("PTS.size() = "+PTS.size());
 
      // get the closest
      float priority = max(hunger,horny,hate);
    
    
    if (priority == hunger){
      attack= true;
      for(int i = otherList.size()-1; i >= 0; i--){
      Bug other = (Bug)otherList.get(i);
      PVector selfPos = self.loc;
      PVector otherPos = other.loc;
        
      // get the distance
      float bugDist = PVector.dist(selfPos, otherPos);
        attack= true;
        if(bugDist < distClosest && self != other && other.aggro < self.aggro*.95){ // && hunter.offense>prey.defense
          // update the closest distance
          distClosest = bugDist;
          // remember the closest pos
          theTarget = other;
        }
      }
      
    }
    if (priority == horny){
        sexy= true;
        for(int i = otherList.size()-1; i >= 0; i--){
      Bug other = (Bug)otherList.get(i);
      PVector selfPos = self.loc;
      PVector otherPos = other.loc;
        
      // get the distance
      float bugDist = PVector.dist(selfPos, otherPos);
        attack= true;
         if(bugDist < distClosest && self != other){ // && hunter.offense>prey.defense
          // update the closest distance
          distClosest = bugDist;
          // remember the closest pos
          theTarget = other;
        }
      }
        
    }
     if (priority == hate){
        run= true;
        for(int i = otherList.size()-1; i >= 0; i--){
          Bug other = (Bug)otherList.get(i);
          PVector selfPos = self.loc;
          PVector otherPos = other.loc;
            
          // get the distance
          float bugDist = PVector.dist(selfPos, otherPos);
          attack= true;
           if(bugDist < distClosest && self != other && other.aggro > self.aggro*1.05){ 
            // update the closest distance
            distClosest = bugDist;
            // remember the closest pos
            theTarget = other;
           }
        }
       
    }

    // return the closest point
    //print(theClosestBug);
   return theTarget;
  }
}

