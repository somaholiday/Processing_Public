import peasy.*;

PeasyCam cam;

int SIZE = 1000;
PImage img;

int LAYERS = 10;
PImage[] layerTextures = new PImage[LAYERS];

PShape[] shapes = new PShape[LAYERS];

void setup() {
  img = loadImage("05-22-2010_00.jpg");

  size(img.width, img.height, P3D);
  noStroke();

  img.loadPixels();

  for (int i=0; i < LAYERS; i++) {
    layerTextures[i] = createImage(img.width, img.height, ARGB);
    PImage layer = layerTextures[i];
    layer.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);


    float thresh = (255 / float(LAYERS)) * i;

    layer.loadPixels();
    for (int j=0; j < layer.pixels.length; j++) {
      if (brightness(layer.pixels[j]) < thresh || layer.pixels[j] == color(0,0,0)) {
        layer.pixels[j] = color(0, 0, 0, 0);
      }
    }  
    layer.updatePixels();


    shapes[i] = createShape(RECT, 0, 0, img.width, img.height);
    shapes[i].setTextureMode(NORMAL);
    shapes[i].setTexture(layer);
  }

  cam = new PeasyCam(this, width/2, height/2, 0, 2000);

  background(0);
}

void draw() {
  cam.beginHUD();
  background(0);
  cam.endHUD();

  for (int i=0; i < shapes.length; i++) {
    float maxSpread = map(sin(frameCount*.01), -1, 1, -500, LAYERS);
    
    int y = int(sin(frameCount*.005 + i) * map(i, 0, shapes.length, maxSpread, 0));
    int z = i * -40;

    pushMatrix();
    translate(width*.5, height*.5, 0);
    rotateY(PI);
    translate(-width*.5, -height*.5, 0);
    translate(0, y, z);
    
    shape(shapes[i]);
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
