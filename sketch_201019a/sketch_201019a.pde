import java.util.*;

int N_LINIES = 20;

float lines_radius = 200;

JSONObject pattern001, pattern002, pattern003;

Pattern pattern;

void setup(){
  size(840, 840);
  
  colorMode(HSB, 360, 100, 100);

  pattern001 = loadJSONObject("patterns/001_frame.json");
  pattern002 = loadJSONObject("patterns/002_cross.json");
  pattern003 = loadJSONObject("patterns/003_cross2.json");
  
  ArrayList<JSONObject> patterns = new ArrayList<JSONObject>();
  patterns.add(pattern001);
  patterns.add(pattern002);
  //patterns.add(pattern003);
  pattern = new Pattern(patterns);

  background(0, 0, 100);
  pattern.draw();
}
  
void draw(){
  
}
    
