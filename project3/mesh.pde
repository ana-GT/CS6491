
/**
 * @class Mesh
 */
class Mesh {
  int mMaxNumV = 45000;
  int mMaxNumT = mMaxNumV*2;
  
  // Current number of vertices
  int mNumV = 0; // nv
  // Current number of triangles
  int mNumT = 0; // nt
  // Current number of corners (3 per triangle)
  int mNumC = 0; // nc
  
  // Current, previous and saved corners
  int mCc = 0;
  int mPc = 0;
  int mSc = 0;
  
  // Triangle marker
  boolean[] mVisible = new boolean[mMaxNumT];
  
  // 
  float mRadiusV = 2;
  
  // Primary tables
  pt[] mG = new pt[ mMaxNumV ];
  int[] mV = new int[3*mMaxNumT];
  int[] mO = new int[3*mMaxNumT];
  
  // Normal vectors
  vec[] mNormalV = new vec[mMaxNumV];
  vec[] mNormalT = new vec[mMaxNumT];
 
  // Rendering modes
  Boolean mFlatShading = false;
  Boolean mShowEdges = false;
  
  // Rendering stuff
  color mTrianglesColor = green;
 
  /**
   * @function Mesh
   * @brief Constructor
   */ 
  Mesh() {
    for( int i = 0; i < mMaxNumV; ++i ) {
      mG[i] = new pt();
    }
  }
  
  /**
   * @function resetCounters
   */
  void resetCounters() {
    mNumV = 0;
    mNumT = 0;
    mNumC = 0;
  }

  /**
   * @function addVertex
   */
  int addVertex( pt P ) {
    mG[mNumV].set(P);
    mNumV++;
    return (mNumV - 1);
  }

  /**
   * @function addVertex
   */  
  int addVertex( float x, float y, float z ) {
    mG[mNumV].x = x;
    mG[mNumV].y = y;
    mG[mNumV].z = z;
    
    mNumV++;
    return (mNumV - 1);
  }
  
  /**
   * @function addTriangle
   */
  void addTriangle( int i, int j, int k ) {
    mV[mNumC++] = i;
    mV[mNumC++] = j;
    mV[mNumC++] = k;
    
    mVisible[mNumT++] = true;
  }
  
  Boolean isOnG( pt _p ) {
    for( int i = 1; i < mNumV; ++i ) {
      if( mG[i].x == _p.x && mG[i].y == _p.y && mG[i].z == _p.z ) {
        return true;
      }
    }
    return false;
  }
  
