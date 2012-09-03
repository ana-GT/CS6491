/**
 * @file ballGame.pde
 * @author A. Huaman
 * @brief Ball game
 * @date 2012/08/26
 */
 
//-- Global variables
Player A;
Player B;

//-- Mouse variables
int pressedX; int pressedY;
int pmouseX; int pmouseY;

//-- Disk variables
int numDisks = 7;
float[] radii = {50, 20,60, 40, 25, 30, 40};


//-- Final message
String EndMessage;
Boolean GameOver;

/*
 * @function setup
 */
 void setup() {
  size(1000,600);
  frameRate(20);
  A = new Player( 0, 0, width/2, height, "A" );
  B = new Player( width/2, 0, width, height, "B" );

  // Initialize both players
  A.init( numDisks, radii );
  B.init( numDisks, radii );  

  
  // Create font
  initFonts();

  // Game over
  GameOver = false;
 }
 
 /**
  * @function draw
  */
 void draw() {
   
   // Draw current state
   A.drawState();
   B.drawState();
   displayInstructions();
   
   if( mousePressed ) {
    if( A.mode && !A.played ) {
      A.moveSelectedDisk( mouseX - pmouseX, mouseY - pmouseY );
    }
    if( B.mode && !B.played ) {
      B.moveSelectedDisk( mouseX - pmouseX, mouseY - pmouseY );      
    }  
    
    pmouseX = mouseX;
    pmouseY = mouseY;
   }
   
   if( GameOver ) {
     displayMessageCenter( EndMessage );
   }

   //snapPicture();
 }
 
 /**
  * @function keyPressed
  */
 void keyPressed() {
   
   if( key == 'a' ) {
     B.mode = false;
     A.mode =true;
   }
   if( key == 'b') {
     A.mode = false;
     B.mode = true;
   }
   
   if( key == 's' ) {
     if( A.mode ) { A.played = true; A.pack(); A.mode = false; }
     if( B.mode ) { B.played = true; B.pack(); B.mode = false; }
   }
   if( keyCode == ENTER ) {
      String S;
     if( A.packRadius < B.packRadius ) {
      EndMessage = "A is the winner!";
     }
     else if( B.packRadius < A.packRadius ) {
      EndMessage = "B is the winner!";
     }
     else {
      EndMessage = "A and B got the same result!";
     }
     GameOver = true;
   }
   
   if( key == 'q' ) {
     A.init( numDisks, radii );
     B.init( numDisks, radii );
   }
 }
 
/**
 * @function mousePressed
 */
 void mousePressed() {
   
   pressedX = mouseX;
   pressedY = mouseY;
   pmouseX = mouseX; 
   pmouseY = mouseY;
   
   if( A.mode == true ) {
     A.getSelectedDisk( pressedX, pressedY );
   }
   else {
     B.getSelectedDisk( pressedX, pressedY );
   }

 }
 
