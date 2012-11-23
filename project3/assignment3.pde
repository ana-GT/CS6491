/** 
 * @file assignment3.cpp
 */
import processing.opengl.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import java.nio.*;

/*** GLOBAL VARIABLES **/
ballSet gBs;
Mesh gM;

// OpenGL variables
GL gGl;
GLU gGlu;

// View parameters
pt gF = P(0,0,0);
pt gT = P(0,0,0);
pt gE = P(0,0,1000);
vec gU = V(0,1,0);

pt gQ = P(0,0,0);
vec gI = V(1, 0, 0);
vec gJ = V(0, 1, 0);
vec gK = V(0, 0, 1);

// Display options
Boolean gMousePressed = false;
Boolean gbAddingBallFlag = false;
Boolean gbDeleteBallsFlag = false;

/**
 * @function setup
 */
void setup() {
  
  size( 600, 600, OPENGL );
  setColors();
  sphereDetail(15);
  
  // OpenGL and View setup
  gGlu = ((PGraphicsOpenGL)g).glu;
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  gGl = pgl.beginGL();
  pgl.endGL();
  
  // Declares the local frame for 3D GUI
  initView();
    
  gBs = new ballSet();
  gBs.addPlaneOfBalls( 5, 6, 50, 0, -100, 0 );
  
  //gM = new Mesh();
  //gM.getVerticesFromBallSet( gBs );
/*
    for (int i = 0; i < 100; i++) {
    float r = 90 + random(0.01f);
    float phi = radians(random(-90, 90));
    float theta = radians(random(360));
    gM.addVertex( new pt(r*cos(phi)*cos(theta), r*sin(phi), r*cos(phi)*sin(theta)) );
  }
*/  
//  gM.triangulate();
}

/**
 * @function draw
 */
void draw() {
  background(magenta);
  setupView();
  noStroke();
  lights();
  
  gBs.draw();
  //gM.showVertices();
  //gM.showEdges();
  //gM.showAllTriangles();
  manipulation3DScreen();
  ballHandling();
  
}

/**
 * @function ballHandling
 */
void ballHandling() {
  
  if( mousePressed ) { 
    // Spray one ball
    if( keyPressed && key == 'm' ) {
      
      if( !gbAddingBallFlag ) {
        gbAddingBallFlag = true;
        pt p = Pick();
      
        println("Picking: " + p.x + "," + p.y + "," + p.z);
        ball b = new ball( p.x, p.y, p.z, 50, getRandomColor() );
        gBs.addBall(b);
      }
    }
    // Delete balls
    if( keyPressed && key == 'n' ) {
     
      if( !gbDeleteBallsFlag ) {
        gbDeleteBallsFlag = true;
        pt p = Pick();
        gBs.deleteBallsHitByRay( gE, p );
      }
      
    }
  }
  
  if( keyPressed && key == 'x' ) {
    Boolean b = gBs.getBallsVisibility();
    gBs.setBallsVisibility( !b );
  }
  
}

/**
 * @function setupView
 */
void setupView() {
  
  // 3D Display: Setup view: Eye, Focus and Up
  camera( gE.x, gE.y, gE.z, 
          gF.x, gF.y, gF.z, 
          gU.x, gU.y, gU.z );
         
  // Light pointing slightly up the focus        
  vec Li = U( A( V( gE,gF), 0.1*d( gE, gF), gJ) );        
  directionalLight( 255, 255, 255, 
                    Li.x, Li.y, Li.z );
  specular( 255, 255, 0 );
  shininess( 5 );    
}

/**
 * @function initView
 * @brief Declares the local frames
 */
void initView() {
  gQ = P(0,0,0);
  // I, J, K
  gI = V(1,0,0);
  gJ = V(0,1,0);
  gK = V(0,0,1);
  //  Focus, Eye and Up direction
  gF = P(0,0,0);
  gE = P(0,0,500);
  gU = V(0,1,0);
}

/**
 * @function manipulation3DScreen
 */
void manipulation3DScreen() {
  

  if( mousePressed ) {
    
    if( keyPressed ) {

      // Moves E forward, backwards      
      if( key == 'd' ) {
        gE = P( gE, -float(mouseY - pmouseY), gK );
      }
      
      // Moves E forwards/backward and rotates around (F,Y)
      if( key == 'a' ) {
        gE = P( gE, -float( mouseY - pmouseY), gK);
        gU = R( gU, -PI*float( mouseX - pmouseX) / width, gI, gJ );
      }
      
    } // keyPressed
    
    // key no Pressed
    else {
      // Rotate E around F
      gE = R( gE, PI*float( mouseX - pmouseX )/width, gI, gK, gF );
      gE = R( gE, -PI*float( mouseY - pmouseY )/width, gJ, gK, gF );
    }
  } // mousePressed
  
  if( keyPressed ) {
    if( key == ' ' ) {
      gT.set( Pick() );
    }
  }
  
 // Show frame 
 SetFrame( gQ, gI, gJ, gK );
  
}

/**
 * @function mouseReleased
 * @brief Clear all current stuff going on
 */
void mouseReleased() {
  
  // Adding a ball
  gbAddingBallFlag = false;
  gbDeleteBallsFlag = false;
}

/**
 * @function keyReleased
 */
void keyReleased() {
  
  if( key == ' ' ) {
    gF = P(gT);
  }
  
  // Reset camera up vector
  //gU.set( M(gJ) );
}
