/**
 * @file ballSet
 */
 import java.util.ArrayList;

/**
 * @class ballSet
 */
class ballSet {
  
  ArrayList<ball> mBalls;
  Boolean mVisibility;

  /**
   * @function ballSet
   * @brief Constructor
   */
  ballSet() {
    mBalls = new ArrayList<ball>();
    mVisibility = true;
  };
 
  /**
   * @function addBall
   */
  int addBall( ball _b ) {
    mBalls.add( _b );
    
    return ( mBalls.size() - 1 );
  } 
 
  /**
   * @function getBall
   */
  ball getBall( int _i ) {
    return mBalls.get(_i);
  }
  
  /**
   * @function addPlaneOfBalls
   */
   void addPlaneOfBalls( int _depth, int _length, float _r,
                         float _x, float _z, float _y ) {
    
     for( int i = 0; i < _depth; ++i ) {
       for( int j = 0; j < _length; ++j ) {

         float bx = _x - _r*(_depth - 2) + i*(2*_r);
         float bz = _z - _r*(_length - 2) + j*(2*_r); 
         float by = _y;
       
         ball b = new ball( bx, by, bz, _r, getRandomColor() );
         addBall( b );       
       }
     }                       
                           
   }
   
  /**
   * @function setBallsVisibility
   */
  void setBallsVisibility( Boolean _vis ) {
    mVisibility = _vis;
  }

  /**
   * @function setBallsVisibility
   */
  Boolean getBallsVisibility() {
    return mVisibility;
  }
  
  /**
   * @function draw
   */
  void draw() {
    if( mVisibility ) {
      for( int i = 0; i < mBalls.size(); ++i ) {
        ( mBalls.get(i) ).draw();
      }
    }
  }
  
  /**
   * @function getFirstBallHit
   */
  pt getFirstBallHit( pt _From, pt _To ) {
  
    float dist;
    float minDist = 5000;
    pt minHit = new pt();
    Boolean flag = false;
    
    for( int i = 0; i < getNumBalls(); ++i ) {
      ball b = mBalls.get(i);
      if( b.isHitByRay( _From, _To ) ) {
        pt hit = b.getHitPoint( _From, _To );
        
        dist = d(hit, _From);
        if( dist < minDist ) {
          minDist = dist;
          minHit = hit;
        }  
        flag = true;
      }   
    }   
    
    if( flag ) {
      return minHit;
    }   
    else {
      return null; 
    }
  }
  
  
  /**
   * @function rayHitBalls
   */
   void rayHitBalls( pt _E, pt _P ) {
     
     for( int i = 0; i < getNumBalls(); ++i ) {
       if( ( mBalls.get(i) ).isHitByRay( _E, _P ) ) {
         println("Ball " + i + " was mortally hit by ray!! \n");
       }   
     }
   }
   
   /**
    * @function deleteBallsHitByRay
    */
   void deleteBallsHitByRay( pt _E, pt _P ) {
   
    int ind = 0;
    
    for( int i = 0; i < getNumBalls(); ++i ) {
      if( ( mBalls.get(ind) ).isHitByRay( _E, _P ) ) {
        mBalls.remove(ind);
        ind--;
      }  
     ind++; 
    }
     
   }
   
     
  /******** UTILITIES ************/
  int getNumBalls() {
    return mBalls.size();
  }
};
