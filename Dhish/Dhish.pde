/**
Dhish, a simulation of evolution.
 
Green cells-plants, yellow-herbivores, red-carnivores.
Cells have many attributes some of which prove useful in getting food.
They pass these attributes on to their decedents, with some variation, thus the population evolves.
 
Mouse wheel to zoom. Click and drag to move dishes. Drag the edge of a dish to change its size.
P pauses. N makes a new dish. +/- changes the speed. Q toggles quality.
Double-click a dish to zoom in on it. Double-click an animal to control it. Your animal will follow the mouse.
Note: If you cant use the mouse wheel, right-click and drag instead.
 
Made by Rafael Cosman
 */
 
private float zoom;
public PVector center, mouse, cursor;
public final PVector ORIGIN = new PVector(0,0);
 
private Dish selected;
private boolean clickedRim;
private boolean paused;
 
private int frate;//frames per second
private boolean smoothed;
 
private int button;
 
public ArrayList dishes;
public final int numDishes = 1;
public boolean dishEvolution;
 
float radius;//the radiuses of the dishes
 
void mousePressed()
{
  button = mouseEvent.getButton();
 
  if (mousePressed) {
  
    selected = (Dish)dishes.get(0);
    for(int k = 0; k < dishes.size(); k++)
    {
      Dish d = (Dish)dishes.get(k);
      if(d.loc.dist(cursor) < selected.loc.dist(cursor))
        selected = (Dish)dishes.get(k);
    }
 
    if(selected.loc.dist(cursor) > radius+5)
    {
      selected = null;
 
      if(mouseEvent.getClickCount()==2)
        addDish();
    }
    else if(mouseEvent.getClickCount()==2 && dishes.size() > 1)//double click
    {
      dishes = new ArrayList();
      dishes.add(selected);
 
      selected.loc = ORIGIN.get();//moveAll(PVector.mult(mouse,-1));
      zoom(2);
      dishEvolution = false;
    }
    else
      clickedRim = abs(cursor.dist(selected.loc) - radius) < 10;
  }
}

void mouseDragged()
{
  PVector dmouse = new PVector(mouseX-pmouseX,mouseY-pmouseY);
  dmouse.div(zoom);
 
  if(selected != null)
  {
    if(clickedRim)//abs(cursor.dist(selected.loc) - selected.radius) < 10)
      radius = selected.loc.dist(cursor);// - selected.loc.dist(new PVector(pmouseX,pmouseY)))/zoom;
    else
      selected.loc.add(dmouse);
  }
  else if (mousePressed) 
  {
    moveAll(dmouse);
  }
  else if(true)//button == MouseEvent.BUTTON2 || button == MouseEvent.BUTTON3)
  {
    PVector pmouse = new PVector(pmouseX,pmouseY);
    PVector pcursor = PVector.sub(pmouse,center);
    pcursor.div(zoom);
 
    zoom(pcursor.mag() / cursor.mag());
  }
  else
    moveAll(dmouse);
}
void mouseReleased()
{
  selected = null;
}
 
void keyPressed()
{
  if(key == 'q')
  {
    smoothed = !smoothed;
     
    if(smoothed)
      smooth();
    else
      noSmooth();
  }
  else if(key == 'c')
  {
    Animal a = new Animal();
     
    a.carn = 1;
    a.maxSpeed *= 2;
     
    ((Dish)dishes.get(0)).add(a);
    a.myDish = ((Dish)dishes.get(0));
  }
  else if(key == 'n')
  {
    addDish();
    zoom(sqrt(dishes.size()-1) / sqrt(dishes.size()));
  }
  else if(key == 'r' && dishes.size() == 1)
    ((Dish)dishes.get(0)).add(new Rock());
  else if(key == 'p')
  {
    paused = !paused;
 
    if(paused)
      frameRate(60);
    else
      frameRate(frate);
  }
  else if(key == 'd')
    dishEvolution = !dishEvolution;
  else if(key == '+' || key == '=')
    frate *= 1.5;
  else if(key == '-')
    frate /= 1.5;
 
  frate = max(frate,2);
  frameRate(frate);
}
 
void setup()
{
  colorMode(HSB,360);
   
  frate = 18;
  dishEvolution = false;
   
  radius = 200;
 
  size(800,650);
  smoothed = true;
  smooth();//makes the circles smoother, but slows down frame rate
  center = new PVector(width/2, height/2);
  zoom = 2;
  paused = false;
  cursor(CROSS);
  dishes = new ArrayList();
 
  for(int k = 0; k < numDishes; k++)
    addDish();
 
  /*
  This listener thing is based off of
   http://ingallian.design.uqam.ca/goo/P55/ImageExplorer/
   */
  addMouseWheelListener(new java.awt.event.MouseWheelListener()
  {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt)
    {
      zoom(pow(.9,evt.getWheelRotation()));
    }
  }
  );
}
 
void draw()
{
  mouse = new PVector(mouseX,mouseY);
  cursor = PVector.sub(mouse,center);
  cursor.div(zoom);
 
  if(dishes.size() == 0)
    for(int k = 0; k < numDishes; k++)
      addDish();
 
  background(0);
   
  translate(center);
  scale(zoom);
 
  for(int k = 0; k < dishes.size(); k++)
  {
    pushMatrix();
 
    Dish d = (Dish)dishes.get(k);
    if(paused)
      d.show();
    else
    {
      d.run();
      d.show();
    }
 
    popMatrix();
  }
}
 
public void zoom(float factor)
{
  zoom *= factor;
  zoom = constrain(zoom, .01, 100);
}
 
public void moveAll(PVector move)
{
  move.mult(zoom);
  center.add(move);
}
 
//Draws a circle at point v, with width and height w.
public void ellipse(PVector v, float w)
{
  ellipse(v.x,v.y,w,w);
}
public void ellipse(float w)
{
  ellipse(ORIGIN,w);
}
 
public void translate(PVector v)
{
  translate(v.x,v.y);
}
 
public void addDish()
{
  dishes.add(new Dish(100,10));
}
