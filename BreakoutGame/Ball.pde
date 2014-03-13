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
  
  public float getTop()
  {
    return location.y - radius;
  }
  
  public float getBottom()
  {
    return location.y + radius;
  }
  
  public float getLeftSide()
  {
    return location.x - radius;
  }
  
  public float getRightSide()
  {
    return location.x + radius;
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
    if(!collided())
    {
      //leaving out acceleration for now, only messing with velocity
      //velocity.add(acceleration);
      //velocity.limit(topspeed);
      location.add(velocity);
    }
  }
  
  public boolean collided()
  {
    return collidedWithWall() || collidedWithPaddle();
    
  }
  
  public boolean collidedWithPaddle()
  {
    //is the ball on or in the paddle?
    //if so, reset its position and set its velocity

    if( location.y + radius > paddle.getYBorder() &&
          paddle.getLeftSide() < location.x &&
          paddle.getRightSide() > location.x)
    {
      location.y = paddle.getYBorder()-radius;
      velocity.y *= -1;     
      
      //determine x velocity based on relative position to paddle center
      
      velocity.x = paddle.calculateBounceXDirection(ball.location);
      return true;
    }
    
    return false;
    
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
        location.y = height-radius;
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
