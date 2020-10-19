class Node implements Comparable{
  
    PVector pos;
    Line[] linia = new Line[3];
  
    Node(float x, float y, Line[] l) {
      this.pos = new PVector(x, y);
      this.linia[0] = l[0];
      this.linia[1] = l[1];
    }

    void draw(){
      fill(0);
      ellipse(this.pos.x, this.pos.y, 20, 20);
    }

    void uneix(Node node) {
      if(node.linia[0]!=this.linia[0]&&node.linia[0]!=this.linia[1]){
        this.linia[2]=node.linia[0];
      }else if(node.linia[1]!=this.linia[0]&&node.linia[1]!=this.linia[1]){
        this.linia[2]=node.linia[1];
      }
    }
    
    int compareTo(Object o){
      PVector origin = new PVector(0,0);
        Node e = (Node)o;
        return int(origin.dist(pos)-origin.dist(e.pos));
    }
  }
