class Pattern{
  ArrayList<Line> linies = new ArrayList<Line>();
  ArrayList<Node> intersections = new ArrayList<Node>();
  ArrayList<Polygon> polygon = new ArrayList<Polygon>();
  
  Pattern(ArrayList<JSONObject> jsonPatterns){
    addPattern(jsonPatterns);
    findintersections();
    generatePolygons();
  }
  
  void draw(){

    noStroke();
    for(int i = 0; i<polygon.size(); i++){ polygon.get(i).draw(); }
    
    for(int i = 0; i<intersections.size(); i++){
      intersections.get(i).draw();
    }
    
    strokeWeight(1);
    for(int i = 0; i<linies.size(); i++){ linies.get(i).draw();  }

  }
  
  void addPattern(ArrayList<JSONObject> jsons){
    float k = width/120.0;

    for(int j=0; j<jsons.size(); j++){
      JSONArray jsonLines = jsons.get(j).getJSONArray("lines");

      for(int i=0; i<jsonLines.size(); i++){
          JSONObject jsonLine = jsonLines.getJSONObject(i);
          JSONArray jsonStart = jsonLine.getJSONArray("start");
          JSONArray jsonEnd = jsonLine.getJSONArray("end");

          int[] start = jsonStart.getIntArray();
          int[] end = jsonEnd.getIntArray();

          linies.add(new Line(new PVector(k*start[0], k*start[1]), new PVector(k*end[0], k*end[1])));
      }
    }
  }
  
