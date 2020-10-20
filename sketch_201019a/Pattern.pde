class Pattern{
  ArrayList<Line> lines = new ArrayList<Line>();
  ArrayList<Node> intersections = new ArrayList<Node>();
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  
  Pattern(ArrayList<JSONObject> jsonPatterns){
    addPattern(jsonPatterns);
    findintersections();
    generatePolygons();
  }
  
  void draw(){

    noStroke();
    for(Polygon polygon : polygons){ polygon.draw(); }
    for(Node intersection : intersections){ intersection.draw(); }
    strokeWeight(1);
    for(Line line : lines){ line.draw();  }

  }
  
  void addPattern(ArrayList<JSONObject> jsons){
    float k = 840/120.0;
    //k = 1;

    for(JSONObject json : jsons){
      JSONArray jsonLines = json.getJSONArray("lines");

      for(int i=0; i<jsonLines.size(); i++){
        
          JSONObject jsonLine = jsonLines.getJSONObject(i);
          JSONArray jsonStart = jsonLine.getJSONArray("start");
          JSONArray jsonEnd = jsonLine.getJSONArray("end");

          int[] start = jsonStart.getIntArray();
          int[] end = jsonEnd.getIntArray();

          lines.add(new Line(new PVector(k*start[0], k*start[1]), new PVector(k*end[0], k*end[1])));
      }
    }
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
      if(intersections.get(i).pos.x<0 || intersections.get(i).pos.x>width || intersections.get(i).pos.y<0 || intersections.get(i).pos.y>height ){
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


  }
  
  void generatePolygons(){
    polygons = new ArrayList<Polygon>();
    
    for(Node intersection : intersections){
      ArrayList<Node> oldPath = new ArrayList<Node>();
      oldPath.add(intersection);
      followPath(oldPath);
    }

    //Eliminem els poligons que continguin altres poligons
    Collections.sort(polygons);
    
    /*
    for(int i = 0; i<polygons.size(); i++){
      for(int j=i+1; j<polygons.size(); j++){
        if(nodesEnComu(polygons.get(i), polygons.get(j))>2){
          polygons.remove(i);
          i--;
          j=polygons.size();
        }
      }
    }*/

    //--------- ELIMINEM POLÍGONS QUE CONTINGUIN PUNTS
    
    for(int i = 0; i<polygons.size(); i++){
      for(int j=0; j<intersections.size(); j++){
        if(nodeDinsPoli(intersections.get(j), polygons.get(i))){
          
          polygons.remove(i);
          i--;
          j=intersections.size();
        }
      }
    }
  }
  
  void followPath(ArrayList<Node> oldPath){
    ArrayList<Node> path = new ArrayList<Node>();
    
    for(Node node : oldPath){
      path.add(node);
    }

    Node lastNode = path.get(path.size()-1);
    
    ArrayList<Line> possibleLines = new ArrayList<Line>();
    for(Line line : lastNode.lines){
        possibleLines.add(line);
    }
    
    ArrayList<Node> possibleNodes = new ArrayList<Node>();
    for(Line line : possibleLines){
      ArrayList<Node> lineNodes = buscaAltresPunts(lastNode, line);
      for(Node lineNode : lineNodes){
        possibleNodes.add(lineNode);  
      }
    }
    
    for(Node possibleNode : possibleNodes){
      if(possibleNode!=null){ 

        ArrayList<Node> newPath = new ArrayList<Node>();
        for(Node node : path){
          newPath.add(node);
        }
        newPath.add(possibleNode);  
        
        if(newPath.get(0)==newPath.get(newPath.size()-1)){
          if(newPath.size()>3 && !liniaRepetida(newPath)){
            afegeixPolygon(newPath);
          }
        }else if(!liniaRepetida(newPath)){
          followPath(newPath);
        }
      }
    }
  } 

  boolean liniaRepetida(ArrayList<Node> path){
    // TREBALLEM AMB LES LÍNIES
    int[] liniesInPath = new int[path.size()-1];

    for(int i=0; i<path.size()-1; i++){
      liniesInPath[i] = posicioLinia(findLineInCommon(path.get(i), path.get(i+1)));
    }

    //TREBALLEM AMB ELS NODES
    int[] repetitions = new int[lines.size()];

    for(int repetition : repetitions){
      repetition = 0;
    }

    for(int i = 0; i<path.size(); i++){
      for(Line line : path.get(i).lines){
        repetitions[posicioLinia(line)]++;
      }
    }

    int count = 0;
    for(int repetition : repetitions){
      if(repetition>2) count++;
    }

    for(int i=0; i<repetitions.length; i++){
      if(repetitions[i]>1){
        // SI una línia està repetida, mirem si s'ha recorregut
        boolean inPath = false;
        for(int j=0; j<liniesInPath.length; j++){
          if(liniesInPath[j] == i) inPath = true;
        }
        for(int j=0; j<path.get(path.size()-1).lines.size(); j++){
          if(posicioLinia(path.get(path.size()-1).lines.get(j)) == i) inPath = true;
        }
        if(!inPath){
          return true;
        }
      }
    }

    return count>2;

  }

  Line findLineInCommon(Node nodeA, Node nodeB){
    for(Line lineA : nodeA.lines){
      for(Line lineB : nodeB.lines){
        if(lineA==lineB) return lineA;
      }
    }
    return null;
  }
  
  void afegeixPolygon(ArrayList<Node> path){
    Polygon newPoly = new Polygon(path);
    newPoly.ordenaPath();
    polygons.add(newPoly);
    polygons.get(polygons.size()-1).ordenaPath();
  }
  
  boolean sonElMateix(Node punt1, Node punt2){
    /*
    boolean areTheSame = true;
    float distance = 0.01;
    if(abs(punt1.pos.x-punt2.pos.x)>distance){
      areTheSame=false;
    }else if(abs(punt1.pos.y-punt2.pos.y)>distance){
      areTheSame=false;
    }
    return areTheSame;
    */
    return punt1.pos.x==punt2.pos.x && punt1.pos.y==punt2.pos.y;
  }
  
  ArrayList<Node> buscaAltresPunts(Node node, Line linia){

    ArrayList<Node> altres_punts = new ArrayList<Node>();
    for(int i = 0; i<intersections.size(); i++){
      
      if(intersections.get(i)!=node){
        boolean sharesALine = false;
        for(int j=0; j<intersections.get(i).lines.size(); j++){
          if(intersections.get(i).lines.get(j) == linia){
            sharesALine = true;
          }
        }
        if(sharesALine) altres_punts.add(intersections.get(i));
      }
      
    }

    ArrayList<Node> punts_propers = new ArrayList<Node>();

    //Recorrem cada node dels punts de la mateixa línia
    for(int i = 0; i<altres_punts.size(); i++){
      //I els comparem amb totes els altres
      boolean cap_al_mig = true;
      for(int j=0; j<altres_punts.size(); j++){
        if(i!=j){
          if(estaAlMig(node, altres_punts.get(i), altres_punts.get(j))){
            cap_al_mig = false;
          }
        }
      }
      if(cap_al_mig){
        punts_propers.add(altres_punts.get(i));
      }
    }

    return punts_propers;
  }  
  
  boolean estaAlMig(Node na, Node nb, Node nc){
    boolean esta_al_mig = false;

    PVector a = na.pos;
    PVector b = nb.pos;
    PVector c = nc.pos;

    if( ( (c.x>a.x&&c.x<b.x)||(c.x<a.x&&c.x>b.x) ) && ((c.y>a.y&&c.y<b.y)||(c.y<a.y&&c.y>b.y))){
      esta_al_mig = true;
    }else if((c.x==a.x) && ((c.y>a.y&&c.y<b.y)||(c.y<a.y&&c.y>b.y))){
      esta_al_mig = true;
    }else if((c.y==a.y) && ((c.x>a.x&&c.x<b.x)||(c.x<a.x&&c.x>b.x))){
      esta_al_mig = true;
    }
    
    return esta_al_mig;
  }

  int posicioLinia(Line linia){
    for(int i = 0; i<lines.size(); i++){
      if(lines.get(i)==linia){
        return i;
      }
    }
    return -1;
  }

  boolean jaExisteix(Polygon pol){
    boolean ja_existeix = false;
    //Recorrem tots els polígons
    for(int i = 0; i<polygons.size(); i++){
      //Comencem considerant que si que existeix.
      boolean es_igual_1 = true;
      boolean es_igual_2 = true;
      
      int l = polygons.get(i).path.size();
      
      //Mirem si els dos polígons tenen el mateix nombre de nodes.
      if(l==pol.path.size()){
        //Recorrem cada posició del polígon i.
        for(int j=0; j<l; j++){
          if(pol.path.get(j).pos!=polygons.get(i).path.get(j).pos){
            es_igual_1 = false;
          }
          if(pol.path.get(0).pos!=polygons.get(i).path.get(0).pos){
            es_igual_2 = false;
          }
          if(j!=0){
            if(pol.path.get(j).pos!=polygons.get(i).path.get(l-j).pos){
              es_igual_2 = false;
            }
          }
        }
      }else{
        // Si no tenen el mateix nombre de nodes, podem dir que no són 
        // el mateix polígon.
        es_igual_1 = false;
        es_igual_2 = false;
      }
      if(es_igual_1 || es_igual_2){
        ja_existeix = true;
      }
    }
    return ja_existeix;
  }
  
  int nodesEnComu(Polygon pol1, Polygon pol2){
    int nodes_en_comu = 0;
    for(int i = 0; i<pol1.path.size(); i++){
      for(int j=0; j<pol2.path.size(); j++){
        if(pol1.path.get(i)==pol2.path.get(j)){
          nodes_en_comu++;
        }
      }
    }
    return nodes_en_comu;
  }
  
  boolean checkcheck (float x, float y, float[] cornersX, float[] cornersY) {
      int i, j=cornersX.length-1 ;
      boolean odd = false;

      float[] pX = cornersX;
      float[] pY = cornersY;

      for (i=0; i<cornersX.length; i++) {
          if ((pY[i]< y && pY[j]>=y ||  pY[j]< y && pY[i]>=y)
              && (pX[i]<=x || pX[j]<=x)) {
                odd ^= (pX[i] + (y-pY[i])*(pX[j]-pX[i])/(pY[j]-pY[i])) < x; 
          }

          j=i; 
      }
    return odd;
  }
  
  boolean nodeDinsPoli(Node node, Polygon poli){
    float[] cornersX = new float[poli.path.size()];
    float[] cornersY = new float[poli.path.size()];

    for(int i = 0; i<poli.path.size(); i++){
      cornersX[i] = poli.path.get(i).pos.x;
      cornersY[i] = poli.path.get(i).pos.y;
    }

    boolean forma_part_del_path = false;
    for(int i = 0; i<poli.path.size(); i++){
      if(node == poli.path.get(i)){
        forma_part_del_path = true;
      }
    }

    if(forma_part_del_path){
      return false;
    }else{
      return checkcheck(node.pos.x, node.pos.y, cornersX, cornersY);
    }  
  }
}