 /***************** GET_VERTICES ****************/
 void getVerticesFromBallSet( ballSet _bs ) {
   
   pt vMax = new pt(-5000.0, -5000.0, -5000.0);
   pt vMin = new pt(5000.0, 5000.0, 5000.0);
   
   int numGridX = 20;
   int numGridY = 20;
   int numGridZ = 20;
   float thresh = 10;
   
   // Get max and min limits from balls
   println("Num balls: " + _bs.getNumBalls() + "\n" );
   ball b;
   for( int i = 0; i < _bs.getNumBalls(); ++i ) {
     b = _bs.getBall(i);

     if( vMax.x < b.p.x ) { vMax.x = b.p.x; }
     if( vMax.y < b.p.y ) { vMax.y = b.p.y; }
     if( vMax.z < b.p.z ) { vMax.z = b.p.z; }

     if( vMin.x > b.p.x ) { vMin.x = b.p.x; } 
     if( vMin.y > b.p.y ) { vMin.y = b.p.y; }
     if( vMin.z > b.p.z ) { vMin.z = b.p.z; }    
   }
   
   // Set off by radius at each extrem
   b = _bs.getBall(0);
   vMax.x = vMax.x + b.r;
   vMax.y = vMax.y + b.r;
   vMax.z = vMax.z + b.r;
   
   vMin.x = vMin.x - b.r;
   vMin.y = vMin.y - b.r;
   vMin.z = vMin.z - b.r;   
   println("Max: " + vMax.x + "," + vMax.y + "," + vMax.z + "Min: "+ vMin.x + "," + vMin.y + "," + vMin.z + "\n" );
    
    
   
   pt hit = new pt();
   pt From = new pt();
   
   // HITS UP DOWN
   int numHits = 0;
   for( int i = 0; i < numGridX; ++i ) {
     for( int j = 0; j < numGridZ; ++j ) {
       
       From.x = vMin.x + i*(vMax.x - vMin.x)/numGridX;
       From.y = vMax.y + thresh;
       From.z = vMin.z + j*(vMax.z - vMin.z)/numGridZ;       
       
       // Get first ball hit
       hit = _bs.getFirstBallHit( From, P(From.x, vMin.y, From.z) );
       if(  hit != null ) {
         //println("Hit[ " + numHits + "]:" + hit.x + "," + hit.y + "," + hit.z );
         // Save point as vertex
         addVertex( hit );
         numHits++;
       }    
     }
   }

   // HITS DOWN UP
   for( int i = 0; i < numGridX; ++i ) {
     for( int j = 0; j < numGridZ; ++j ) {
       
       From.x = vMin.x + i*(vMax.x - vMin.x)/numGridX;
       From.y = vMin.y - thresh;
       From.z = vMin.z + j*(vMax.z - vMin.z)/numGridZ;       
       
       // Get first ball hit
       hit = _bs.getFirstBallHit( From, P(From.x, vMax.y, From.z) );
       if(  hit != null && !isOnG(hit) ) {
         //println("Hit[ " + numHits + "]:" + hit.x + "," + hit.y + "," + hit.z );
         // Save point as vertex
         addVertex( hit );
         numHits++;
       }    
     }
   }
   
      // HITS LEFT RIGHT
   for( int i = 0; i < numGridY; ++i ) {
     for( int j = 0; j < numGridZ; ++j ) {
       
       From.x = vMax.x + thresh;       
       From.y = vMin.y + i*(vMax.y - vMin.y)/numGridY;
       From.z = vMin.z + j*(vMax.z - vMin.z)/numGridZ;       
       
       // Get first ball hit
       hit = _bs.getFirstBallHit( From, P( vMin.x, From.y, From.z) );
       if(  hit != null ) {
         //println("Hit[ " + numHits + "]:" + hit.x + "," + hit.y + "," + hit.z );
         // Save point as vertex
         addVertex( hit );
         numHits++;
       }    
     }
   }

      // HITS RIGHT LEFT
   for( int i = 0; i < numGridY; ++i ) {
     for( int j = 0; j < numGridZ; ++j ) {
       
       From.x = vMin.x - thresh;       
       From.y = vMin.y + i*(vMax.y - vMin.y)/numGridY;
       From.z = vMin.z + j*(vMax.z - vMin.z)/numGridZ;       
       
       // Get first ball hit
       hit = _bs.getFirstBallHit( From, P( vMax.x, From.y, From.z) );
       if(  hit != null ) {
         println("Hit[ " + numHits + "]:" + hit.x + "," + hit.y + "," + hit.z );
         // Save point as vertex
         addVertex( hit );
         numHits++;
       }    
     }
   }
   println("Done adding points! \n");
 }
  
 /***************** TRIANGULATION **************/
  
  /**
   * @function triangulate
   */
   void triangulate() {
     // Create a Delaunay object
     Delaunay d;
     d = new Delaunay();
     // Enter data
     List<pt> vertices;
     vertices = new ArrayList<pt>();
     println("Num vertices: " + mNumV + "\n");
     for( int i = 0; i < mNumV; ++i ) {
       vertices.add( mG[i] );
     }
     
     // Calculate Triangulation
     println("Start triangulation \n");
     d.SetData( vertices );
     println("Ended Triangulation \n");
     //Add our triangles
     for( int i = 0; i < (d.triangles).size(); ++i ) {
        Triangle t = (d.triangles).get(i);
        pt v1 = t.v1; pt v2 = t.v2; pt v3 = t.v3;
        addTriangle( getVInd(v1), getVInd(v2), getVInd(v3) );
     }
     println("Found " + (d.triangles).size() + "triangles \n");
   }

  /** 
   * @function getVInd
   */   
   int getVInd( pt _p ) {
     
     for( int i = 0; i < mNumV; ++i ) {
       pt v = mG[i];
       if( (_p.x == v.x) && _p.y == v.y && _p.z == v.z ) {
         return i;
       }
     }
     
     println("[getVInd] ERROR!!!, no found a corresponding vertex! \n");
     return -1;
   }
  
