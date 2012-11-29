//*********************************************************************
//**                            3D template                          **
//**                 Jarek Rossignac, Oct  2012                      **   
//*********************************************************************
import processing.opengl.*;                
import javax.media.opengl.*; 
import javax.media.opengl.glu.*; 
import java.nio.*;
import java.util.ArrayList;
GL gl; 
GLU glu; 

// **************************************************************   
// GLOBAL VARIABLES FOR DISPLAY OPTIONS 
// **************************************************************   
Boolean 
  showMesh=true,
  translucent=false,   
  showSilhouette=true, 
  showNMBE=true,
  showSpine=true,
  showControl=true,
  showTube=true,
  showFrenetQuads=false,
  showFrenetNormal=false,
  filterFrenetNormal=true,
  showTwistFreeNormal=false, 
  showHelpText=false,
  gShowPathCurve = false,
  gShowPathCurveAnimated = false,
  gShowT0 = false;

// String SCC = "-"; // info on current corner
   
// **************************************************************   
//  VIEW PARAMETERS
// **************************************************************   
// Focus  set with mouse when pressing ';', eye, and up vector
pt F = P(0,0,0); 
pt T = P(0,0,0); 
pt E = P(0,0,1000); 
vec U = V(0,1,0);  

// Picked surface point Q and screen aligned vectors {I,J,K} set when picked
pt Q = P(0,0,0); 
vec I = V(1,0,0); 
vec J = V(0,1,0); 
vec K = V(0,0,1); 
void initView() {Q=P(0,0,0); I=V(1,0,0); J=V(0,1,0); K=V(0,0,1); F = P(0,0,0); E = P(0,0,1000); U=V(0,1,0); } // declares the local frames

// **************************************************************   
//  MESHES 
// **************************************************************   
Mesh M=new Mesh(); // meshes for models M0 and M1

float volume1=0, volume0=0;
float sampleDistance=1;

// **************************************************************   
// CURVES & SPINES 
// **************************************************************   
Curve C0 = new Curve(5), S0 = new Curve(), C1 = new Curve(5), S1 = new Curve();  // control points and spines 0 and 1
Curve C= new Curve(11,130,P());
int nsteps=250; // number of smaples along spine
float sd=10; // sample distance for spine
pt sE = P(), sF = P(); vec sU=V(); //  view parameters (saved with 'j'

/**
 * @function setup
 * @brief
 */
void setup() {
  size(800, 700, OPENGL);  
  setColors(); 
  sphereDetail(6); 
  
  // OpenGL and View setup
  glu= ((PGraphicsOpenGL) g).glu;  
  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  
  gl = pgl.beginGL();  
  pgl.endGL();
  // 3D settings
  initView(); 

  // Load meshes
  M.declareVectors();
  M.loadMeshVTS("data/horse.vts");
  M.resetMarkers().computeBox().updateON(); 
  // Set view
  F=P(); 
  E=P(0,0,500);
  
}
  
/**
 * @function draw
 * @brief
 */
void draw() {  
  background(indianRed);
  // Help
  if(showHelpText) {
    camera(); // 2D display to show cutout
    lights();
    fill(black); writeHelp();
    return;
    } 
    
  // 3D display : set up view 
  camera(E.x, E.y, E.z, F.x, F.y, F.z, U.x, U.y, U.z); // defines the view : eye, ctr, up
  // Direction of light: behind and above the viewer
  vec Li=U(A(V(E,F),0.1*d(E,F),J));   // vec Li=U(A(V(E,F),-d(E,F),J)); 
  directionalLight(255,255,255,Li.x,Li.y,Li.z); 
  specular(255,255,0); shininess(5);

  
  // Show mesh    
  if(showMesh) { 
     fill(yellow); 
     if(M.showEdges) { 
       stroke(white); 
     } else {
       noStroke(); 
     }
     M.showFront();
   } 
   
   // Pick seed corner   
   if(pressed) {
     if (keyPressed&&(key=='.')) {
       M.pickc_seed( Pick() );
     }
   }
 
 
   // Show mesh corner    
   if( showMesh) { fill(red); noStroke(); M.showc_seed(); M.showPathTriangles(); } 
   if( gShowT0 ) { M.showT0Triangles(); }
 
   // Show path curve
   if( gShowPathCurve ) { 
     M.showPathCurve(); 
     //M.showT0Triangles(); 
   }
   
   // Show path curve animated
   if( gShowPathCurveAnimated ) {
     M.showPathCurveAnimated();
   }
 
  // Edit mesh  
  if(pressed) {
     if (keyPressed&&(key=='x'||key=='z')) M.pickc(Pick()); // sets M.sc to the closest corner in M from the pick point
     if (keyPressed&&(key=='X'||key=='Z')) M.pickc(Pick()); // sets M.sc to the closest corner in M from the pick point
     }
 
  // -------------------------------------------------------- graphic picking on surface and view control ----------------------------------   
  if (keyPressed&&key==' ') T.set(Pick()); // sets point T on the surface where the mouse points. The camera will turn toward's it when the ';' key is released
  SetFrame(Q,I,J,K);  // showFrame(Q,I,J,K,30);  // sets frame from picked points and screen axes
  // rotate view 
 // rotate E around F
  if(!keyPressed&&mousePressed) {
		E=R(E,  PI*float(mouseX-pmouseX)/width,I,K,F); 
		E=R(E,-PI*float(mouseY-pmouseY)/width,J,K,F); }  
	//   Moves E forward/backward	
  if(keyPressed&&key=='f'&&mousePressed) {
		E=P(E,-float(mouseY-pmouseY),K); 
	}  
	//   Moves E up/down	
  if(keyPressed&&key=='a'&&mousePressed) {
		E=P(E, float(mouseY-pmouseY),J ); 
	}  
	//   Moves E forward/backward and rotatees around (F,Y)
  if(keyPressed&&key=='d'&&mousePressed) {
		E=P(E,-float(mouseY-pmouseY),K);
		U=R(U, -PI*float(mouseX-pmouseX)/width,I,J); 
	}
   
  // -------------------------------------------------------- Disable z-buffer to display occluded silhouettes and other things ---------------------------------- 
  hint(DISABLE_DEPTH_TEST);  // show on top
  stroke(black); if(showControl) {C0.showSamples(2);}
  if(showMesh&&showSilhouette) {stroke(dbrown); M.drawSilhouettes(); }  // display silhouettes
  strokeWeight(2); stroke(red);if(showMesh&&showNMBE) M.showMBEs();  // manifold borders
  camera(); // 2D view to write help text
  writeFooterHelp();
  hint(ENABLE_DEPTH_TEST); // show silouettes

  // -------------------------------------------------------- SNAP PICTURE ---------------------------------- 
   if(snapping) snapPicture(); // does not work for a large screen
    pressed=false;

 } // end draw
 
 
 // ****************************************************************************************************************************** INTERRUPTS
