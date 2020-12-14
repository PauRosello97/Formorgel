/*
 *  ported from p bourke's triangulate.c
 *  http://astronomy.swin.edu.au/~pbourke/modelling/triangulate/
 *  fjenett, 20th february 2005, offenbach-germany.
 *  contact: http://www.florianjenett.de/
 */

class Triangulator
{

  class Edge
  {
    Node p1, p2;

    Edge() { 
      p1 = p2 = null;
    }

    Edge(Node p1, Node p2)
    {
      this.p1 = p1;
      this.p2 = p2;
    }
  }

  boolean sharedVertex(Triangle t1, Triangle t2) {
    return t1.p1 == t2.p2 || t1.p1 == t2.p2 || t1.p1 == t2.p3 ||
      t1.p2 == t2.p1 || t1.p2 == t2.p2 || t1.p2 == t2.p3 ||
      t1.p3 == t2.p1 || t1.p3 == t2.p2 || t1.p3 == t2.p3;
  }

  void sortXList(ArrayList<Node> ps)
  {
    int l = ps.size();
    PVector p1, p2, pi;
    int r;
    for (int i = 0; i < l-1; i ++)
    {
      pi = ps.get(i).pos;
      p1 = pi.get();
      p2 = pi.get();
      r = i;
      for (int j = i+1; j < l; j++)
      {
        p1 = ps.get(j).pos;        
        if (p1.x < p2.x)
        {
          p2 = p1.get();
          r = j;
        }
      }        
      if (r != i)
      {
        Node tmpv = ps.get(r);
        ps.set(r, ps.get(i));
        ps.set(i, tmpv);
      }
    }
  }

  void sortXArray(PVector[] ps)
  {
    int l = ps.length;
    PVector p1, p2, pi;
    int r;
    for (int i = 0; i < l-1; i ++)
    {
      pi = ps[i];
      p1 = pi.get();
      p2 = pi.get();
      r = i;
      for (int j = i+1; j < l; j++)
      {
        p1 = ps[j];
        if (p1.x < p2.x)
        {
          p2 = p1.get();
          r = j;
        }
      }
      if (r != i)
      {
        ps[r] = pi;
        ps[i] = p2;
      }
    }
  }

  /*
      Triangulation subroutine
   Takes as input vertices (PVectors) in ArrayList pxyz
   Returned is a list of triangular faces in the ArrayList triangles
   These triangles are arranged in a consistent clockwise order.
   */
  void triangulate(ArrayList<Node> pxyz, ArrayList<Triangle> triangles)
  {
    // sort vertex array in increasing x values
    sortXList(pxyz);

    // Find the maximum and minimum vertex bounds. This is to allow calculation of the bounding triangle
    float
      xmin = pxyz.get(0).pos.x, 
      ymin = pxyz.get(0).pos.y, 
      xmax = xmin, 
      ymax = ymin;

    for (Node p : pxyz) {
      if (p.pos.x < xmin) xmin = p.pos.x;
      else if (p.pos.x > xmax) xmax = p.pos.x;
      if (p.pos.y < ymin) ymin = p.pos.y;
      else if (p.pos.y > ymax) ymax = p.pos.y;
    }

    float
      dx = xmax - xmin, 
      dy = ymax - ymin, 
      dmax = dx > dy ? dx : dy, 
      two_dmax = dmax*2, 
      xmid = (xmax+xmin) * .5, 
      ymid = (ymax+ymin) * .5;

    ArrayList<Triangle> complete = new ArrayList<Triangle>(); // for complete Triangles

    /*
        Set up the supertriangle
     This is a triangle which encompasses all the sample points.
     The supertriangle coordinates are added to the end of the
     vertex list. The supertriangle is the first triangle in
     the triangle list.
     */
     
    Triangle superTriangle = new Triangle(new Node(xmid-two_dmax, ymid-dmax), new Node(xmid, ymid+two_dmax), new Node(xmid+two_dmax, ymid-dmax));
    triangles.add(superTriangle);

    //Include each point one at a time into the existing mesh
    ArrayList<Edge> edges = new ArrayList<Edge>();
    PVector circle;
    boolean inside;

    for (Node p : pxyz) {
      edges.clear();

      //Set up the edge buffer. If the point (xp,yp) lies inside the circumcircle then the three edges of that triangle are added to the edge buffer and that triangle is removed.
      circle = new PVector();       

      for (int j = triangles.size ()-1; j >= 0; j--)
      {    
        Triangle t = triangles.get(j);
        if (complete.contains(t)) continue;

        inside = CircumCircle.circumCircle(p.pos, t, circle);

        if (circle.x+circle.z < p.pos.x) complete.add(t);
        if (inside)
        {
          edges.add(new Edge(t.p1, t.p2));
          edges.add(new Edge(t.p2, t.p3));
          edges.add(new Edge(t.p3, t.p1));
          triangles.remove(j);
        }
      }

      // Tag multiple edges. Note: if all triangles are specified anticlockwise then all interior edges are opposite pointing in direction.
      int eL = edges.size()-1, eL_= edges.size();
      Edge e1 = new Edge(), e2 = new Edge();

      for (int j=0; j<eL; e1= edges.get (j++)) for (int k=j+1; k<eL_; e2 = edges.get (k++))
        if (e1.p1 == e2.p2 && e1.p2 == e2.p1) e1.p1 = e1.p2 = e2.p1 = e2.p2 = null;

      //Form new triangles for the current point. Skipping over any tagged edges. All edges are arranged in clockwise order.
      for (Edge e : edges) {
        if (e.p1 == null || e.p2 == null) continue;
        triangles.add(new Triangle(e.p1, e.p2, p));
      }
    }

    //Remove triangles with supertriangle vertices
    for (int i = triangles.size ()-1; i >= 0; i--) if (sharedVertex(triangles.get(i), superTriangle)) triangles.remove(i);
  }

  
}
