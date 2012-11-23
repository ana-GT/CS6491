import java.util.concurrent.*;

/**
 * @class Delaunay
 */
class Delaunay {

    List<pt> vertices;  
    List<Tetrahedron> tetras; 

    List<Line> edges;

    List<Line> surfaceEdges;
    List<Triangle> triangles;


    /**
     * @function
     * @brief
     */
    Delaunay() {
        vertices = new CopyOnWriteArrayList<pt>();
        tetras = new CopyOnWriteArrayList<Tetrahedron>();
        edges = new CopyOnWriteArrayList<Line>();
        surfaceEdges = new CopyOnWriteArrayList<Line>();
        triangles = new CopyOnWriteArrayList<Triangle>();
    }

    /**
     * @function SetData
     * @brief
     */
    void SetData(List<pt> seq) {

        tetras.clear();
        edges.clear();

        // 
        pt vMax = new pt(-999, -999, -999);
        pt vMin = new pt( 999,  999,  999);
        for( pt v : seq ) {
            if (vMax.x < v.x) vMax.x = v.x;
            if (vMax.y < v.y) vMax.y = v.y;
            if (vMax.z < v.z) vMax.z = v.z;
            if (vMin.x > v.x) vMin.x = v.x;
            if (vMin.y > v.y) vMin.y = v.y;
            if (vMin.z > v.z) vMin.z = v.z;
        }

        pt center = new pt();     
        center.x = 0.5f * (vMax.x - vMin.x);
        center.y = 0.5f * (vMax.y - vMin.y);
        center.z = 0.5f * (vMax.z - vMin.z);
        float r = -1;                       // 半径
        for( pt v : seq) {
            if ( r < d(center, v) ) {
              r = d(center, v);
            }
        }
        r += 0.1f;          

        // 
        pt v1 = new pt();
        v1.x = center.x;
        v1.y = center.y + 3.0f*r;
        v1.z = center.z;

        pt v2 = new pt();
        v2.x = center.x - 2.0f*(float)Math.sqrt(2)*r;
        v2.y = center.y - r;
        v2.z = center.z;

        pt v3 = new pt();
        v3.x = center.x + (float)Math.sqrt(2)*r;
        v3.y = center.y - r;
        v3.z = center.z + (float)Math.sqrt(6)*r;

        pt v4 = new pt();
        v4.x = center.x + (float)Math.sqrt(2)*r;
        v4.y = center.y - r;
        v4.z = center.z - (float)Math.sqrt(6)*r;

        pt[] outer = {v1, v2, v3, v4};
        tetras.add(new Tetrahedron(v1, v2, v3, v4));

        // 
        ArrayList<Tetrahedron> tmpTList = new ArrayList<Tetrahedron>();
        ArrayList<Tetrahedron> newTList = new ArrayList<Tetrahedron>();
        ArrayList<Tetrahedron> removeTList = new ArrayList<Tetrahedron>();
        
        for( pt v : seq) {
            tmpTList.clear();
            newTList.clear();
            removeTList.clear();
            for (Tetrahedron t : tetras) {
                if( (t.o != null) && (t.r > d(v, t.o)) ) {
                    tmpTList.add(t);
                }
            }

            for (Tetrahedron t1 : tmpTList) {
                // 
                tetras.remove(t1);

                v1 = t1.vertices[0];
                v2 = t1.vertices[1];
                v3 = t1.vertices[2];
                v4 = t1.vertices[3];
                newTList.add(new Tetrahedron(v1, v2, v3, v));
                newTList.add(new Tetrahedron(v1, v2, v4, v));
                newTList.add(new Tetrahedron(v1, v3, v4, v));
                newTList.add(new Tetrahedron(v2, v3, v4, v));
            }

            boolean[] isRedundancy = new boolean[newTList.size()];
            for (int i = 0; i < isRedundancy.length; i++) isRedundancy[i] = false;
            for (int i = 0; i < newTList.size()-1; i++) {
                for (int j = i+1; j < newTList.size(); j++) {
                    if(newTList.get(i).equals(newTList.get(j))) {
                        isRedundancy[i] = isRedundancy[j] = true;
                    }
                }
            }
            for (int i = 0; i < isRedundancy.length; i++) {
                if (!isRedundancy[i]) {
                    tetras.add(newTList.get(i));
                }

            }
            
        }

        
        boolean isOuter = false;
        for ( Tetrahedron t4 : tetras ) {
            isOuter = false;
            for ( pt p1 : t4.vertices ) {
                for ( pt p2 : outer ) {
                    if ( p1.x == p2.x && p1.y == p2.y && p1.z == p2.z ) {
                        isOuter = true;
                    }
                }
            }
            if (isOuter) {
                tetras.remove(t4);
            }
        }

        triangles.clear();
        boolean isSame = false;
        for (Tetrahedron t : tetras) {
            for ( Line l1 : t.getLines() ) {
                isSame = false;
                for (Line l2 : edges) {
                    if (l2.equals(l1)) {
                        isSame = true;
                        break;
                    }
                }
                if (!isSame) {
                    edges.add(l1);
                }
            }
        }

        // *****       
        ArrayList<Triangle> triList = new ArrayList<Triangle>();
        for (Tetrahedron t : tetras) {
            v1 = t.vertices[0];
            v2 = t.vertices[1];
            v3 = t.vertices[2];
            v4 = t.vertices[3];

            Triangle tri1 = new Triangle(v1, v2, v3);
            Triangle tri2 = new Triangle(v1, v3, v4);
            Triangle tri3 = new Triangle(v1, v4, v2);
            Triangle tri4 = new Triangle(v4, v3, v2);

            vec n;
            // 
            n = tri1.getNormal();
            if( d(n,V(v1.x, v1.y, v1.z)) > d(n,V(v4.x, v4.y, v4.z)) ) { tri1.turnBack(); }

            n = tri2.getNormal();
            if( d(n,V(v1.x, v1.y, v1.z)) > d(n,V(v2.x, v2.y, v2.z)) ) { tri2.turnBack(); }

            n = tri3.getNormal();
            if( d(n,V(v1.x, v2.y, v2.z)) > d(n,V(v3.x, v3.y, v3.z)) ) { tri3.turnBack(); }

            n = tri4.getNormal();
            if( d(n,V(v2.x, v2.y, v2.z)) > d(n,V(v1.x, v1.y,v1.z)) ) { tri4.turnBack(); }

            triList.add(tri1);
            triList.add(tri2);
            triList.add(tri3);
            triList.add(tri4);
        }
        
        boolean[] isSameTriangle = new boolean[triList.size()];
        for(int i = 0; i < triList.size()-1; i++) {
            for(int j = i+1; j < triList.size(); j++) {
                if (triList.get(i).equals(triList.get(j))) isSameTriangle[i] = isSameTriangle[j] = true;
            }
        }
        for(int i = 0; i < isSameTriangle.length; i++) {
            if (!isSameTriangle[i]) triangles.add(triList.get(i));
        }

        surfaceEdges.clear();
        ArrayList<Line> surfaceEdgeList = new ArrayList<Line>();
        for(Triangle tri : triangles) {
            surfaceEdgeList.addAll(Arrays.asList(tri.getLines()));
        }
        boolean[] isRedundancy = new boolean[surfaceEdgeList.size()];
        for(int i = 0; i < surfaceEdgeList.size()-1; i++) {
            for (int j = i+1; j < surfaceEdgeList.size(); j++) {
                if (surfaceEdgeList.get(i).equals(surfaceEdgeList.get(j))) isRedundancy[j] = true;
            }
        }

        for (int i = 0; i < isRedundancy.length; i++) {
            if (!isRedundancy[i]) surfaceEdges.add(surfaceEdgeList.get(i));
        }
        
    }
}; // end class

