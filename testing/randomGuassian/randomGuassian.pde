String[] name = {
"China:",
"India:",
"United States:",
"Indonesia:",
"Brazil:",
"Pakistan:",
"Bangladesh:",
"Nigeria:",
"Russia:",
"Japan:",
};
 
IntList samples;
 
 
//guassianRandom() test
int frameValue;
float highest;
float lowest;

void setup() {
  size(1280,720);
  frameRate(120);
  rectMode(CENTER);
  noStroke();
  samples = new IntList();
  for(int i=0;i<width;i++){
   samples.append(0);
  }
}

 
void draw(){
  for (int p=0; p<11; p++){
    frameValue = int(randomGaussian()*100+width/2);
  //print (frameValue);
  //point(frameValue, height/2);
  samples.add(frameValue, 1);
  }
   for(int i=0;i<width;i++){
     
     if(mouseX <= i+1 && mouseX >= i-1){
       fill(255,40,40);
     }else{
       fill(50);
     }
    rect(i,height/2,1,samples.get(i));
  }
 
}




