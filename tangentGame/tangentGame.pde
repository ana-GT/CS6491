/**
 * @file tangentGame.pde
 * @author A. Huaman
 * @brief Tangent game
 * @date 2012/09/02
 */
 
//-- Global variables
Player Main;

//-- Mouse variables
int pressedX; int pressedY;
int pmouseX; int pmouseY;

//-- Disk variables
//int numDisks = 7;
//float[] radii = {50, 20,60, 40, 25, 30, 40};
int numDisks = 6;
float[] radii = {80, 57, 36, 76,59,87};

//-- Final message
String EndMessage;
Boolean GameOver;

/*
 * @function setup
 */
 void setup() {
  size(1000,600);
  frameRate(20);
  Main = new Player( 0, 0, width, height, "Main" );

  // Initialize Main player
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
   
   // Draw current state
   Main.drawState();
   displayInstructions();
   
   if( mousePressed ) {
    if( Main.mode && !Main.played ) {
      Main.moveSelectedDisk( mouseX - pmouseX, mouseY - pmouseY );
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
   
   if( key == 'm' ) {
     println("m pressed \n");
     Main.mode = true;
   }
   
   if( key == 's' ) {
     if( Main.mode ) { Main.played = true; Main.pack(); Main.mode = false; }
   }
   if( keyCode == ENTER ) {
     GameOver = true;
   }
   if( key == 't' ) {
     Main.makeTangent( );
   }
   
   if( key == 'q' ) {
     Main.init( numDisks, radii );
   }
   
   if( key == 'c' ) {
     Main.masterSolve();
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
   
   if( Main.mode == true ) {
     Main.getSelectedDisk( pressedX, pressedY );
   }

 } 
