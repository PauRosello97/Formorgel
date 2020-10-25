class Formorgel{
  float radius;
  ArrayList<Line> lines;
  
  Formorgel(float r){
    radius = r;
    lines = new ArrayList<Line>();
  }
  
  ArrayList<Line> generateLines(int d){
    generateSixthLevelPack(width/2, height/2, d);
    return this.lines;
  }
  
  void generateSixthLevelPack(float x, float y, float d){
    float offsetX = 0;
    float offsetY = 0;
    if(d==3) offsetX = 0;
    if(d==4){
      offsetX = radius*sqrt(2)/2;
      offsetY = radius*sqrt(2)/2;
    }
    
    generateFifthLevelPack(x+offsetX, y+offsetY, d);
  }
  
  void generateFifthLevelPack(float x, float y, float d){
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float rotationRadius = 2*rep*rep*radius/2;
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateFourthLevelPack(
        x+rotationRadius*cos(angle), 
        y+rotationRadius*sin(angle), 
        d
      );
    }
    
  }
  
  void generateFourthLevelPack(float x, float y, float d){
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float rotationRadius = 2*rep*radius*sin(radians(180-360/d));
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateThirdLevelPack(
        x+rotationRadius*sin(angle), 
        y+rotationRadius*cos(angle), 
        d
      );
    }
  }
  
  void generateThirdLevelPack(float x, float y, float d){
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float rotationRadius = 2*rep*radius/2;
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateSecondLevelPack(
        x-rotationRadius*cos(angle),
        y-rotationRadius*sin(angle),
        d
      );
    }
  }
  
  void generateSecondLevelPack(float x, float y, float d){
    float rotationRadius = 2*radius*sin(radians(180-360/d));
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateOnePack(
        x+rotationRadius*sin(angle),
        y+rotationRadius*cos(angle), 
        d
      );
    }
  }
  
  void generateOnePack(float x, float y, float d){
    float polygonVertexAngle = (180*(d-2)/d);
    float rep = 360/polygonVertexAngle;
    float rotationRadius = radius;
    
    float extraR = d==4 ? 45 : 90;
    
    for(int i=0; i<rep; i++){
      float angle = i*polygonVertexAngle+90;
      drawOneShape(
        x+rotationRadius*cos(radians(angle+extraR)),
        y+rotationRadius*sin(radians(angle+extraR)), 
        d, angle
      );
    }
  }
    
  void drawOneShape(float x, float y, float d, float r){
    noFill();   
    
    /*
    beginShape();
    r+= d==4 ? 45 : 0;
    for(int i=0; i<d; i++){
      float angle = r+i*360/d-90;
      vertex(x+radius*cos(radians(angle)), y+radius*sin(radians(angle)));
    }
    endShape(CLOSE);*/
    
    // Linies
    stroke(0);
    for(int i=0; i<d; i++){
      float angle = r+i*360/d-90;
      float augRadius = radius+0.0001;
      PVector start = new PVector(x+augRadius*cos(radians(angle)), y+augRadius*sin(radians(angle)));
      PVector end = new PVector(x-0.1*augRadius*cos(radians(angle+30)), y-0.1*augRadius*sin(radians(angle+30)));
      this.lines.add(new Line(start, end, lines.size()));
    }
  }
  
}
