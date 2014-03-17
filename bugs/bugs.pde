int bugCount = 100;
ArrayList<Bug> bugs;
ArrayList<Bug> babyBugs;
ArrayList<BugHive> bugHives;
PVector temp;

Light light;
public int time = 0;


void setup() {
  frameRate(120);
  size(1280,720);
  background(0,0,0);
  
  ellipseMode(RADIUS);
  
  light = new Light();
  
  // Parameters go inside the parentheses when the object is constructed.
  bugs = new ArrayList<Bug>();
  babyBugs = new ArrayList<Bug>();
  bugHives = new ArrayList<BugHive>();
  for (int i=0; i< bugCount; i++){
    bugs.add(new Bug());
  }
}


void draw() {
  time++;
  fill(0,0,0,25);
  rect(0,0,width,height);
  
  
  light.move();
  //light.checkBoundaryCollision();
  
  for (int i = bugs.size()-1; i >= 0; i--) {
    Bug bug = bugs.get(i);
    bug.drive();
    bug.display();   
    
   // saveFrame("images/test-######.png");
   }

  
  for(int i = 0; i < bugHives.size(); i++)
  {
    BugHive bugHive = bugHives.get(i);
    bugHive.GenerateBugs();
    bugHive.Display();
  }
  
  
  //move all baby bugs into bugs array list for processing next frame.
  bugs.addAll(babyBugs);
  
  //clear baby bugs
  for (int i = babyBugs.size()-1; i >= 0; i--) {
  babyBugs.remove(i);
  }
  print("There are "+bugs.size()+" bugs");
}

void mouseClicked()
{
  bugHives.add(new BugHive(new PVector(mouseX,mouseY)));
}



