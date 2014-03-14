public class Paddle
{
  private static final int MOVEMENT_DISPLACEMENT = 15;
  
  public PVector location;
  private float paddleWidth;
  private float paddleHeight;
  
  public Paddle()
  {
    initializePaddle();
  }
 
  
  
  public float getYBorder()
  {
    return height - paddleHeight/2;
  }
  
  public float getLeftSide()
  {
    return location.x - paddleWidth / 2;
  }
  
  public float getRightSide()
  {
    return location.x + paddleWidth / 2;
  }
  
  
  private void initializePaddle()
  {
    paddleWidth = 100;
    paddleHeight = 10;

    location = new PVector(width/2, height-paddleHeight/2);
  }
  
  public void moveLeft()
  {
    if(getLeftSide() >0)
    {
      location.x-= MOVEMENT_DISPLACEMENT;
    }
  }
  
  public void moveRight()
  {
    if(getRightSide() < width)
    {
      location.x+= MOVEMENT_DISPLACEMENT;
    }
  }
  
  public void move(float x)
  {
    location.x = x;
  }
  
  public float calculateBounceXDirection(PVector ballLocation)
  {
    
    return reboundValue(ballLocation.x);

  }
  
  private float reboundValue(float xValue)
  {
    float ratio = (xValue - getLeftSide()) / (getRightSide() - getLeftSide() );
    float range=15;
    float increment = 1;
    float bottomValue = -7.5;
    
    float reboundValue =(ratio * range) + bottomValue;
    
    print("ratio="+ratio+"\n");
    print("range="+range+"\n");
    print("rebound value="+reboundValue+"\n");
    
    return reboundValue;
  }
  
  public void show()
  {
    noStroke();
    fill(222,222,131);
    rect(location.x-paddleWidth/2,location.y-paddleHeight/2,paddleWidth,paddleHeight,2);
    //print("drew paddle at " + location.x + "," + location.y + "\n");
  }
}
