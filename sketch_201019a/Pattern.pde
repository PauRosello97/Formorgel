class Pattern{
  ArrayList<Line> lines = new ArrayList<Line>();
  ArrayList<Node> intersections = new ArrayList<Node>();
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  ArrayList<Shape> shapes = new ArrayList<Shape>();
  final int NB_POINTS = 105;
  
  Formorgel formorgel;
  
  float radius = 200;
  
  Pattern(){
    
    generateLines();
    findintersections();
    /*
    generateTriangles();
    mergeTriangles();
    mergeShapes();
    removeEmptyShapes();
    */
  }
  
  void display(){
    background(255);
    //noStroke();
    //for(Node intersection : intersections){ intersection.draw();}
    //for(Triangle triangle : triangles){ triangle.display(); }
    //for(Shape shape : shapes){ shape.display(); }
    for(Line line : lines){ line.draw(); }
  }
  
  void generateLines(){
    float offsetKnob = 1-noise(100+millis()*0.0001);
    float angleKnob = noise(millis()*0.0001)*120;
    float lengthKnob = noise(10+millis()*0.0001)*2;
    
    formorgel = new Formorgel(radius, offsetKnob, angleKnob, lengthKnob);
    lines = formorgel.generateLines(3);
    for(int i=0; i<lines.size(); i++){
      if(lines.get(i).isOutside(radius)){
        lines.remove(i);
        i = i==0 ? 0 : i-1;
      }
    }
  }
  
  
  void removeEmptyShapes(){
    for(int i=0; i<shapes.size(); i++){
      if(shapes.get(i).triangles.size() == 0){
        shapes.remove(i);
        i--;
      }
    }
  }
  
  void mergeShapes(){
    //Recorrem totes les formes
    for(int i=0; i<shapes.size(); i++){
      
      //I les comparem amb totes les altres formes
      for(int j=0; j<shapes.size(); j++){
        
        //Menys amb elles mateixes
        if(i!=j){
          Shape shapeA = shapes.get(i);
          Shape shapeB = shapes.get(j);
          
          //Recorrem tots els triangles de la primera forma
          for(int k=0; k<shapes.get(i).triangles.size(); k++){
            Triangle triangleA = shapeA.triangles.get(k);
            ArrayList<Node> nodesTriangleA = new ArrayList<Node>();
            nodesTriangleA.add(triangleA.p1);
            nodesTriangleA.add(triangleA.p2);
            nodesTriangleA.add(triangleA.p3);
            
            //I els comparem amb tots els triangles de la segona forma
            for(int l=0; l<shapes.get(j).triangles.size(); l++){
              Triangle triangleB = shapeB.triangles.get(l);
              ArrayList<Node> nodesTriangleB = new ArrayList<Node>();
              ArrayList<Node> nodesInCommon = new ArrayList<Node>();
              nodesTriangleB.add(triangleB.p1);
              nodesTriangleB.add(triangleB.p2);
              nodesTriangleB.add(triangleB.p3);
              
              for(Node nodeA : nodesTriangleA){
                for(Node nodeB : nodesTriangleB){
                  if(nodeA.pos == nodeB.pos){
                    nodesInCommon.add(nodeA);
                  }
                }            
              }
              
              if(nodesInCommon.size() == 2){ 
                Node nodeA = nodesInCommon.get(0);
                Node nodeB = nodesInCommon.get(1);
                if(!nodeA.sharesLine(nodeB)){
                  shapeA.c = shapeB.c;
                  shapeA.addShape(shapeB);
                  shapeB.removeContent();
                }
              }
            }            
          }
        }
      }
    }
  }
  
  void mergeTriangles(){
    shapes.add(new Shape(triangles.get(0)));
    triangles.remove(0);
    for(Triangle triangleA : triangles){
      ArrayList<Node> nodesTriangleA = new ArrayList<Node>();
      nodesTriangleA.add(triangleA.p1);
      nodesTriangleA.add(triangleA.p2);
      nodesTriangleA.add(triangleA.p3);
      
      boolean shapeFound = false;
      for(int i=0; i<shapes.size(); i++){
        for(int j=0; j<shapes.get(i).triangles.size(); j++){
          
          Triangle triangleB = shapes.get(i).triangles.get(j);
          
          ArrayList<Node> nodesInCommon = new ArrayList<Node>();
          ArrayList<Node> nodesTriangleB = new ArrayList<Node>();
          nodesTriangleB.add(triangleB.p1);
          nodesTriangleB.add(triangleB.p2);
          nodesTriangleB.add(triangleB.p3);
          
          for(Node nodeA : nodesTriangleA){
            for(Node nodeB : nodesTriangleB){
              if(nodeA.pos == nodeB.pos){
                nodesInCommon.add(nodeA);
              }
            }            
          }
          if(nodesInCommon.size() == 2){ 
            Node nodeA = nodesInCommon.get(0);
            Node nodeB = nodesInCommon.get(1);
            if(!nodeA.sharesLine(nodeB)){
              shapes.get(i).addTriangle(triangleA);
              shapeFound = true;
            }
          }
        }
      }
      if(!shapeFound){
        shapes.add(new Shape(triangleA));
      }
    }
  }
  
  void generateTriangles(){
    new Triangulator().triangulate(intersections, triangles);
  }
    
  void findintersections(){
    intersections = new ArrayList<Node>();
    //Afegim totes les interseccions a l'array.
    for(int i = 0; i<lines.size(); i++){
      for(int j=i+1; j<lines.size(); j++){
        if(lines.get(i).intersects_at(lines.get(j))!=null){
          
          PVector intersection = lines.get(i).intersects_at(lines.get(j));
          Line[] intersectionLines = {lines.get(i), lines.get(j)};
          intersections.add(new Node(intersection.x, intersection.y, intersectionLines) );
        }
      }
    }

    // Unim interseccions iguals.
    
    
    for(int i = 0; i<intersections.size(); i++){
      for(int j = 0; j<intersections.size(); j++){
        if(i!=j && sonElMateix(intersections.get(i), intersections.get(j))){
          intersections.get(j).uneix(intersections.get(i));
          intersections.remove(i);
          i = i==0 ? 0 : i-1;
        }
      }
    }
    
  }
  
  boolean sonElMateix(Node punt1, Node punt2){
    float distance = punt1.pos.dist(punt2.pos);
    if(distance < 10) return true;
    return false;
  }  
}
