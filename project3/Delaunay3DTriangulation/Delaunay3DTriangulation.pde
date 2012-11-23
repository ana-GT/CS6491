/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/31295*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

List<pt> vec;

Delaunay d;
Scene scene;

/**
 * @function setup
 * @brief
 */
public void setup() {
  size(400, 300, P3D);

  d = new Delaunay();
  scene = (Scene)new Scene1();
  scene.setEnable();
  background(0);
  
  vec = new ArrayList<pt>();
  for (int i = 0; i < 400; i++) {
    float r = 90 + random(0.1f);
    float phi = radians(random(-90, 90));
    float theta = radians(random(360));
    vec.add(new pt(r*cos(phi)*cos(theta), r*sin(phi), r*cos(phi)*sin(theta)));
  }
  d.SetData(vec);
}

float t = 0;
public void draw() {
  t += 0.01f;
  scene = scene.update();
}

//**************************************************************************
interface Scene {
  Scene update();
  void setEnable();
}



    class Scene1 implements Scene {
        boolean isEnable;
        Scene1() { }
        public Scene update() {
            background(0);
            camera (-200*sin(t), 0, -200*cos(t), 0, 0, 0, 0, -1, 0);
            //lights();

            stroke(255, 200);
            smooth();
            strokeWeight(3);
            for(pt v: vec) {
                point(v.x, v.y, v.z);
            }
            if (!isEnable) return this;
            if (mousePressed) {
                isEnable = false;
                return new SceneMoveDissolve(this, new Scene2());
            }
            return this;
        }
        public void setEnable() {
            this.isEnable = true;
        }
    }

    class Scene2 implements Scene {
        boolean isEnable;
        Scene2() { }
        public Scene update() {
            background(0);
            camera (-200*sin(t), 0, -200*cos(t), 0, 0, 0, 0, -1, 0);
            //lights();

            stroke(255, 200);
            strokeWeight(3);
            for( pt v: vec) {
                point(v.x, v.y, v.z);
            }

            stroke(200);
            strokeWeight(1);
            for(Line l: d.edges) {
                line(l.start.x, l.start.y, l.start.z,
                        l.end.x, l.end.y, l.end.z);
            }
            if (!isEnable) return this;
            if (mousePressed) {
                isEnable = false;
                return new SceneMoveDissolve(this, new Scene3());

            }
            return this;
        }
        public void setEnable() {
            this.isEnable = true;
        }
    }

    class Scene3 implements Scene {
        boolean isEnable;
        Scene3() { }
        public Scene update() {
            background(0);
            camera (-200*sin(t), 0, -200*cos(t), 0, 0, 0, 0, -1, 0);
            //lights();
            stroke(255, 200);
            strokeWeight(3);
            for( pt v: vec) {
                point(v.x, v.y, v.z);
            }

            stroke(200);
            strokeWeight(1);
            for(Line ls: d.surfaceEdges) {
                line(ls.start.x, ls.start.y, ls.start.z,
                        ls.end.x, ls.end.y, ls.end.z);
            }
            if (!isEnable) return this;
            if (mousePressed) {
                isEnable = false;
                return new SceneMoveDissolve(this, new Scene4());

            }
            return this;
        }
        public void setEnable() {
            this.isEnable = true;
        }
    }

    class Scene4 implements Scene {
        boolean isEnable;
        Scene4() { }
        public Scene update() {
            background(0);
            pushMatrix();
            camera();
            lights();
            popMatrix();
            camera (-200*sin(t), 0, -200*cos(t), 0, 0, 0, 0, -1, 0);
            
            noStroke();
            fill(230, 250, 255);
            
            
            beginShape(TRIANGLES);
            for(Triangle tri : d.triangles) {
                noSmooth();
                pt v1 = tri.v1;
                pt v2 = tri.v2;
                pt v3 = tri.v3;

                vertex(v1.x, v1.y, v1.z);
                vertex(v2.x, v2.y, v2.z);
                vertex(v3.x, v3.y, v3.z);
            }
            endShape();
            noLights();

            if (!isEnable) return this;
            if (mousePressed) {
                isEnable = false;
                return new SceneMoveDissolve(this, new Scene1());

            }
            return this;
        }
        public void setEnable() {
            this.isEnable = true;
        }
    }

class SceneMoveCube implements Scene {
  private Scene current, next;
  private PImage curImage, nextImage;  // 
  private float heading;  // 

  public void setEnable() { }
  public SceneMoveCube(Scene cur, Scene next) {
    this.current = cur;
    this.next = next;
    this.curImage = createImage(width, height, RGB);
    this.nextImage = createImage(width, height, RGB);
    this.heading = 0;
  }

  public Scene update() {
    // 
    fill(255);
    current.update();
    loadPixels();
    for(int i = 0; i < pixels.length; ++i)
      curImage.pixels[i] = pixels[i];
    updatePixels();

    fill(255);
    next.update();
    loadPixels();
    for(int i = 0; i < pixels.length; ++i)
      nextImage.pixels[i] = pixels[i];
    updatePixels();
    fill(255);

    background(0);
    camera();
    lights();

    pushMatrix();
    translate(width/2, height/2, -width/2);
    rotateY(radians(heading-=1.5));

    noSmooth();  // 
    noStroke();
    beginShape(QUAD_STRIP);
    texture(curImage);
    for(int i = 0; i <= width; i+=10) {
      vertex(-width/2 + i, -height/2, width/2, i, 0);
      vertex(-width/2 + i,  height/2, width/2, i, height);
    }
    endShape();

    beginShape(QUAD_STRIP);
    texture(nextImage);
    for(int i = 0; i <= width; i+=10) {
      vertex(width/2, -height/2, width/2-i, i, 0);
      vertex(width/2,  height/2, width/2-i, i, height);
    }
    endShape();
    popMatrix();

    if(heading <= -90) {
        next.setEnable();
        return next;
    }
    return this;
  }
}

// 
class SceneMoveDissolve implements Scene {
  private final int MAX = 50;
  private Scene current, next;
  private PImage curImage, nextImage;  // 
  private int[] dissolvablePixels;
  private int index;

  public void setEnable() { }
  public SceneMoveDissolve(Scene cur, Scene next) {
    this.current = cur;
    this.next = next;
    this.index = 0;
    this.curImage = createImage(width, height, RGB);
    this.nextImage = createImage(width, height, RGB);
    this.dissolvablePixels = new int[width*height];
    for(int i = 0; i < this.dissolvablePixels.length; i++) {
      this.dissolvablePixels[i] = (int)random(MAX);
    }
  }

  public Scene update() {
    // 
    current.update();
    loadPixels();
    for(int i = 0; i < pixels.length; ++i)
      curImage.pixels[i] = pixels[i];
    updatePixels();

    next.update();
    loadPixels();
    for(int i = 0; i < pixels.length; ++i)
      nextImage.pixels[i] = pixels[i];
    updatePixels();

    camera();
    background(0);
    loadPixels();
    for(int i = 0; i < dissolvablePixels.length; i++) {
      if (dissolvablePixels[i] <= index) {
        pixels[i] = nextImage.pixels[i];
      } else {
        pixels[i] = curImage.pixels[i];
      }
    }
    updatePixels();
                
    if( ++index > MAX ) {
        next.setEnable();
        return next;
    }

    return this;
  }
}
