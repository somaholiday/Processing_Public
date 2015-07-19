import peasy.*;

PeasyCam cam;

int SIZE = 1000;
PImage img;

int LAYERS = 60;
PImage[] layerTextures = new PImage[LAYERS];

PShape[] shapes = new PShape[LAYERS];

float INNER_RADIUS = 100;

float BLACK_THRESH = 10;

void setup() {
  rectMode(CENTER);
  shapeMode(CENTER);
  //  img = loadImage("05-22-2010_00.jpg");
  //  img = loadImage("05-02-08OOOO.jpg");
//  img = loadImage("10-22-2010no4.jpg");
//  img = loadImage("10-24-2010_no14_20x20crop.jpg");
//  img = loadImage("936d4cb01acadba6155196ea8165f80f.jpg");
  img = loadImage("bigcomplex1000.jpg");  

  size(img.width, img.height, OPENGL);
  noStroke();

  img.loadPixels();

  for (int i=0; i < img.pixels.length; i++) {
    if (brightness(img.pixels[i]) < BLACK_THRESH) {
      img.pixels[i] = color(0, 0, 0, 0);
    }
  }  

  for (int i=0; i < LAYERS; i++) {
    layerTextures[i] = createImage(img.width, img.height, ARGB);
    PImage layer = layerTextures[i];
    layer.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);

    float layerNorm = norm(i, 0, LAYERS);

    float thresh = .5*255;//(layerNorm) * 255;

    layer.loadPixels();
    for (int j=0; j < layer.pixels.length; j++) {
      if (brightness(layer.pixels[j]) < thresh || brightness(layer.pixels[j]) < BLACK_THRESH) {
        layer.pixels[j] = color(0, 0, 0, 0);
      }
    }  
    layer.updatePixels();


    shapes[i] = createShape(RECT, 0, 0, img.width, img.height);
    shapes[i].setTextureMode(NORMAL);
    shapes[i].setTexture(layer);
  }

  cam = new PeasyCam(this, width*.5, 0, 0, 1.5*img.height);

  background(0);
}

void draw() {
  lights();
  pointLight(255, 0, 255, 0, 0, 0);

  cam.beginHUD();
  background(0);
  cam.endHUD();

  float angle_interval = TWO_PI / LAYERS;

  for (int i=0; i < LAYERS; i++) {
    pushMatrix();
    translate(width*.5, height*.5, 0);
    rotateY(PI);
    float radius = INNER_RADIUS + (img.height * .5);
    float theta = (angle_interval * i) + HALF_PI*3;

    rotateX(theta + frameCount*.01);
    translate(0, radius, 0);
    rotateX(PI);

    stroke(200);
    fill(255, 0, 0, 50);

    rotateZ((frameCount*.005) + i*0.1);
    shape(shapes[i]);
    //    rect(0, 0, img.width, img.height);
    popMatrix();
  }

  drawFPS();
}

void drawFPS() {
  if (frameCount % 60 == 0) {
    frame.setTitle("FPS : " + nf(frameRate, 2, 2) + " | Runtime: " + frameCount);
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    String timestamp = getTimestamp();
    save(this.getClass().getName() + "-" + timestamp + "-" + frameCount + ".png");
    println("Saved: " + timestamp);
  }
}

String getTimestamp() {
  return year() + nf(month(), 2) + nf(day(), 2) + "-" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}
