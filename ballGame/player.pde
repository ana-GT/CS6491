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
  int x1; int x2; int y1; int y2;
  String name;
  
  // Disks variables
  int numDisks;
  float maxRadius;
  float minRadius;
    
  int selectedDisk;
  
  Disk[] disks;
  
  // Packing variables
  float packRadius;
  int packX; int packY;
  
  //-- Constructor
  Player( int _x1, int _y1, int _x2, int _y2, String _name ) {
    x1 = _x1; y1 = _y1;
    x2 = _x2; y2 = _y2;    
    name = _name;
    mode = false;
    played = false;
  }
    
  //-- Init  
  void init( int _numDisks, float[] _radii ) {
    mode = false;
    played = false;
    numDisks = 0; 
    minRadius = 0; maxRadius = 0;
    selectedDisk = 0;
    loadDisks( _numDisks, _radii );  
    packRadius = 0;
  }
    
  //-- load Disks
  void loadDisks( int _numDisks, float[] _radii ) {
    
    numDisks = _numDisks;     
    disks = new Disk[_numDisks];    
    
    for( int i = 0; i < _numDisks; ++i ) {
      
      disks[i] = new Disk( 0,0, _radii[i] );
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
      
  //-- initDisks
  void initDisks() {
    int prevCenter = 0;
    int currCenter;
    
    for( int i = 0; i < numDisks; ++i ) {
      
      if( i == 0 ) {
        currCenter = prevCenter + int( disks[i].r );
      }
      else {
        currCenter = prevCenter  + int(disks[i].r) + int(disks[i-1].r) + 10;
      }
      
      disks[i].setPos( width / 2, currCenter );
      prevCenter = currCenter;      
    }
  }

  //-- drawDisks
  void drawDisks() {   
    for( int i = 0; i < numDisks; ++i ) {
      disks[i].show();
    }
  }  
  
  //-- drawPackDisk
  void drawPackDisk() {
    stroke(0,0,0);
    strokeWeight(2);
    noFill();
    ellipseMode(CENTER);
    ellipse( packX, packY, packRadius*2, packRadius*2 );
  }
  
  //-- getSelectedDisk
  void getSelectedDisk( int _pressedX, int _pressedY ) {
    
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
  
  //-- moveSelectedDisk
  void moveSelectedDisk( int _dx, int _dy ) {
    int x = disks[selectedDisk].x;
    int y = disks[selectedDisk].y;
    disks[selectedDisk].setPos( _dx + x, _dy + y );
    if( checkAllCollisions( selectedDisk) == true ) {
        disks[selectedDisk].setPos( x, y );        
    }
    MouseMessage();
  }     
  
  //-- drawState
  void drawState() {

    if( mode == true ) {
      stroke( 0, 0, 0);
      strokeWeight(4);
      fill(200, 0, 100);
      rect( x1, y1, x2, y2);
      drawDisks();
      String S = "Player " + name + " you are ON!";
      displayMessage( S, (x1 + x2 )/ 2, y1 + 40 );
      
    }

    else if( mode == false && played == false) {
      stroke( 0, 0, 0);
      strokeWeight(4);     
      fill( 255, 255, 255, 120 );
      rect( x1, y1, x2, y2 );
      String S = "Player " + name + " you are OFF!";
      displayMessage( S, (x1 + x2 )/ 2, y1 + 40 );
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
      displayMessage( S, (x1 + x2 )/ 2, y1 + 40 );   

    }
  }

  //-- Check Collisions
  Boolean checkCollisions( int _i, int _j ) {
    float d = getDist( disks[_i].x, disks[_i].y, disks[_j].x, disks[_j].y );
    if( d < disks[_i].r + disks[_j].r ) {
      return true;
    }
    else {
      return false;
    }
  }  
  
  //-- Check All Collisions
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

  //-- Pack disks
  Boolean pack() {
   Boolean b =false;
   packRadius = BIG_NUMBER;
   float minRadius = BIG_NUMBER;
   int minX = 0;
   int minY = 0;
   
   Boolean flag = false;
   
   for( int r = int(maxRadius); r < 3*maxRadius; r++ ) {
     
     for( int x = x1; x < x2; x++ ) {

       for( int y = y1; y < y2; y++ ) {

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
  
  // Get BoundingBox
  
  
  //-- Check this disk
  Boolean isBigEnough( int _x, int _y, float _r ) {
    for( int i = 0; i < numDisks; ++i ) {
      if( disks[i].isInside( _x, _y, _r ) == false ) {
        return false;
      } 
    }
    
    return true;
  }
  
}

