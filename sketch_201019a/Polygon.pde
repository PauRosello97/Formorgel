class Polygon implements Comparable{
  color col;
  ArrayList<Node> path;
  PVector center;
  Farborgel farborgel = new Farborgel();

  Polygon(ArrayList<Node> path){
    
    this.path = path;
    if(this.path.get(0)==this.path.get(this.path.size()-1)){
      this.path.remove(this.path.size()-1);
    }
    //ordenaPath();
    this.center=calculateCenter();
    this.col = farborgel.generateColor(360*center.x/width, random(25, 75));
  }
  
  void draw(){
    
    fill(this.col);
    
    if(true){
      if(isOver()) fill(0);
      noStroke();
      beginShape();
      for(int i=0; i<this.path.size(); i++){
        vertex(this.path.get(i).pos.x, this.path.get(i).pos.y);
      }
      endShape(CLOSE);

      stroke(1);
      ellipse(center.x, center.y, 10, 10);
    }
    hasRepeatedLines();
    
    //print();
  }
  
  void ordenaPath(){
    // Primer mirem quin ha de ser el node inicial.
    int node_inical = 0;
    float dist = width*height;
    PVector v_origen = new PVector(0,0);

    for(int i=0; i<this.path.size(); i++){
      PVector v_i = new PVector(this.path.get(i).pos.x, this.path.get(i).pos.y);
      float dist_i = v_origen.dist(v_i);
      if(dist_i<dist){
        node_inical = i;
        dist = dist_i;
      }
    }

    // Ara que ja sabem per quin node ha de començar, podem reordenar l'array path
    ArrayList<Node> new_path = new ArrayList<Node>();
    for(int i=0; i<this.path.size(); i++){
      new_path.add(this.path.get((i+node_inical)%this.path.size()));
    }
    this.path = new_path;
  }
  
  int compareTo(Object o){
    Polygon e = (Polygon)o;
    return e.path.size()-path.size();
  }
  
  float distOrigen(){
    float x = 0;
    float y = 0;
    for(int i=0; i<this.path.size(); i++){
      x += this.path.get(i).pos.x;
      y += this.path.get(i).pos.y;
    }
    x = x/this.path.size();
    y = y/this.path.size();
    PVector pos_av = new PVector(x, y);
    PVector origen = new PVector(0, 0);
    return origen.dist(pos_av);
  }
  
  
  float calculateArea(){
    float acumulat = 0;
    for(int i=0; i<this.path.size(); i++){
      acumulat += this.path.get(i).pos.x*this.path.get((i+1)%this.path.size()).pos.y*0.5;
      acumulat -= this.path.get(i).pos.y*this.path.get((i+1)%this.path.size()).pos.x*0.5;
    }
    return abs(acumulat);
  }

  PVector calculateCenter(){
    float accX = 0;
    float accY = 0;
    
    for(Node node : path){
      accX += node.pos.x;
      accY += node.pos.y;
    }
    accX /= path.size();
    accY /= path.size();
    return new PVector(accX, accY);
  }

  boolean isOver(){
    PVector vMouse = new PVector(mouseX, mouseY);
    return vMouse.dist(center)<5;
  }

  boolean equals(Polygon polygon){
    if(this.path.size()==polygon.path.size()){
      //println("CENTER: " + "[" + this.calculateCenter().x + ", " + this.calculateCenter().y + "] - [" + polygon.calculateCenter().x + ", " + polygon.calculateCenter().y);
      float precision = 0.0001;
      if(abs(this.calculateCenter().x-polygon.calculateCenter().x)<precision && abs(this.calculateCenter().y-polygon.calculateCenter().y)<precision){
        if(abs(this.calculateArea()-polygon.calculateArea())<1){
          return true;  
        }
      }
    }
    return false;
  }

  void print(){
    println(pathToString(path) + " - " + center + " - " + calculateArea());
  }
  
  boolean hasRepeatedNodes(){
    for(int i=0; i<path.size(); i++){
      for(int j=0; j<path.size(); j++){
        if(i!=j && path.get(i) == path.get(j)){
          return true;
        }
      }
    }
    return false;
  }
  
  boolean hasRepeatedLines(){
    int maxLineId = 0;
    //Busquem l'ID més alt
    for(int i=0; i<path.size(); i++){
      for(int j=0; j<path.get(i).lines.size(); j++){
        if(path.get(i).lines.get(j).id>maxLineId) maxLineId = path.get(i).lines.get(j).id;
      }
    }
    
    int[] repetitions = new int[maxLineId+1];
    
    for(int i=0; i<path.size(); i++){
      for(int j=0; j<path.get(i).lines.size(); j++){
          repetitions[path.get(i).lines.get(j).id]++;
      }
    }
    
    for(int rep : repetitions){
      if(rep>2) return true;  
    }
    return false;
  }
  
  
  boolean isOutside(float radius){
    return center.x<-radius || center.x>width+radius || center.y<-radius || center.y>height+radius;
  }
}
