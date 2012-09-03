/**
  * @file disk.pde
  * @author A. Huaman
  * @brief Disk class 
  */

/**
 * @class Disk
 */
class Disk {
  int x;
  int y;
  float r;
  color c;
  
  // Constructor
  Disk( int _x, int _y, float _r ) {    
    x = _x; y = _y; r = _r;
  }
  
  // setPos
  void setPos( int _x, int _y ) {
    x = _x;
    y = _y;  
  }
  
  // setRadius
  void setRadius( float _r ) {
    r = _r;
  }
  
  // setColor
  void setColor( color _c ) {
    c = _c;
  }
  
  // isInside
  Boolean isInside( int _x, int _y, float _r ) {
    if( r > _r ) {
      return false;
    }
    if( ( dist( x, y, _x, _y ) + r ) < _r ) {
      return true;
    }
    else {
    return false;
    }
  }
    
  // Draw
  void show() {
    
    stroke(0,0,0);
    strokeWeight(2);
    fill( c );
    ellipseMode(CENTER);
    ellipse(x, y, 2*r, 2*r);
  }
}