  void findintersections(){
    intersections = new ArrayList<Node>();
    //Afegim totes les interseccions a l'array.
    for(int i = 0; i<linies.size(); i++){
      for(int j=i+1; j<linies.size(); j++){
        if(linies.get(i).intersects_at(linies.get(j))!=null){
          
          PVector intersection = linies.get(i).intersects_at(linies.get(j));
          Line[] intersectionLines = {linies.get(i), linies.get(j)};
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
    // Funciona perquè l'array està ordenat i les iguals estaràn juntes.
    for(int i = 0; i<intersections.size()-1; i++){
      if(abs(intersections.get(i).pos.x-intersections.get(i+1).pos.x)<0.0001 && abs(intersections.get(i).pos.y-intersections.get(i+1).pos.y)<0.0001){
        intersections.get(i+1).uneix(intersections.get(i));
        intersections.remove(i);
        i--;
      }
    }
  }
  
  void generatePolygons(){
    polygon = new ArrayList<Polygon>();
    
    for(int i = 0; i<intersections.size(); i++){
      ArrayList<Node> oldPath = new ArrayList<Node>();
      oldPath.add(intersections.get(i));
      followPath(oldPath);
    }

    //Eliminem els poligons que continguin altres poligons
    Collections.sort(polygon);
    
    for(int i = 0; i<polygon.size(); i++){
      for(int j=i+1; j<polygon.size(); j++){
        if(nodesEnComu(polygon.get(i), polygon.get(j))>2){
          polygon.remove(i);
          i--;
          j=polygon.size();
        }
      }
    }

    //--------- ORDENEM ELS POLÍGONS
    //polygon.sort(function(a, b){return b.calculaArea() - a.calculaArea()});  

    //--------- ELIMINEM POLÍGONS QUE CONTINGUIN PUNTS
    
    for(int i = 0; i<polygon.size(); i++){
      for(int j=0; j<intersections.size(); j++){
        if(nodeDinsPoli(intersections.get(j), polygon.get(i))){
          
          polygon.remove(i);
          i--;
          j=intersections.size();
        }
      }
    }
  }
  
  void followPath(ArrayList<Node> oldPath){
    ArrayList<Node> path = new ArrayList<Node>();
    for(int i=0; i<oldPath.size(); i++){
      path.add(oldPath.get(i));
    }

    Node lastNode = path.get(path.size()-1);

    // Agafem les linies que formen la intersecció.
    Line l1 = lastNode.linia[0];
    Line l2 = lastNode.linia[1];
    Line l3 = lastNode.linia.length>2 ? lastNode.linia[2] : null;
    
    // Agafem els nodes que estan connectats al node on ens trobem
    ArrayList<Node> punts_1 = buscaAltresPunts(lastNode, l1);
    ArrayList<Node> punts_2 = buscaAltresPunts(lastNode, l2);
    ArrayList<Node> punts_3 = l3 != null ? buscaAltresPunts(lastNode, l3) : null;
    Node[] punts = new Node[6];

    punts[0] = punts_1.size()>0 ? punts_1.get(0) : null;
    punts[1] = punts_1.size()>1 ? punts_1.get(1) : null;
    punts[2] = punts_2.size()>0 ? punts_2.get(0) : null;
    punts[3] = punts_2.size()>1 ? punts_2.get(1) : null;
    punts[4] = l3 != null && punts_3.size()>0 ? punts_3.get(0) : null;
    punts[5] = l3 != null && punts_3.size()>1 ? punts_3.get(1) : null;
   
    for(int i=0; i<6; i++){
      if(punts[i]!=null){ 

        ArrayList<Node> newPath = new ArrayList<Node>();
        for(int j=0; j<path.size(); j++){
          newPath.add(path.get(j));
        }
        newPath.add(punts[i]);  
        
        if(newPath.get(0)==newPath.get(newPath.size()-1)){
          if(newPath.size()>3){
            afegeixPolygon(newPath);
          }
        }else if(!liniaRepetida(newPath)){
          followPath(newPath);
          
        }
      }
    }
  } 

  boolean liniaRepetida(ArrayList<Node> path){
    
    int[] repeticions = new int[linies.size()];

    for(int i = 0; i<linies.size(); i++){
      repeticions[i] = 0;
    }

    for(int i = 0; i<path.size(); i++){
      
      repeticions[posicioLinia(path.get(i).linia[0])]++;
      repeticions[posicioLinia(path.get(i).linia[1])]++;
      
      if(path.get(i).linia.length>2 ){
        int position = posicioLinia(path.get(i).linia[2]);
        if(position>=0){
          repeticions[posicioLinia(path.get(i).linia[2])]++;
        }
      }
    }

    boolean massa_repeticions = false;

    for(int i = 0; i<repeticions.length; i++){
      
      if(repeticions[i]>2){
        massa_repeticions = true;
      }
      
    }

    return massa_repeticions;
  }
  
  void afegeixPolygon(ArrayList<Node> path){
    Polygon newPoly = new Polygon(path);
    newPoly.ordenaPath();
    polygon.add(newPoly);
    polygon.get(polygon.size()-1).ordenaPath();
  }

  String nodeArrayToString(Node[] array){
    String message = "";
    for(int i=0; i<array.length; i++){
      message += nodeToString(array[i]);
    }
    return message;
  }
  
  void printPath(ArrayList<Node> path){
    String message = "";
    for(int i=0; i<path.size(); i++){
      message += nodeToString(path.get(i));
    }
    println(message);
  }

  String nodeToString(Node node){
    if(node!=null){
      return "[" + node.pos.x + ", " + node.pos.y + "]";
    }
    return "[null]";
  }
  
  boolean sonElMateix(Node punt1, Node punt2){
    boolean son_el_mateix = true;
    if(abs(punt1.pos.x-punt2.pos.x)>0.0000001){
      son_el_mateix=false;
    }else if(abs(punt1.pos.y-punt2.pos.y)>0.0000001){
      son_el_mateix=false;
    }
    return son_el_mateix;
  }
  
  ArrayList<Node> buscaAltresPunts(Node node, Line linia){

    ArrayList<Node> altres_punts = new ArrayList<Node>();
    for(int i = 0; i<intersections.size(); i++){
      if(intersections.get(i)!=node && (intersections.get(i).linia[0] == linia || intersections.get(i).linia[1] == linia || (intersections.get(i).linia.length> 2 && intersections.get(i).linia[2]==linia))){
        altres_punts.add(intersections.get(i));
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
    for(int i = 0; i<linies.size(); i++){
      if(linies.get(i)==linia){
        return i;
      }
    }
    return -1;
  }

  boolean jaExisteix(Polygon pol){
    boolean ja_existeix = false;
    //Recorrem tots els polígons
    for(int i = 0; i<polygon.size(); i++){
      //Comencem considerant que si que existeix.
      boolean es_igual_1 = true;
      boolean es_igual_2 = true;
      
      int l = polygon.get(i).path.size();
      
      //Mirem si els dos polígons tenen el mateix nombre de nodes.
      if(l==pol.path.size()){
        //Recorrem cada posició del polígon i.
        for(int j=0; j<l; j++){
          if(pol.path.get(j).pos!=polygon.get(i).path.get(j).pos){
            es_igual_1 = false;
          }
          if(pol.path.get(0).pos!=polygon.get(i).path.get(0).pos){
            es_igual_2 = false;
          }
          if(j!=0){
            if(pol.path.get(j).pos!=polygon.get(i).path.get(l-j).pos){
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
