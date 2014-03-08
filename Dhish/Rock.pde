class Rock extends Cell implements Runnable
{
  public Rock()
  {
    super();
    myColor = (int)random(80);
    w = 200;
    loc = cursor.get();//loc.mult(1.5);
  }
 
  public void run()
  {
    push();
    loc.limit(radius);
  }
 
  public void show()
  {
    super.show();
 
    pushMatrix();
    translate(loc);
 
    colorMode(HSB,360);
    stroke(200);
    strokeWeight(def/2);
    fill(myColor);
    ellipse(sqrt(w)*2);
 
    popMatrix();
  }
 
  public void mouseOver()
  {
  }
}
