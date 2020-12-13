import java.util.*;

int N_LINIES = 20;
int shapeDisplaying = 0; 
float setupTime, generationTime, displayTime = 0;


Pattern pattern;

void setup(){
  setupTime = millis()/1000.0; 
  size(1200, 840);
  
  pattern = new Pattern();
  
  background(255);
  generationTime = millis()/1000.0-setupTime;
  pattern.display();
  displayTime = millis()/1000.0-setupTime-generationTime;
  //println("Pattern generated in: " + str(generationTime));
  //println("Pattern displayed in: " + str(displayTime));
}
  
void draw(){
  pattern = new Pattern();
  pattern.display();
}
