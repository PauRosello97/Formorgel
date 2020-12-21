class Shape{
  
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  color c;
  
  Shape(Triangle triangle){
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
    float value = this.value();
    color col = color(farborgel.generateColor(
      0.5*value%360, // Hue
      3*sqrt(value) // Luminance
    ));
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
      y += center.y;
    }
    return new PVector(x/count, y/count);
  }
  
  public void removeContent(){
    triangles = new ArrayList<Triangle>();
  }
  
  public float value(){
    PVector size = this.size();
    return size.x+size.y;
  }
  
  public PVector size(){
    float minX = width;
    float maxX = 0;
    float minY = height;
    float maxY = 0;
    
    for(Triangle triangle : triangles){
      ArrayList<Node> nodes = new ArrayList<Node>();
      nodes.add(triangle.p1);
      nodes.add(triangle.p2);
      nodes.add(triangle.p3);
      for(Node node : nodes){
        float x = node.pos.x;
        float y = node.pos.y;
        if(x < minX ) minX = x;  
        else if(x > maxX) maxX = x;
        if(y < minY ) minY = y;  
        else if(y > maxY) maxY = y;
      }
    }
    
    return new PVector(maxX-minX, maxY-minY);
  }
}