  /************** CORNER OPERATIONS **************/
  
  /**
   * @function t
   * @brief Triangle of a corner
   */
  int t( int c ) {
    return int(c/3);
  }
  
  /**
   * @function n
   * @brief next corner in the same t(c)
   */
  int n( int c ) {
    return 3*t(c) + (c+1) % 3;
  }
  
  /**
   * @function p
   * @brief previous corner in the same t(c)
   */
  int p( int c ) {
    return n(n(c));
  }

  /**
   * @function v
   * @brief ID of the vertex of c
   */
  int v( int c ) {
    return mV[c];
  }
  
   /**
   * @function o
   * @brief Opposite (or self if it has no opposite)
   */
  int o( int c ) {
    return mO[c];
  }


  /**
   * @function l
   * @brief Left neighbor (orn ext if n(c) has no opposite)
   */
  int l( int c ) {
    return o( n(c) );
  }

  /**
   * @function r
   * @brief Right neighbor (or previous if p(c) has no opposite)
   */
  int r( int c ) {
    return o( p(c) );
  }

  /**
   * @function s
   * @brief Swing around v(c) or around a border loop
   */
  int s( int c ) {
    return n( l(c) );
  }
  
  /**
   * @function u
   * @brief unswings around v(c) or around a border loop
   */
  int u( int c ) {
    return p( r(c) );
  }
  
  /**
   * @function c
   * @brief Returns first corner of a triangle t
   */  
  int c( int t ) {
    return t*3;
  }

  /**
   * @function b
   * @brief If faces a border (has no opposite)
   */
   boolean b( int c ) {
     return mO[c] == c; 
   }

  /**
   * @function vis
   * @brief true if triangle of c is visible
   */
  boolean vis( int c ) {
    return mVisible[ t(c) ];
  }
  
  // GEOMETRY FOR CORNER C
  pt g( int c ) { 
    return mG[v(c)]; 
  }
  
  
  /*************** DISPLAY VERTICES ***************/
  void showVertices() {
    noStroke();
    noSmooth();
    fill( metal, 150 );
    for( int v = 0; v < mNumV; ++v ) {
      show( mG[v], mRadiusV );
    }
    noFill();  
  }
  
  /*************** DISPLAY EDGES ***************/  
  /**
   * @function showEdges
   * @brief Show all edges
   */
  void showEdges() {
    for( int c = 0; c < mNumC; ++c ) {
      drawEdge(c);
    } 
  }
  
  /**
   * @function drawEdge
   * @brief Draw edge of t(c) opposite to c
   */
  void drawEdge( int c ) {
    
    stroke(black);
    strokeWeight(mRadiusV);
    show( g(p(c)), g(n(c)) );
    noStroke();
  }
  
  /**************** DISPLAY TRIANGLES****************/
  /**
   * @function shade
   * @brief Display triangle t
   */
  void shade( int t ) {
    if( mVisible[t] ) {
      if( mFlatShading ) {
        beginShape();
          vertex( g(3*t) );
          vertex( g(3*t+1) );
          vertex( g(3*t+2) );
        endShape(CLOSE);  
      }
      else { // By now the same since I have not implemeented normals
        beginShape();
          vertex( g(3*t) );
          vertex( g(3*t+1) );
          vertex( g(3*t+2) );
        endShape(CLOSE);       
      }  
    }
  }

  
  /**
   * @function showShrunkT
   */
  void showShrunkT( int  t, float e ) {
    if( mVisible[t] ) {
      showShrunk( g(3*t), g(3*t+1), g(3*t+2), e );
    }
  }
  
  /**
   * @function showAllTriangles
   */
  void showAllTriangles() {

    fill( mTrianglesColor );

    for( int t = 0; t < mNumT; ++t ) {
      if( mVisible[t] ) {
        if( mShowEdges ) {
          showShrunkT( t, mRadiusV );
        }
        else {
          shade(t);
        }
      } // end visible
    } // end for all triangles
    
    noFill();
  }
  
  
}; // end Mesh


