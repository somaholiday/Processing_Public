class Pixel {
  int x, y;
  float bri;
  color col;

  public Pixel(int x, int y, color col) {
    this.x = x;
    this.y = y;
    this.col = col;
    this.bri = brightness(col);
  }
}
