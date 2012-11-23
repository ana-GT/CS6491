/**
 * @file Triangle.pde
 */

/**
 * @class Triangle
 * @brief
 */
class Triangle {
    pt v1, v2, v3;
    /**
     * @function Triangle
     * @brief Constructor
     */
    Triangle( pt _v1, pt _v2, pt _v3 ) {
        v1 = _v1;
        v2 = _v2;
        v3 = _v3;
    }

    /**
     * @function getNormal
     * @brief
     */
    vec getNormal() {
        vec edge1 = new vec( v2.x-v1.x, v2.y-v1.y, v2.z-v1.z );
        vec edge2 = new vec( v3.x-v1.x, v3.y-v1.y, v3.z-v1.z );
        
        vec normal = N( edge1, edge2 ); // cross product
        // Normalize
        return U(normal);
    }

    /**
     * @function turnBack
     */
    void turnBack() {
        pt tmp = v3;
        v3 = v1;
        v1 = tmp;
    }

    /**
     * @function getLines
     * @brief
     */
    Line[] getLines() {
        Line[] l = {
            new Line(v1, v2),
            new Line(v2, v3),
            new Line(v3, v1)
        };
        return l;
    }

    /**
     * @function equals
     */
    public boolean equals( Triangle t ) {
        Line[] lines1 = getLines();
        Line[] lines2 = t.getLines();

        int cnt = 0;
        for(int i = 0; i < lines1.length; i++) {
            for(int j = 0; j < lines2.length; j++) {
                if (lines1[i].equals(lines2[j]))
                    cnt++;
            }
        }
        if (cnt == 3) {
          return true;
        }
        else {
          return false;
        }

    }
};

