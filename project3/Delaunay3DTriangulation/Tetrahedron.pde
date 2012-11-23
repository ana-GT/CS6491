/**
 * @file Tetrahedron.pde
 */

/**
 * @class Tetrahedron
 */
class Tetrahedron {
  
    pt[] vertices;
    pt o;      // Center of inside sphere
    float r;      // Radius of sphere

    /**
     * @function Tetrahedron
     * @brief Constructor
     */
    Tetrahedron( pt[] _v) {
        vertices = _v;
        getCenterCircumcircle();
    }

    /**
     * @function Tetrahedron
     * @brief Constructor
     */
    Tetrahedron( pt _v1, pt _v2, pt _v3, pt _v4 ) {
        vertices = new pt[4];
        vertices[0] = _v1;
        vertices[1] = _v2;
        vertices[2] = _v3;
        vertices[3] = _v4;
        getCenterCircumcircle();
    }

    /**
     * @function equals
     * @brief
     */
    boolean equals(Tetrahedron _t) {
        int count = 0;
        for ( pt p1 : vertices) {
            for ( pt p2 : _t.vertices) {
                if ( p1.x == p2.x && p1.y == p2.y && p1.z == p2.z ) {
                    count++;
                }
            }
        }
        if (count == 4) {
          return true;
        }
        else {
          return false;
        }
    }
    
    /**
     * @function getLines
     * @brief Return 6 edges of the tetrahedron
     */
    public Line[] getLines() {
        pt v1 = vertices[0];
        pt v2 = vertices[1];
        pt v3 = vertices[2];
        pt v4 = vertices[3];

        Line[] lines = new Line[6];

        lines[0] = new Line(v1, v2);
        lines[1] = new Line(v1, v3);
        lines[2] = new Line(v1, v4);
        lines[3] = new Line(v2, v3);
        lines[4] = new Line(v2, v4);
        lines[5] = new Line(v3, v4);
        return lines;
    }

    /**
     * @function getCenterCircumcircle
     * @brief
     */
    private void getCenterCircumcircle() {
      
        pt v1 = vertices[0];
        pt v2 = vertices[1];
        pt v3 = vertices[2];
        pt v4 = vertices[3];

        double[][] A = {
            {v2.x - v1.x, v2.y-v1.y, v2.z-v1.z},
            {v3.x - v1.x, v3.y-v1.y, v3.z-v1.z},
            {v4.x - v1.x, v4.y-v1.y, v4.z-v1.z}
        };
        
        double[] b = {
            0.5 * (v2.x*v2.x - v1.x*v1.x + v2.y*v2.y - v1.y*v1.y + v2.z*v2.z - v1.z*v1.z),
            0.5 * (v3.x*v3.x - v1.x*v1.x + v3.y*v3.y - v1.y*v1.y + v3.z*v3.z - v1.z*v1.z),
            0.5 * (v4.x*v4.x - v1.x*v1.x + v4.y*v4.y - v1.y*v1.y + v4.z*v4.z - v1.z*v1.z)
        };
        
        double[] x = new double[3];
        if (gauss(A, b, x) == 0) {
            o = null;
            r = -1;
        } else {
            o = new pt( (float)x[0], (float)x[1], (float)x[2] );
            r = d(o, v1); // Distance
        }
    }

    /**
     * @function lu
     * @brief
     */
    private double lu( double[][] a, int[] ip ) {
        int n = a.length;
        double[] weight = new double[n];

        for(int k = 0; k < n; k++) {
            ip[k] = k;
            double u = 0;
            for(int j = 0; j < n; j++) {
                double t = Math.abs(a[k][j]);
                if (t > u) u = t;
            }
            if (u == 0) {
              return 0;
            }
            weight[k] = 1/u;
        }
        double det = 1;
        for(int k = 0; k < n; k++) {
            double u = -1;
            int m = 0;
            for(int i = k; i < n; i++) {
                int ii = ip[i];
                double t = Math.abs(a[ii][k]) * weight[ii];
                if(t>u) { u = t; m = i; }
            }
            int ik = ip[m];
            if (m != k) {
                ip[m] = ip[k]; ip[k] = ik;
                det = -det;
            }
            u = a[ik][k]; det *= u;
            if (u == 0) return 0;
            for (int i = k+1; i < n; i++) {
                int ii = ip[i]; double t = (a[ii][k] /= u);
                for(int j = k+1; j < n; j++) a[ii][j] -= t * a[ik][j];
            }
        }
        return det;
    }
  
    /**
     * @function solve
     * @brief
     */    
    private void solve(double[][] a, double[] b, int[] ip, double[] x) {
        int n = a.length;
        for(int i = 0; i < n; i++) {
            int ii = ip[i]; double t = b[ii];
            for (int j = 0; j < i; j++) t -= a[ii][j] * x[j];
            x[i] = t;
        }
        for (int i = n-1; i >= 0; i--) {
            double t = x[i]; int ii = ip[i];
            for(int j = i+1; j < n; j++) t -= a[ii][j] * x[j];
            x[i] = t / a[ii][i];
        }
    }
    
    /**
     * @function gauss
     * @brief
     */    
    private double gauss(double[][] a, double[] b, double[] x) {
        int n = a.length;
        int[] ip = new int[n];
        double det = lu(a, ip);

        if(det != 0) { solve(a, b, ip, x);}
        return det;
    }
};
