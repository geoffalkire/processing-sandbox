int bugCount = 25;
ArrayList<Bug> bugs;
ArrayList<BugHive> bugHives;
PVector temp;

Light light;


void setup() {
  frameRate(60);
  size(1280,720);
  ellipseMode(RADIUS);
  
  light = new Light();
  
  // Parameters go inside the parentheses when the object is constructed.
  bugs = new ArrayList<Bug>();
  bugHives = new ArrayList<BugHive>();
  for (int i=0; i< bugCount; i++){
    bugs.add(new Bug());
  }
}

void draw() {
  background(30,0,70);
  
  light.move();
  //light.checkBoundaryCollision();
  
  for (int i = bugs.size()-1; i >= 0; i--) {
    Bug bug = bugs.get(i);
    bug.drive();
    bug.display();
    
  }
  
  for(int i = 0; i < bugHives.size(); i++)
  {
    BugHive bugHive = bugHives.get(i);
    bugHive.GenerateBugs();
    bugHive.Display();
  }
}

void mouseClicked()
{
  bugHives.add(new BugHive(new PVector(mouseX,mouseY)));
}



