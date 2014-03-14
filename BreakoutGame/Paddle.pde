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
    float sectorSize = paddleWidth / 4;
    if(ballLocation.x > getLeftSide() && ballLocation.x < location.x + sectorSize)
    {
      return -4.0;
    }
    else if(ballLocation.x >= location.x + sectorSize && ballLocation.x < location.x)
    {
      return -2.0;
    }
    else if(ballLocation.x > location.x && ballLocation.x <= getRightSide() - sectorSize)
    {
      return 2.0;
    }
    else if(ballLocation.x > getRightSide() - sectorSize && ballLocation.x < getRightSide())
    {
      return 4.0;
    }
    else
    {
      return 0;
    }
  }
  
  public void show()
  {
    noStroke();
    fill(222,222,131);
    rect(location.x-paddleWidth/2,location.y-paddleHeight/2,paddleWidth,paddleHeight,2);
    //print("drew paddle at " + location.x + "," + location.y + "\n");
  }
}
