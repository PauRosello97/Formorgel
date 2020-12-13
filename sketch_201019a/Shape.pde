class Shape{
  
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  color c;
  
  Shape(Triangle triangle){
    
    c = color(random(255), random(255), random(255));
    //triangle.setColor(c);
    this.addTriangle(triangle);
  }
  
  public void addTriangle(Triangle triangle){
    triangles.add(triangle);  
  }
  
  public void addShape(Shape shape){
    for(Triangle triangle : shape.triangles){
      triangles.add(triangle);  
    }
  }
  
  public void display(){
    PVector center = this.center();
    color col = color(255*center.x/width);
    fill(col);
    stroke(col);
    strokeWeight(2);
    for(Triangle triangle : triangles) triangle.display();  
  }
  
  public PVector center(){
    float x = 0;
    float y = 0;
    int count = 0;
    for(Triangle triangle : triangles){
      count++;
      PVector center = triangle.center();
      x += center.x;
      y -= center.y;
    }
    return new PVector(x/count, y/count);
  }
  
  public void removeContent(){
    triangles = new ArrayList<Triangle>();
  }
}
