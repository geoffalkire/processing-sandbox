public class Paddle
{
  private static final int MOVEMENT_DISPLACEMENT = 10;
  
  public PVector location;
  private int paddleWidth;
  private int paddleHeight;
  
  public Paddle()
  {
    initializePaddle();
  }
  
  public PVector getPaddleCenter()
  {
    return new PVector(location.x-paddleWidth/2, location.y-paddleHeight/2);
  }
  
  private void initializePaddle()
  {
    paddleWidth = 100;
    paddleHeight = 50;

    location = new PVector(width/2, height-paddleHeight/2);
  }
  
  public void moveLeft()
  {
    location.x-= MOVEMENT_DISPLACEMENT;
  }
  
  public void moveRight()
  {
    location.x+= MOVEMENT_DISPLACEMENT;
  }
  
  public void show()
  {
    noStroke();
    fill(222,222,131);
    rect(location.x-paddleWidth/2,location.y,paddleWidth,paddleHeight,2);
    //print("drew paddle at " + location.x + "," + location.y + "\n");
  }
}
