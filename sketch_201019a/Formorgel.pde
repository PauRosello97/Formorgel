class Formorgel{
  float radius, angleKnob, lengthKnob, offsetKnob;
  ArrayList<Line> lines;
  
  Formorgel(float r, float offsetKnob, float angleKnob, float lengthKnob){
    radius = r;
    this.offsetKnob = offsetKnob; // From 0 to 1. To control the start radius.
    this.angleKnob = angleKnob; // Angle of the line
    this.lengthKnob = lengthKnob; // Length of the line as a percentage of the radius
    lines = new ArrayList<Line>();
  }
  
  ArrayList<Line> generateLines(int d){
    //generateFourthLevelPack(width/2, height/2, d);
    //generateOnePack(width/2, height/2, d);
    generateOneShape(width/2, height/2, d, 0);
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
      generateFourthLevelPack(x+rotationRadius*cos(angle), y+rotationRadius*sin(angle), d);
    }
  }
  
  void generateFourthLevelPack(float x, float y, float d){
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float rotationRadius = 2*rep*radius*sin(radians(180-360/d));
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateThirdLevelPack(x+rotationRadius*sin(angle), y+rotationRadius*cos(angle), d);
    }
  }
  
  void generateThirdLevelPack(float x, float y, float d){
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float rotationRadius = 2*rep*radius/2;
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateSecondLevelPack(x-rotationRadius*cos(angle), y-rotationRadius*sin(angle), d);
    }
  }
  
  void generateSecondLevelPack(float x, float y, float d){
    float rotationRadius = 2*radius*sin(radians(180-360/d));
    int rep = int(pow(2*sin(radians(180-360/d)), 2));
    float extraR = d==4 ? 45 : 0;
    
    for(int i=0; i<rep; i++){
      float angle = radians(extraR+i*360/rep);
      generateOnePack(x+rotationRadius*sin(angle), y+rotationRadius*cos(angle), d);
    }
  }
  
  void generateOnePack(float x, float y, float d){
    float polygonVertexAngle = (180*(d-2)/d);
    float rep = 360/polygonVertexAngle;
    float rotationRadius = radius;
    
    float extraR = d==4 ? 45 : 90;
    
    for(int i=0; i<rep; i++){
      float angle = i*polygonVertexAngle+90;
      generateOneShape(x+rotationRadius*cos(radians(angle+extraR)), y+rotationRadius*sin(radians(angle+extraR)), d, angle);
    }
  }
    
  void generateOneShape(float x, float y, float d, float r){    
    
    ellipse(x, y, radius*2, radius*2);
    for(int i=0; i<d; i++){
      float angle = (r+i*360/d-90);
      
      PVector start = new PVector(
        x+radius*this.offsetKnob*cos(radians(angle)),
        y+radius*this.offsetKnob*sin(radians(angle))
      );
      
      float fix = 150;
      
      PVector end = new PVector(
        start.x+radius*this.lengthKnob*cos(radians(fix+angle+this.angleKnob)),
        start.y+radius*this.lengthKnob*sin(radians(fix+angle+this.angleKnob))
      );
      
      this.lines.add(new Line(start, end, lines.size()));
    }
  }
  
}
