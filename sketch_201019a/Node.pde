class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> lines = new ArrayList<Line>();
  
    Node(float x, float y, Line[] l) {
      this.pos = new PVector(x, y);
      this.lines.add(l[0]);
      this.lines.add(l[1]);
    }
    
    Node(){
      
    }

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
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
}
