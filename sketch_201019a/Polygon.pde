class Polygon implements Comparable{
  color col;
  ArrayList<Node> path;
  
  Polygon(ArrayList<Node> path){
    this.col = color(random(360), random(25,100), random(25,70));
    this.path = path;
    if(this.path.get(0)==this.path.get(this.path.size()-1)){
      this.path.remove(this.path.size()-1);
    }
  }
  
  void draw(){
    
    fill(this.col);
    
    beginShape();
    for(int i=0; i<this.path.size(); i++){
      vertex(this.path.get(i).pos.x, this.path.get(i).pos.y);
    }
    endShape(CLOSE);
    
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
  
  boolean estaFora(){
    boolean esta_fora = false;
    for(int i=0; i<this.path.size(); i++){
      if(this.path.get(i).pos.x<0 || this.path.get(i).pos.x>width || this.path.get(i).pos.y<0 || this.path.get(i).pos.y>height){
        esta_fora=true;
      }
    }
    return esta_fora;
  }
  
  float calculaArea(){
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
    return new PVector(accX, accY);
  }
}
