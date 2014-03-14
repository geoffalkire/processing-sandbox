Bricks bricks;
Ball ball;
Paddle paddle;



void setup() 
{
  frameRate(60);
  size(1280,720);
  
  noCursor();
  
  bricks = new Bricks();
  
  paddle = new Paddle();
  
  ball = new Ball(paddle.location);
}

void draw()
{
  background(0,0,0);
  
  paddle.show();
  ball.move();
  ball.show();
  bricks.show();
}

void keyPressed()
{
 // if(keyCode == LEFT)
  //{
 //   paddle.moveLeft();
  //}
  //else if(keyCode == RIGHT)
  //{
    //paddle.moveRight();
  //}
}

void mouseMoved()
{
  paddle.move(mouseX);
}
