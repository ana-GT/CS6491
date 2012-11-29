// color utilities in RBG color mode
color red, yellow, green, cyan, blue, magenta, dred, dyellow, dgreen, dcyan, dblue, dmagenta, white, black, orange, grey, metal, dorange, brown, dbrown;
color darkGreen;
color forestGreen;
color limeGreen;
color chartreuse;
color springGreen;
color indianRed;

void setColors() {
   red = color(250,0,0);        dred = color(150,0,0);
   magenta = color(250,0,250);  dmagenta = color(150,0,150); 
   blue = color(0,0,250);     dblue = color(0,0,150);
   cyan = color(0,250,250);     dcyan = color(0,150,150);
   green = color(0,250,0);    dgreen = color(0,150,0);
   yellow = color(250,250,0);    dyellow = color(150,150,0);  
   orange = color(250,150,0);    dorange = color(150,50,0);  
   brown = color(150,150,0);     dbrown = color(50,50,0);
   white = color(255,255,255); black = color(0,0,0); grey = color(100,100,100); metal = color(150,150,250);
   darkGreen = color(0,100,0);
   forestGreen = color(34,139,34);
   limeGreen = color(50,205,50);
   chartreuse = color(127, 255, 0);
   springGreen = color(0, 255, 127);
   indianRed = color( 205, 92, 92);
  }
 color ramp(int v, int mv) {return color(int(float(255)*v/mv),100,int(float(255)*(mv-v)/mv)) ; }
