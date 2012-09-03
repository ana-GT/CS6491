/**
  * @file player.pde
  * @author A. Huaman
  * @brief Player class implementation
  */

float BIG_NUMBER = 10000;

/**
 * @class Player
 */
class Player {
  
  // Switches
  Boolean mode; /**< If player is ON or OFF*/
  Boolean played; /**< If player is still playing or have finished */
  
  // Window variables
  float x1; float x2; float y1; float y2;
  String name;
  
  // Disks variables
  int numDisks;
  float maxRadius;
  float minRadius;
    
  int selectedDisk;
  
  Disk[] disks;
  
  float thresh=0.005;
  
  // Packing variables
  float packRadius;
  float packX; float packY;
  
  /**
   * @function Constructor
   */
  Player( float _x1, float _y1, float _x2, float _y2, String _name ) {
    x1 = _x1; y1 = _y1;
    x2 = _x2; y2 = _y2;    
    name = _name;
    mode = false;
    played = false;
  }
    
  /**
   * @function init
   */  
  void init( int _numDisks, float[] _radii ) {
    mode = false;
    played = false;
    numDisks = 0; 
    minRadius = 0; maxRadius = 0;
    selectedDisk = 0;
    loadDisks( _numDisks, _radii );  
    packRadius = 0;
  }
    
  /**
   * @function loadDisks
   */
  void loadDisks( int _numDisks, float[] _radii ) {
    
    numDisks = _numDisks;     
    disks = new Disk[_numDisks];    
    
    for( int i = 0; i < _numDisks; ++i ) {
      
      disks[i] = new Disk( 0, 0, _radii[i] );
      color c = color( int(random(255)), int(random(255)), int(random(255)) );
      disks[i].setColor( c );
      
      if( i == 0 ) {
         minRadius = _radii[i];
         maxRadius = _radii[i];
      }
      else {
        if( _radii[i] > maxRadius ) { maxRadius = _radii[i]; }
        if( _radii[i] < minRadius ) { minRadius = _radii[i]; }
      }
     }
    initDisks();
  }
      
  /**
   * @function initDisks
   */
  void initDisks() {
    float prevCenter = 0;
    float currCenter;
    
    for( int i = 0; i < numDisks; ++i ) {
      
      if( i == 0 ) {
        currCenter = prevCenter + ( disks[i].r );
      }
      else {
        currCenter = prevCenter  + (disks[i].r) + (disks[i-1].r) + 10; // 10 default separation so they don't appear together
      }
      
      disks[i].setPos( width / 2, currCenter );
      prevCenter = currCenter;      
    }
  }

  /**
   * @function drawDisks
   */
  void drawDisks() {   
    for( int i = 0; i < numDisks; ++i ) {
      disks[i].show();
    }
  }  
  
  /**
   * @function drawPackDisk
   */
  void drawPackDisk() {
    stroke(0,0,0);
    strokeWeight(2);
    noFill();
    ellipseMode(CENTER);
    ellipse( packX, packY, packRadius*2, packRadius*2 );
  }
  
  /**
   * @function getSelectedDisk
   */
  void getSelectedDisk( float _pressedX, float _pressedY ) {
    
    float minDist = 0; 
    int minInd = 0;
    float curDist;
    
    for( int i = 0; i < numDisks; ++i ) {
      if( i == 0 ) {
        minDist = getDist( disks[i].x, disks[i].y, _pressedX, _pressedY );
        minInd = i;
      }
      else {
        curDist = getDist( disks[i].x, disks[i].y, _pressedX, _pressedY );
        if( curDist < minDist ) {
          minDist = curDist; minInd = i;
        }
      }
      
    }
    
    selectedDisk = minInd;
 
  }
  
  /**
   * @function moveSelectedDisk
   */
  Boolean moveSelectedDisk( float _dx, float _dy ) {
    float x = disks[selectedDisk].x;
    float y = disks[selectedDisk].y;
    disks[selectedDisk].setPos( _dx + x, _dy + y );
    if( checkAllCollisions( selectedDisk) == true ) {
        disks[selectedDisk].setPos( x, y );     
        return false;   
    }
    MouseMessage();
    return true;
  }     

