//bug creator class
public class BugHive
{
  public PVector _location;
  public int secondCounter;
  public float radius;
  public int maxBugsToGenerate = 5;
  public BugHive(PVector location)
  {
    print("Creating BugHive. location = "+location);
    _location = location;
    radius = 15;
    secondCounter = second();
  }
  
  public void GenerateBugs()
  {
    if(second() - secondCounter == 1)
    {
      int bugCountToGenerate = round(random(maxBugsToGenerate));
      for(int i = 0; i < bugCountToGenerate; i++)
      {
        bugs.add(new Bug(_location.x, _location.y));
      }
      secondCounter++;
    }
  }
  
  public void Display()
  {
    noStroke();
    fill(0,0,255);
    ellipse(_location.x,_location.y,radius*2,radius*2);
  }
}
