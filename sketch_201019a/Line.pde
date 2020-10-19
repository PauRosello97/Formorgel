class Line {
  PVector start, end;
  float m, n;
    Line(PVector start, PVector end) {
      this.start = start;
        this.end   = end;
        this.m = ((this.start.y-this.end.y)/(this.start.x-this.end.x));
        this.n = (this.start.y-this.m*this.start.x);
    }
  
    void draw() {
        stroke(0);
        strokeWeight(4);
        line(this.start.x, this.start.y, this.end.x, this.end.y);
    }

    PVector intersects_at(Line other) {
      if(abs(this.m-other.m)<0.0001 && abs(this.n-other.n)<0.0001){
        return null;
      }else{
        return line_itersection(this, other);
      }   
    }
    
    PVector line_itersection(Line one, Line two) {
    float x1 = one.start.x;
    float y1 = one.start.y;
    float x2 = one.end.x;
    float y2 = one.end.y;
        
    float x3 = two.start.x;
    float y3 = two.start.y;
    float x4 = two.end.x;
    float y4 = two.end.y;
        
    float bx = x2 - x1;
    float by = y2 - y1;
    float dx = x4 - x3;
    float dy = y4 - y3;
       
    float b_dot_d_perp = bx * dy - by * dx;
       
    if(b_dot_d_perp == 0){
        return null;
    }
       
    float cx = x3 - x1;
    float cy = y3 - y1;
       
    float t = (cx * dy - cy * dx) / b_dot_d_perp;
    if(t < 0 || t > 1){
        return null;
    }
       
    float u = (cx * by - cy * bx) / b_dot_d_perp;
    if(u < 0 || u > 1){
        return null;
    }
       
    return new PVector(x1+t*bx, y1+t*by);
  }

    void allarga(){
      this.start.x = 0;
      this.start.y = this.n;
      this.end.x = width;
      this.end.y = this.m*this.end.x+this.n;
    }
  }
