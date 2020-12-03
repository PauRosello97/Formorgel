class Triangle
{
  PVector p1, p2, p3;

  Triangle() { 
    p1 = p2 = p3 = null;
  }

  Triangle(PVector p1, PVector p2, PVector p3) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
  }

  Triangle(float x1, float y1, float x2, float y2, float x3, float y3)
  {
    p1 = new PVector(x1, y1);
    p2 = new PVector(x2, y2);
    p3 = new PVector(x3, y3);
  }

  PVector center() {
    return LineIntersector.simpleIntersect(p1.x, p1.y, (p2.x + p3.x)*.5, (p2.y + p3.y)*.5, p2.x, p2.y, (p3.x + p1.x)*.5, (p3.y + p1.y)*.5);
  }
  
  void display(){
    beginShape(TRIANGLES);
    fill(map(p1.x, 0, width, 0, 225), map(p1.y, 0, height, 0, 225), 225);
    vertex(p1.x, p1.y);
    vertex(p2.x, p2.y);
    vertex(p3.x, p3.y);
    endShape();
  }
}
