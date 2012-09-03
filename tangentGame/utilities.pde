//-- Picture counter
int pictureCounter = 0;
//-- Font
PFont f;
PFont fBig;
PFont fInst;
int fontSize = 16;

/**
 * @function initFonts
 */
void initFonts() {
  f = createFont("Arial", fontSize, true);
  fBig = createFont("Serif", 2*fontSize, true);  
  fInst = createFont( "Serif", 1.2*fontSize, true );
}

/**
 * @function getDist
 */
float getDist( float _x1, float _y1, float _x2, float _y2 ) {
  return sqrt( pow( (_x1 - _x2), 2) + pow( (_y1 - _y2), 2) );
}

 /**
 * @function displayInstructions()
 */
 void displayInstructions() {
  String S = " [a]: Player A turn * [b]: Player B turn * [s]: End of turn * [ENTER]: Results * [q] Restart";
  displayMessageBottom( S, 1 );
 }


/**
 * @function displayMessage
 */
void displayMessage( String _S, int _x, int _y ) {
   textFont(fInst);
   fill(0,0,0);
   textAlign(CENTER); 
   text( _S, _x, _y ); 
} 

/**
 * @function displayMessageBottom
 */
void displayMessageBottom( String _S, int _line ) {
   textFont(fInst);
   fill(0,0,0);
   textAlign(CENTER); 
   text( _S, width /2, height - fontSize*_line ); 
} 


/**
 * @function displayMessageCenter
 */
void displayMessageCenter( String _S ) {
   textFont(fBig);
   fill(255,0,50);
   textAlign(CENTER);
   text( _S, width /2, height/2, 4 ); 
} 

/**
 * @function MouseMessage
 */
  void MouseMessage() {
    textFont(f);
    fill(0, 0, 0);
    text( "(" + str(mouseX) + "," + str(mouseY) + ")", mouseX, mouseY );
  }

/**
  * @function snapPicture
  */
void snapPicture() {
 saveFrame( "Pictures/" + nf(pictureCounter++, 6) + ".png" );
}
