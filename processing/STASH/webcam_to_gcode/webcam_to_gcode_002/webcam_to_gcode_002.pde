import processing.video.*;

Capture cam ;
PImage camMirror;

void setup() {
  size(1400, 700, P2D);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[3]);
  cam.start();
  //printArray(cameras);
  camMirror = new PImage(640,360);
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  cam.loadPixels();
  // mirroring image
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      camMirror.pixels[x+y*cam.width] = cam.pixels[(cam.width-(x+1))+y*cam.width];
    }
  }
  camMirror.updatePixels();
  image(camMirror, 0, 0);
}


void mouseClicked() {
  camMirror.save("test.jpg");
  cam.stop();
}
