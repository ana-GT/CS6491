/**
 * @file ballGame.pde
 * @author A. Huaman
 * @brief Ball game
 * @date 2012/08/26
 */
 
//-- Global variables
Player A; // Human
Player B; // Human 
Player Main; // Computer

//-- Mouse variables
int pressedX; int pressedY;
int pmouseX; int pmouseY;

//-- Disk variables
int numDisks = 7;
float[] radii = {50, 20,60, 40, 25, 30, 40};

//int numDisks = 8;
//float[] radii = {20, 10, 10, 15, 16,25, 20, 10};

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
  // Create Main
  Main = new Player( 0, 0, width, height, "Main" );
  
// Initialize both players
  A.init( numDisks, radii );
  B.init( numDisks, radii );  
  Main.init( numDisks, radii );  

  // Create font
  initFonts();

  // Game over
  GameOver = false;
 }
 
 /**
  * @function draw
  */
 void draw() {
   
   if( Main.played == true ) {
     Main.drawState();	     
     displayMessageCenter( EndMessage );
  } // end Main.played
  else {
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
  } // end else Main.played
   //snapPicture();

 }
 
 /**
  * @function keyPressed
  */
 void keyPressed() {
   
   // A chooses to play
   if( key == 'a' ) {
     B.mode = false;
     A.mode =true;
   }

   // B chooses to play
   if( key == 'b') {
     A.mode = false;
     B.mode = true;
   }
   
   // End of turn play: Calculate pack radius
   if( key == 's' ) {
     if( A.mode ) { A.played = true; A.pack(); A.mode = false; }
     if( B.mode ) { B.played = true; B.pack(); B.mode = false; }
   }

   // Display results
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
   // Make the current circle tangent to its two closest neighbors
   if( key == 't' ) {
			if( A.mode ) { A.makeTangent(); }
      if( B.mode ) { B.makeTangent(); }
  }

   // Computer plays
   if( key == 'c' ) {
    // Change mode to play
    Main.mode = true;
 
   // Let's PLAY
   Main.masterSolve1();
   Main.played = true; Main.pack(); Main.mode = false;
   
   // Message
   if( Main.packRadius < A.packRadius && Main.packRadius < B.packRadius ) {
     EndMessage = "Computer is the winner!";
   }
  }   

   // Computer plays
   if( key == 'd' ) {
    // Change mode to play
    Main.mode = true;
 
   // Let's PLAY
   Main.masterSolve2();
   Main.played = true; Main.pack(); Main.mode = false;
   
   // Message
   if( Main.packRadius < A.packRadius && Main.packRadius < B.packRadius ) {
     EndMessage = "Computer is the winner!";
   }
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
 
