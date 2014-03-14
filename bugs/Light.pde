public class Light {
  private PVector loc;
  private PVector dir;
  private float spread;
  private float wander_theta;
  private float radius;
  // bigger = more edgier, hectic
   
  private float max_wander_offset = 0.3;
  // bigger = faster turns
  private float max_radius = 3.5;
  
  
  float mx;
  float my;
 
   public Light(){
    //print("light constructed");

    this.spread = 200;
    wander_theta = random(TWO_PI);
    radius = spread/2;
   
    mx = constrain(random(width), radius, width-radius);
    my = constrain(random(height), radius, height-radius);
    loc = new PVector(mx,my);
   }

 
 public void move(){
   
   
   float wander_offset = random(-max_wander_offset, max_wander_offset);
   wander_theta += wander_offset;
   dir = new PVector(1,1);
   
   //check boundaries
    if (loc.x > width-radius) {
      wander_theta += PI;
      //loc.x = width-radius;
      //dir.x = -1;
    } 
    else if (loc.x < radius) {
       wander_theta += PI;
      //loc.x = radius;
      //dir.x = -1;
    } 
    else if (loc.y > height-radius) {
       wander_theta += PI;
      //loc.y = height-radius;
      //dir.y = -1;
    } 
    else if (loc.y < radius) {
       wander_theta += PI;
      //loc.y = radius;
      //dir.y = -1;
    }
    
    
   //update location
   loc.x += cos(wander_theta);//*dir.x;
   loc.y += sin(wander_theta);//*dir.y;
   
   
   
   //draw shape
   drawGradient(loc.x, loc.y, radius);
   // stroke(4);
    //drawGradient(loc.x, height/2);
    //fill(255,255,200); //noFill();
    //ellipse(loc.x,loc.y,radius,radius);
  }
void drawGradient(float x, float y, float rad) {
  float h = 360;//random(0, 360);
  for (int r = int(rad); r > 0; --r) {
    noStroke();
    fill(h, h, h);
    ellipse(x, y, r, r);
    h = (h + 1) % 360;
  }
}

 
}
