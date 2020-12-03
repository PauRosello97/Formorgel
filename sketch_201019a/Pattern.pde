class Pattern{
  ArrayList<Line> lines = new ArrayList<Line>();
  ArrayList<Node> intersections = new ArrayList<Node>();
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  ArrayList<PVector> pvs = new ArrayList<PVector>();
  final int NB_POINTS = 105;
  
  
  Formorgel formorgel;
  
  float radius = 200;
  
  Pattern(){
    formorgel = new Formorgel(radius);
    generateLines();
    findintersections();
    generateTriangles();
    println("Lines         : " + lines.size());
    println("Intersections : " + intersections.size());
  }
  
  void draw(){
    noStroke();
    for(Node intersection : intersections){ intersection.draw(); }
    strokeWeight(1);
    for(Line line : lines){ line.draw(); }
    for(Triangle triangle : triangles){ triangle.display(); }
  }
  
  void generateLines(){
    lines = formorgel.generateLines(3);
    
    for(int i=0; i<lines.size(); i++){
      if(lines.get(i).isOutside(radius)){
        lines.remove(i);
        i = i==0 ? 0 : i-1;
      }
    }
  }
  
  void generateTriangles(){
    new Triangulator().triangulate(pvs, triangles);
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

    //Eliminem les interseccions que estan a fora
    for(int i = 0; i<intersections.size(); i++){
      if(intersections.get(i).pos.x<-radius*2 || intersections.get(i).pos.x>width+radius*2 || intersections.get(i).pos.y<-radius*2 || intersections.get(i).pos.y>height+radius*2 ){
        intersections.remove(i);
        i--;
      }
    }
    
    Collections.sort(intersections);
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
    
    for(Node intersection: intersections){
      pvs.add(intersection.pos);  
    }
  }
  
  boolean sonElMateix(Node punt1, Node punt2){
    boolean areTheSame = true;
    float distance = 0.01;
    if(abs(punt1.pos.x-punt2.pos.x)>distance){
      areTheSame=false;
    }else if(abs(punt1.pos.y-punt2.pos.y)>distance){
      areTheSame=false;
    }
    return areTheSame;
  }  
}