Boolean pressed=false;

void mousePressed() {pressed=true; }
  
void mouseDragged() {
//  if(keyPressed&&key=='a') {C.dragPoint( V(.5*(mouseX-pmouseX),I,.5*(mouseY-pmouseY),K) ); } // move selected vertex of curve C in screen plane
//  if(keyPressed&&key=='s') {C.dragPoint( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); } // move selected vertex of curve C in screen plane
//  if(keyPressed&&key=='b') {C.dragAll(0,5, V(.5*(mouseX-pmouseX),I,.5*(mouseY-pmouseY),K) ); } // move selected vertex of curve C in screen plane
 // if(keyPressed&&key=='v') {C.dragAll(0,5, V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); } // move selected vertex of curve Cb in XZ
//  if(keyPressed&&key=='x') {M.add(float(mouseX-pmouseX),I).add(-float(mouseY-pmouseY),J); M.normals();} // move selected vertex in screen plane
//  if(keyPressed&&key=='z') {M.add(float(mouseX-pmouseX),I).add(float(mouseY-pmouseY),K); M.normals();}  // move selected vertex in X/Z screen plane
//  if(keyPressed&&key=='X') {M.addROI(float(mouseX-pmouseX),I).addROI(-float(mouseY-pmouseY),J); M.normals();} // move selected vertex in screen plane
 // if(keyPressed&&key=='Z') {M.addROI(float(mouseX-pmouseX),I).addROI(float(mouseY-pmouseY),K); M.normals();}  // move selected vertex in X/Z screen plane 
  }

void mouseReleased() {
     U.set(M(J)); // reset camera up vector
    }
  
void keyReleased() {
   if(key==' ') F=P(T);                           //   if(key=='c') M0.moveTo(C.Pof(10));
   U.set(M(J)); // reset camera up vector
} 

/**
 * @function keyPressed
 */ 
void keyPressed() {
  
  if( key=='m' ) {showMesh=!showMesh;}
  if( key=='l' ) {
    println("Pressed l");
    M.loadMeshVTS();
    M.updateON().resetMarkers().computeBox(); 
    F.set(M.Cbox); 
    E.set(P(F,M.rbox*2,K)); 
    //for(int i=0; i<10; i++) vis[i]=true;
  }
  if( key=='W' ) {M.saveMeshVTS();}
  if( key=='-' ) {M.showEdges=!M.showEdges;}
  if( key=='[' ) {initView(); F.set(M.Cbox); E.set(P(F,M.rbox*2,K));}
  if( key==']' ) {F.set(M.Cbox);}
  if( key=='?' ) {showHelpText=!showHelpText;}
  if( key=='.' ) {} // pick corner
  
  // Ring Expander - Hamiltonian thing
  if( key=='p' ) { 
    M.ring_expander();     
    M.getPathCurve();
  }
  // Curve around the Hamiltonian thing  
  if( key=='c' ) {
    gShowPathCurve = !gShowPathCurve;
  }
  if( key == 'x' ) {
      gShowPathCurveAnimated = !gShowPathCurveAnimated;
      gShowPathCurve = !gShowPathCurveAnimated;
      M.resetAnimatedDraw();      
  }
  if( key == 'y' ) {
    M.increaseDrawCurrentPoint();
  }
  
  if( key == 'u' ) {
    M.drawCurrentPath = M.pathCurves.size() - 1;
    M.drawCurrentPoint = M.pathCurves.get( M.pathCurves.size() - 1 ).n - 1;
  }
  
  if( key == 'q' ) {
    gShowT0 = !gShowT0;
  }
} 

float [] Volume = new float [3];
float [] Area = new float [3];
float dis = 0;
  
Boolean prev=false;

void showGrid(float s) {
  for (float x=0; x<width; x+=s*20) line(x,0,x,height);
  for (float y=0; y<height; y+=s*20) line(0,y,width,y);
  }
  
  // Snapping PICTURES of the screen
PImage myFace; // picture of author's face, read from file pic.jpg in data folder
int pictureCounter=0;
Boolean snapping=false; // used to hide some text whil emaking a picture
void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); snapping=false;}

 

