class Cell implements Runnable
{
  protected PVector loc;//the location of the cell relative to the center of the dish
  public float w, maxSize, def;
  protected color myColor;//the color of the cell (red-yellow for animals, green for plants, grey for rocks)
  protected Dish myDish;//the dish that contains this cell
  protected float livingCost;//the amount of energy lost each time run is called
  protected Dish touchingCells;
 
  public Cell()
  {
    myDish = new Dish();
 
    int r = (int)random(radius/2);
    float theta = random(TWO_PI);
    loc = new PVector(cos(theta),sin(theta));
    loc.mult(r);
 
    maxSize = random(20,60);
    w = maxSize/2;
    def = random(.2);
    touchingCells = new Dish();
 
    calcCost();
  }
  public Cell(Cell parent)//bianry fission
  {
    myDish = parent.myDish;
    myDish.add(this);
    loc = parent.loc.get();
    w = parent.w / 2;
    maxSize = modify(parent.maxSize-20) + 20;
    def = modify(parent.def);
 
    touchingCells = new Dish();
 
    calcCost();
  }

  private void calcCost()
  {
    livingCost = def*myDish.defMod/2;
    myDish.add(this);
  }
 
  public void show()
  {
    pushMatrix();
    translate(loc);
 
    stroke(200);
    strokeWeight(def/2);
    fill(myColor);
    ellipse(sqrt(w)*1.5);//draw the cell
 
    if(!(w > -10000))//if w is Not A Number
    {
      fill(255,80);
      ellipse(10);
    }
 
    if(loc.dist(PVector.sub(cursor,myDish.loc)) < sqrt(w) && !mousePressed)
      mouseOver();
 
    popMatrix();
  }
 
  protected void mouseOver()
  {
    scale(1.5);
    strokeWeight(.3);
    fill(255,0);
    ellipse(sqrt(10));
    ellipse(sqrt(maxSize));
    /*
    PVector pmouse = new PVector((pmouseX-centerX)/zoom,(pmouseY-centerY)/zoom);
     if(loc.dist(pmouse) > sqrt(w))
     println(this);
     */
  }
 
  public void run()
  {
    push();
 
    sub(livingCost);
 
    if(w > maxSize)//if you are too big, split.
    {
      if(this instanceof Animal && myDish.animalWeight() == w && dishes.size() == 1)
        println("Founder Effect!");
       
      Cell c1;
      Cell c2;
 
      if(this instanceof Plant)
      {
        Plant parent = (Plant)this;
        c1 = new Plant(parent);
        c2 = new Plant(parent);
      }
      else// if(this instanceof Animal)
      {
        Animal parent = (Animal)this;
        c1 = new Animal(parent);
        c2 = new Animal(parent);
 
        if(parent.myBrain instanceof BrainManual)
        {
          //paused = true;
          ((Animal)c1).myBrain = new BrainManual((Animal)c1);
        }
      }
 
      float angle = random(TWO_PI);//radians
      PVector v = new PVector(sin(angle),cos(angle));
      v.mult(sqrt(w));
      c1.loc.add(v);
      c2.loc.sub(v);
 
      die();
    }
    else if(w < 10)
    {
      if(this instanceof Animal && ((Animal)this).myBrain instanceof BrainManual)
      {
        zoom = 2;
        myDish.loc = ORIGIN.get();
      }
 
      die();
    }
  }
 
  public void push()
  {
    if(random(1) < .1 || this instanceof Animal)
      updateTouchingCells();
 
    for(int k = 0; k < touchingCells.size(); k++)
    {
      Cell c = touchingCells.get(k);
 
      if(touching(c))
      {
        PVector push = PVector.sub(c.loc,loc);
        push.normalize();
        push.mult((sqrt(w) + sqrt(c.w) - dist(c))/2);
        c.loc.add(push);
         
        if(!(c instanceof Animal && this instanceof Plant))
          c.sub(push.mag() * 2);
      }
      else
        touchingCells.remove(c);
    }
  }
  /*
  public void updateTouchingCellsFromTouching()
  {
    for(int t = 0; t < touchingCells.size(); t++)
    {
      Cell c = touchingCells.get(t);
       
      for(int k = 0; k < c.touchingCells.size(); k++)
        if(touching(c) && !(c instanceof Rock))
          touchingCells.add(c);
    }
  }
  */
  public void updateTouchingCells()
  {
    touchingCells = new Dish();
     
    for(int k = 0; k < myDish.size(); k++)
    {
      Cell c = (Cell)myDish.get(k);
      if(touching(c) && !(c instanceof Rock))
        touchingCells.add(c);
    }
  }
 
  public void sub(float amount)
  {
    w -= amount;
 
    if(w < 0)
    {
      w = 0;
      die();
    }
  }
 
  public float dist(Cell c)//returns the distance to another Cell
  {
    return loc.dist(c.loc);
  }
 
  public float modify(float num)
  {
    return num * pow(1.5,random(-1, 1));
  }
 
  protected void die()
  {
    myDish.remove(this);
  }
 
  public String toString()
  {
    return "  w:" +w+"  loc:"+loc+"  maxSize:"+maxSize+"  def:"+def;
  }
 
  public boolean touching(Cell c)
  {
    return dist(c) < sqrt(w) + sqrt(c.w) && c != this;
  }
}
