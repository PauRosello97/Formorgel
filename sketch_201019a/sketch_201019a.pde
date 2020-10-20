import java.util.*;

int N_LINIES = 20;

float lines_radius = 200;

JSONObject pattern001, pattern002, pattern003, pattern004;

Pattern pattern;

void setup(){
  size(840, 840);
  
  colorMode(HSB, 360, 100, 100);

  pattern001 = loadJSONObject("patterns/001_frame.json");
  pattern002 = loadJSONObject("patterns/002_cross.json");
  pattern003 = loadJSONObject("patterns/003_cross2.json");
  pattern004 = loadJSONObject("patterns/004_cross3.json");
  
  ArrayList<JSONObject> patterns = new ArrayList<JSONObject>();
  patterns.add(pattern001);
  //patterns.add(pattern002);
  patterns.add(pattern003);
  patterns.add(pattern004);
  pattern = new Pattern(patterns);

  background(0, 0, 100);
  pattern.draw();
}
  
void draw(){
  
}

String nodeArrayToString(Node[] array){
  String message = "";
  for(Node node : array){
    message += nodeToString(node);
  }
  return message;
}

void printPath(ArrayList<Node> path){
  String message = "";
  for(int i=0; i<path.size(); i++){
    message += nodeToString(path.get(i));
  }
  println(message);
}

String nodeToString(Node node){
  if(node!=null){
    return "[" + node.pos.x + ", " + node.pos.y + "]";
  }
  return "[null]";
}
    
