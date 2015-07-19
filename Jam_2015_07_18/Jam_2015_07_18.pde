int SIZE = 1000;
PImage img;

Pixel[] pixes;

void setup() {

  img = loadImage("05-22-2010_00.jpg");
  pixes = new Pixel[img.width*img.height];

  size(img.width, img.height);
  noStroke();

  img.loadPixels();

  for (int i=0; i < img.pixels.length; i++) {
    color col = img.pixels[i];
    int x = i % width;
    int y = i / width;

    pixes[i] = new Pixel(x, y, col);
  }
}

void draw() {
  background(0);

  loadPixels();

  for (Pixel pix : pixes) {
    int y = (int)(pix.y + sin(frameCount*.01)*pix.bri);

    int index = y*width + pix.x;

    if (index > 0 && index < width * height) {
      pixels[index] = pix.col;
    }
  }

  updatePixels();

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
