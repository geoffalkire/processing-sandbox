//bug creator class
public class BugHive
{
  public PVector _location;
  public int secondCounter;
  public float radius;
  public int maxBugsToGenerate = 10;
  public BugHive(PVector location)
  {
    //print("Creating BugHive. location = "+location);
    _location = location;
    radius = 15;
    secondCounter = millis();
  }
  
  public void GenerateBugs()
  {
    //print("Generating Bugs.\n");
    //print("secondCounter = " + secondCounter+"\n");
    //print("second = " + millis()+"\n");
    if(millis() - secondCounter >= 1000)
    {
      int bugCountToGenerate = round(random(maxBugsToGenerate));
      for(int i = 0; i < bugCountToGenerate; i++)
      {
        babyBugs.add(new Bug(_location.x, _location.y));
      }
      secondCounter = millis();
    }
  }
  
  public void Display()
  {
    noStroke();
    fill(0,0,255);
    ellipse(_location.x,_location.y,radius*2,radius*2);
  }
}
