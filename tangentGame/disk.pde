/**
  * @file disk.pde
  * @author A. Huaman
  * @brief Disk class 
  */

/**
 * @class Disk
 */
class Disk {
  float x;
  float y;
  float r;
  color c;
  
  /**
   * @function Constructor
   */
  Disk( float _x, float _y, float _r ) {    
    x = _x; y = _y; r = _r;
  }
  
  /**
   * @function setPos
   */
  void setPos( float _x, float _y ) {
    x = _x;
    y = _y;  
  }
  
  /**
   * @function setRadius
   */
  void setRadius( float _r ) {
    r = _r;
  }
  
  /**
   * @function setColor
   */
  void setColor( color _c ) {
    c = _c;
  }
  
  /**
   * @function isInside
   */
  Boolean isInside( float _x, float _y, float _r ) {
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
    
  /**
   * @function show
   */
  void show() {
    
    stroke(0,0,0);
    strokeWeight(2);
    fill( c );
    ellipseMode(CENTER);
    ellipse(x, y, 2*r, 2*r);
  }
  
  /**
   * @function setTangent
   */
  float[][] setTangent( Disk _dT1, Disk _dT2 ) {

    // Set return value
    float[][] Txy;
    Txy = new float[2][2];
    
    // 0. Set values
    float D = _dT1.r + _dT2.r;
    float D1 = _dT1.r + r;
    float D2 = _dT2.r + r;
    float x2 = _dT2.x; float y2 = _dT2.y;
    float x1 = _dT1.x; float y1 = _dT1.y;    
    float x21 = x2 - x1; 
    float y21 = y2 - y1;
    
    // 1. Find cosines
    float cos_a = ( D1*D1 + D2*D2 - D*D) / (2*D1*D2);
    float cos_a1 = ( D1*D1 + D*D - D2*D2) / (2*D1*D);
    float cos_a2 = ( D2*D2 + D*D - D1*D1) / (2*D2*D);

    // 2. First equation that relates x and y
    // cos_a1 = u_{C1C2}u_{C1C}/||.||
    // y = ax + b
    float a = -x21 / y21;
    float b = ( x21*x1 + y21*y1 + D*D1*cos_a1 ) / y21;
    float e = D1*D2*cos_a - x1*x2 - y1*y2;
    float c = x1 + x2;
    float d = y1 + y2;
    
    float m = 1 + a*a;
    float n = 2*a*b - c - a*d;
    float p = b*b - d*b - e;
    
    // Find the points
    float dis = sqrt( n*n - 4*m*p );
    Txy[0][0] = ( -n + dis ) / (2*m); Txy[0][1] = a*Txy[0][0] + b;
    Txy[1][0] = ( -n - dis ) / (2*m); Txy[1][1] = a*Txy[1][0] + b;   
    
    return Txy;
  } // end setTangent function
  
  /**
   * @function getOrientMove
   */
   float[] getOrientMove( int _ind, Disk _ref ) {

     float rx = _ref.x;
     float ry = _ref.y;
     float rr = _ref.r;

     float[] dxy; dxy = new float[2];
     
     switch( _ind ) {
       // North
       case 0 : {
         dxy[0] = rx;
         dxy[1] = ry - rr - r;        
       } break;
       
       // South
       case 1: {
         dxy[0] = rx;
         dxy[1] = ry + rr + r;        
       } break;
       
       // East
       case 2: {
         dxy[0] = rx + rr + r;
         dxy[1] = ry;        
       } break;

       // West
       case 3: {
         dxy[0] = rx - rr - r;
         dxy[1] = ry;        
       } break;       
       
     } // end of switch
     return dxy;
   } // end of getOrientMove
  
}
