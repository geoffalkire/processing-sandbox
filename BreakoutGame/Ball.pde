public class Ball
{
  public PVector location;
  //private PVector acceleration;
  private PVector velocity;
  private float radius;
  
  public Ball(PVector target)
  {
    radius = 10;
    location = new PVector(width/2, height/2);
    
    setInitialVelocity(target);
  }
  
  private void setInitialVelocity(PVector target)
  {
      velocity = new PVector(0,0);
      PVector dir = PVector.sub(target,location);  // Find vector pointing towards target
      float d = location.dist(target);
      
      dir.normalize();     // Normalize
      dir.mult(4);       // Scale 
      //acceleration = dir;  // Set to acceleration
      //velocity.add(acceleration);
      velocity = dir.get();
  }
  
  public void move()
  {
    if(!collidedWithWall() && !collidedWithPaddle())
    {
      // Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
      //velocity.add(acceleration);
      //velocity.limit(topspeed);
      location.add(velocity);
    }
  }
  
  public boolean collidedWithPaddle()
  {
    //get distances between ball and paddle center
    PVector bVect = PVector.sub(paddle.getPaddleCenter(), location);
    
    //calculate magnitude of the vector separating the ball and paddle center
    float bVectMag = bVect.mag();
    
    return false;
    //if(bVectMag < r + 
  }
  
  public boolean collidedWithWall()
  {
    boolean collisionDetected = false;
      if(location.x > width - radius)
      {
        location.x = width - radius;
        //acceleration.x *=-1;
        velocity.x *= -1;
        //location.add(velocity);
        collisionDetected = true;
      }
      else if(location.x < radius)
      {
        location.x = radius;
        //acceleration.x *= -1;
        velocity.x *= -1;
        //location.add(velocity);
        collisionDetected = true;
      }
      else if(location.y > height-radius)
      {
        location.y = height-radius*2;
        //acceleration.y *= -1;
        velocity.y *= -1;
        collisionDetected = true;
      }
      else if(location.y < radius)
      {
        //note: this is where the ball hits the bottom of the screen. This should cause the player to lose a life.
        location.y = radius;
        //acceleration.y *= -1;
        velocity.y *= -1;
        //location.add(velocity);
        collisionDetected = true;
      }
      
      if(collisionDetected)
      {
        print("Collided with the wall!\n");
      }
      
      return collisionDetected;
  }
  
  public void show()
  {
    noStroke();
    fill(255,0,0);
    
    ellipse(location.x,location.y,radius,radius);
  }
}