  /**
   * @function moveDiskTo
   */
  Boolean moveDiskTo( int _ind, float _newX, float _newY ) {
    float x = disks[_ind].x;
    float y = disks[_ind].y;
    disks[_ind].setPos( _newX, _newY );
    if( checkAllCollisions( _ind ) == true ) {
        disks[_ind].setPos( x, y );     
        return false;   
    }
    MouseMessage();
    return true;
  }     

  
  /**
   * @function drawState
   */
  void drawState() {

    if( mode == true ) {
      stroke( 0, 0, 0);
      strokeWeight(4);
      fill(200, 0, 100);
      rect( x1, y1, x2, y2);
      drawDisks();
      String S = "Player " + name + " you are ON!";
      displayMessage( S, int( (x1 + x2 )/ 2 ), int(y1 + 40) );
      
    }

    else if( mode == false && played == false) {
      stroke( 0, 0, 0);
      strokeWeight(4);     
      fill( 255, 255, 255, 120 );
      rect( x1, y1, x2, y2 );
      String S = "Player " + name + " you are OFF!";
      displayMessage( S, int( (x1 + x2 )/ 2 ), int( y1 + 40 ) );
    }
    
    else if ( mode == false && played == true ){
      stroke( 0, 0, 0);
      strokeWeight(4);     
      fill( 50, 255, 50, 120 );
      rect( x1, y1, x2, y2 );
      drawDisks();
      if( packRadius < BIG_NUMBER ) {
        drawPackDisk();
      }   
      String S = "Player " + name + " you have played. Your radius is: " + str(packRadius);
      displayMessage( S, int( (x1 + x2 )/ 2 ), int( y1 + 40 ) );   

    }
  }

  /**
   * @function checkCollisions
   */
  Boolean checkCollisions( int _i, int _j ) {
    float d = getDist( disks[_i].x, disks[_i].y, disks[_j].x, disks[_j].y );
    if( d < disks[_i].r + disks[_j].r - thresh) {
      println("Detected collision between disks " + str(_i) + " and " + str(_j) + " by " + str( disks[_i].r + disks[_j].r - d) );    
      return true;
    }
    else {
      return false;
    }
  }  
  
  /** 
   * @function checkAllCollisions
   */
  Boolean checkAllCollisions( int _i ) {
    for( int i = 0; i < numDisks; ++i ) {
      if( i != _i ) {
        if( checkCollisions( i, _i ) == true ) {
          return true;
        }
      }
    }
    
    return false;
  }

  /**
   * @function pack
   */
  Boolean pack() {
   Boolean b =false;
   packRadius = BIG_NUMBER;
   float minRadius = BIG_NUMBER;
   float minX = 0;
   float minY = 0;
   
   Boolean flag = false;
   
   for( int r = int(maxRadius); r < 3*maxRadius; r++ ) {
     
     for( int x = int(x1); x < int(x2); x++ ) {

       for( int y = int(y1); y < int(y2); y++ ) {

         b = isBigEnough( x, y, float(r) );
         if( b == true ) {
           if( r < minRadius ) {
            minRadius = r;
            minX = x;
            minY = y;
            flag = true;
           }
         }
         if( flag == true ) { break; }
       } // y for
         if( flag == true ) { break; }
     } // x for
       if( flag == true ) { break; }
   } // r for
   
   packRadius = minRadius;
   packX = minX;
   packY = minY;
   if( packRadius < BIG_NUMBER ) {
     return true;
   }
   return false;
    
  }
  
  /**
   * @function isBigEnough
   */
  Boolean isBigEnough( float _x, float _y, float _r ) {
    for( int i = 0; i < numDisks; ++i ) {
      if( disks[i].isInside( _x, _y, _r ) == false ) {
        return false;
      } 
    }
    
    return true;
  }

