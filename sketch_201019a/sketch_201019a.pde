import java.util.*;

int shapeDisplaying = 0; 
float setupTime, generationTime, displayTime = 0;


Pattern pattern;

void setup(){
  setupTime = millis()/1000.0; 
  size(1200, 840);
  colorMode(HSB, 360, 100, 100);
  
  pattern = new Pattern(230);
  
  background(255);
  generationTime = millis()/1000.0-setupTime;
  pattern.display();
  displayTime = millis()/1000.0-setupTime-generationTime;
  //println("Pattern generated in: " + str(generationTime));
  //println("Pattern displayed in: " + str(displayTime));
}
  
void draw(){
  pattern = new Pattern(millis()*0.01);
  pattern.display();
}
