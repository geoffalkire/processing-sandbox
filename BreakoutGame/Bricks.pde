public class Bricks
{
  public ArrayList<Brick> brickCollection;

  private float brickWidth = 80;
  private float brickHeight = 20;

  public Bricks()
  {
    brickCollection = new ArrayList<Brick>();
    //create one row of 8 bricks
    for(int i = 0; i < 12; i++)
    {
      brickCollection.add(new Brick(brickWidth/2 + (i * (brickWidth + 5)), brickHeight/2 + 100));
    }
    
    //brickCollection.add(new Brick());

  }
  
  public void show()
  {
    for(int i = brickCollection.size() - 1; i >=0; i--)
    {
      Brick brick = (Brick)brickCollection.get(i);
      brick.show();
    }
  }
}

public class Brick
{
  public PVector location;//at center of brick
  private float brickWidth;
  private float brickHeight;
  private float r;
  private float g;
  private float b;
  
  public Brick()
  {
    initializeBrick();
  }
  
  public Brick(float x, float y)
  {
    location = new PVector(x, y);
    initializeBrick();
  }
  
  
  public float getTopSide()
  {
    return location.y - brickHeight/2;
  }
  
  public float getBottomSide()
  {
    return location.y + brickHeight/2;
  }
  
  public float getLeftSide()
  {
    return location.x - brickWidth / 2;
  }
  
  public float getRightSide()
  {
    return location.x + brickWidth / 2;
  }
  
  public void collided()
  {
    bricks.brickCollection.remove(this);
  }
  
  
  private void initializeBrick()
  {
    print("Brick Initialized!\n");
    brickWidth = 80;
    brickHeight = 20;
    r = random(255);
    g = random(255);
    b = random(255);
    if(location == null)
    {
      location = new PVector(width/4, height/6);
      
    }
    print("brick created with location " + location.x + "," + location.y +"\n");
  }
  
    public void show()
  {
    noStroke();
    fill(r,g,b);
    //first two arguments specify upper left corner of rect
    rect(location.x-brickWidth/2,location.y-brickHeight/2,brickWidth,brickHeight,2);
    //print("drew paddle at " + location.x + "," + location.y + "\n");
  }
}