 /**
  * @function Make Tangent
  */
  void makeTangent() {
    // 1. Identify the two closest disks
    int dT[]; 
    dT = getTanDisks( selectedDisk ); 
    println("Tangents are disks " + str(dT[0]) + " and " + str(dT[1]));
    
    // Try to put them together
    float[][] Txy;
    Txy = disks[selectedDisk].setTangent( disks[dT[0]], disks[dT[1]] );
        
    if( moveDiskTo( selectedDisk, Txy[0][0], Txy[0][1] ) == false ) {
      println("Failed 1: Target position was:  " + str(Txy[0][0]) +" , " +str(Txy[0][1]) );

      if( moveDiskTo( selectedDisk, Txy[1][0], Txy[1][1] ) == false ) {
         println("Failed 2: Target position was:  " + str(Txy[1][0]) +" , " +str(Txy[1][1]) );
        println("No moved for collisions or something \n");
      }
      else {
        println("Made tangent! \n");
      }
    }
    else {
      println("Made tangent! \n");
    }
  }  
  
  /**
   * @function getTanDisks
   */
  int[] getTanDisks( int _disk ) {

    // Get all distances and min
    float min_d = BIG_NUMBER; 
    int min_ind = -1;
    
    int[] dT; 
    dT = new int[2];

    float d[]; 
    d = new float[numDisks];
    
    // Get closest disk 
    for( int i = 0; i < numDisks; ++i ) {
      d[i] = getDist( disks[_disk].x, disks[_disk].y, disks[i].x, disks[i].y ) - ( disks[_disk].r + disks[i].r);
      if( i != _disk ) {
        if( min_d > d[i] ) {
          min_d = d[i]; min_ind = i;
        }
      }
    }        

    // Save it
    dT[0] = min_ind;

    // Get second closest disk
    d[min_ind] = BIG_NUMBER; 
    min_d = BIG_NUMBER; min_ind = -1;

    for( int i = 0; i < numDisks; ++i ) {
      if( i != _disk && i != dT[0] ) {
        if( min_d > d[i] ) {
          min_d = d[i]; min_ind = i;
        }
      }
    }        
    
    // Save it
    dT[1] = min_ind;
    
    return dT;  
  } // end of getTanDisk
  
  
  /**
   * @function masterSolve
   */
   void masterSolve() {
     
     // 1. Sort circles
     int[] SD;
     SD = sortDisks( disks, numDisks );

/*
     for( int i = 0; i < numDisks; ++i ) {
       println("Disk [" + str(i) + "]: radius: " + str(disks[SD[i]].r) + " \n" );
     }
*/
    // 2. Locate first 
    moveDiskTo( SD[0], (x2 - x1) / 4, (y2 - y1)/2 );

    // 3. Put second to east -- CAREFUL, if you use EAST or WEST you might get an error in tangent
    float[] dxy;
    dxy = disks[SD[1]].getOrientMove( 0, disks[SD[0]] );
    moveDiskTo( SD[1], dxy[0], dxy[1] );
    
    // 3. Move the rest of disks
    Boolean flag = false;
    float[][] Txy;  
    for( int i = 2; i < numDisks; ++i ) {
      flag = false;
      // Check all possible combinations
      for( int j = 0; j < i - 1; ++j ) {
        for( int k = j+1; k < i; ++k ) {

          Txy = disks[ SD[i] ].setTangent( disks[ SD[j] ], disks[ SD[k] ] );      
            if( moveDiskTo( SD[i], Txy[0][0], Txy[0][1] ) == false ) {
              if( moveDiskTo( SD[i], Txy[1][0], Txy[1][1] ) == false ) {
                println("No done anything \n");
              } else{ flag = true;}
            }  else { flag = true; }
          
          if( flag == true ) { break; }
        } // for k
          if( flag == true ) { break; }
      } // for j
      
    } // end for i
    
   } // end masterSolve
   
   /**
    * @function sortDisks
    */
   int[] sortDisks( Disk[] _disks, int _numDisks ) {
     int[] sortedDisks;
     sortedDisks = new int[numDisks];
     
     int hI; int temp;
     for( int i = 0; i < numDisks; ++i ) {
         hI = i;
       for( int j = 0; j < i; ++j ) {
         if( _disks[ hI].r > _disks[ sortedDisks[j] ].r ) {
           temp = sortedDisks[j];
           sortedDisks[j] = hI;
           hI = temp;
         }
       }
       
       sortedDisks[i] = hI;
     }
     
     return sortedDisks;
   }
}

