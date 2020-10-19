class Node implements Comparable{
  
    PVector pos;
    ArrayList<Line> lines = new ArrayList<Line>();
  
    Node(float x, float y, Line[] l) {
      this.pos = new PVector(x, y);
      this.lines.add(l[0]);
      this.lines.add(l[1]);
    }

    void draw(){
      fill(0);
      ellipse(this.pos.x, this.pos.y, 20, 20);
    }

    void uneix(Node node) {
      if(node.lines.get(0)!=this.lines.get(0)&&node.lines.get(0)!=this.lines.get(1)){
        this.lines.add(node.lines.get(0));
      }else if(node.lines.get(1)!=this.lines.get(0)&&node.lines.get(1)!=this.lines.get(1)){
        this.lines.add(node.lines.get(1));
      }
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
