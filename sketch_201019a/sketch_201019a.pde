import java.util.*;

int N_LINIES = 20;
int shapeDisplaying = 0; 

JSONObject pattern001, pattern002, pattern003, pattern004, pattern005, pattern006, pattern007;
Pattern pattern;

void setup(){
  size(1200, 840);

  pattern001 = loadJSONObject("patterns/001_frame.json");
  pattern002 = loadJSONObject("patterns/002_cross.json");
  pattern003 = loadJSONObject("patterns/003_cross2.json");
  pattern004 = loadJSONObject("patterns/004_cross3.json");
  pattern005 = loadJSONObject("patterns/005_square.json");
  
  ArrayList<JSONObject> patterns = new ArrayList<JSONObject>();
  
  patterns.add(pattern001);
  patterns.add(pattern002);
  patterns.add(pattern003);
  patterns.add(pattern004);
  patterns.add(pattern005);
  pattern = new Pattern(patterns);
  
  background(255);
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

String nodeArrayToLineString(Node[] array){
  String message = "";
  for(Node node : array){
    message += "[ ";
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

String pathToString(ArrayList<Node> path){
  String message = "";
  for(int i=0; i<path.size(); i++){
    message += nodeToString(path.get(i));
  }
  return message;
}

String nodeToString(Node node){
  if(node!=null){
    return "[" + node.pos.x + ", " + node.pos.y + "]";
  }
  return "[null]";
}

String vectorToString(PVector vector){
  if(vector!=null){
    return "[" + vector.x + ", " + vector.y + "]";
  }
  return "[null]";
}

String arrayToString(int[] array){
  String message = "";
  for(int item : array){
    message += item + ", ";
  }
  return message;
}

void keyPressed(){
  shapeDisplaying++;
  if(shapeDisplaying==pattern.polygons.size()) shapeDisplaying=0;
  println(shapeDisplaying);
}
