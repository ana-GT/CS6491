/**
 * @class ball
 */
class ball {
  
  pt p;
  float r;
  color c;
  
  ball() {
    p = new pt();
  };
  
  ball( float _x, float _y, float _z, float _r,
        color _c ) {
    
    p = new pt( _x, _y, _z );
    r = _r;
    c = _c;
  }

  /**
   * @function setPos
   * @brief
   */
  void setPos( float _x, float _y, float _z ) {
    p.set( _x, _y, _z );
  }
  
  /**
   * @function setRadius
   */
  void setRadius( float _r ) {
    r = _r;
  }
  
  /** 
   * @function setColor
   * @brief
   */
  void setColor( color _c ) {
    c = _c;
  }
  
  /**
   * @function draw
   * @brief
   */
  void draw() {
    pushMatrix();
    translate( p.x, p.y, p.z );
    fill(c);
    sphere(r);
    popMatrix();
  }

  /**
   * @function getDistToRay
   */  
  float getDistToRay( pt _E, pt _P ) {
    
    vec EC = V( _E, p );
    vec uEP = U( V( _E, _P ) );
    
    float proj = d( EC, uEP );
    pt D = P( _E, proj, uEP );
    
    return d( p, D );
  }
  
  /**
   * @function isHitByRay
   */
  Boolean isHitByRay( pt _E, pt _P ) {
    
    float d = getDistToRay( _E, _P );
    if( d <= r ) {
      return true;
    }
    else {
      return false;
    }
  }
  
  /**
   * @function getHitPoint
   */
  pt getHitPoint( pt _From, pt _To ) {  
  
    vec FP = V( _From, p );
    vec uFT = U( V( _From, _To ) );
    
    float proj = d( FP, uFT );
    pt D = P( _From, proj, uFT );
    
    float m = d( p, D );
    float inD = sqrt( r*r - m*m );
    
    pt hit = P( _From, (proj - inD), uFT );
    return hit;      
  }
  
};
