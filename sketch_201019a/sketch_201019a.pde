import java.util.*;

int N_LINIES = 20;
int shapeDisplaying = 0; 
float setupTime, generationTime, displayTime = 0;


Pattern pattern;

void setup(){
  setupTime = millis()/1000.0; 
  size(1200, 840);

  ArrayList<JSONObject> patterns = new ArrayList<JSONObject>();
  
  pattern = new Pattern();
  
  background(255);
  generationTime = millis()/1000.0-setupTime;
  pattern.draw();
  displayTime = millis()/1000.0-setupTime-generationTime;
  println("Pattern generated in: " + str(generationTime));
  println("Pattern displayed in: " + str(displayTime));
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
