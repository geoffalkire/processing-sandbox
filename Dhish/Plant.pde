class Plant extends Cell implements Runnable
{
  public Plant()
  {
    super();
  }
 
  public Plant(Plant parent)
  {
    super(parent);
  }
 
  public void run()
  {
    if(loc.dist(ORIGIN) + w/2 > radius)
      die();
     
    w += myDish.sunlight * w / 30;
     
    myColor = color(130,360,260*w/maxSize);
    super.run();
  }
}
