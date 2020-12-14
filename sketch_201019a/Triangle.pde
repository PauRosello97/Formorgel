class Triangle implements Comparable
{
  Node p1, p2, p3;
  Triangle() { 
    p1 = p2 = p3 = null;
  }

  Triangle(Node p1, Node p2, Node p3) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
  }

  PVector center() {
    return LineIntersector.simpleIntersect(p1.pos.x, p1.pos.y, (p2.pos.x + p3.pos.x)*.5, (p2.pos.y + p3.pos.y)*.5, p2.pos.x, p2.pos.y, (p3.pos.x + p1.pos.x)*.5, (p3.pos.y + p1.pos.y)*.5);
  }
  
  void display(){
    beginShape();
    vertex(p1.pos.x, p1.pos.y);
    vertex(p2.pos.x, p2.pos.y);
    vertex(p3.pos.x, p3.pos.y);
    endShape();
  }
  
  public String toString(){
    return "Triangle: [" + int(p1.pos.x) + ", " + int(p1.pos.y) + "] [" + int(p2.pos.x) + ", " + int(p2.pos.y)  + "] [" + int(p3.pos.x) + ", " + int(p3.pos.y) + "]"; 
  }
  
  int compareTo(Object o){
    Triangle t = (Triangle)o;
    float dif = this.center().x - t.center().x;
    return int(dif);
  }
  
  public float area(){
    float x1 = p1.pos.x;
    float y1 = p1.pos.y;
    float x2 = p2.pos.x;
    float y2 = p2.pos.y;
    float x3 = p3.pos.x;
    float y3 = p3.pos.y;
    
    float area = x1*y2 + x2*y3 + x3*y1 - y1*x2 - y2*x3 - y3*x1;
    area /= 2;
    
    return abs(area);
  }
}
