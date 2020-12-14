class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> lines = new ArrayList<Line>();
  
    Node(float x, float y, Line[] l) {
      this.pos = new PVector(x, y);
      this.lines.add(l[0]);
      this.lines.add(l[1]);
    }
    
    Node(float x, float y) {
      this.pos = new PVector(x, y);
    }
    
    Node(){}

    void draw(){
      fill(0);
      ellipse(this.pos.x, this.pos.y, 20, 20);
    }

    void uneix(Node node) {
      for(Line line : node.lines){
        if(!this.lines.contains(line)){
          this.lines.add(line);
        }
      }
    }
    
    boolean sharesLine(Node node){
      for(Line lineA : node.lines){
        for(Line lineB : this.lines){
          if(lineA.id == lineB.id){
            return true;
          }
        }
      }
      return false;
    }
    
    Line getLineInCommon(Node node){
      for(Line lineA : this.lines){
        for(Line lineB : node.lines){
          if(lineA.id == lineB.id) return lineA;  
        }        
      }
      return null;
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
    
    public String toString(){
      String text = "[NODE] = [" + int(pos.x) + ", " + int(pos.y) + "] - LINES = [";  
      for(Line line : lines){
        text += line.id + " | ";  
      }
      text += "]";
      return text;
    }
}
