// VARIABLES ///////////////////////////////////////////////////////////////////
Capture cam ;
PImage camMirror;

// INITIALISATION //////////////////////////////////////////////////////////////

void initCamera() {
  String[] cameras = Capture.list();
  //printArray(cameras);
  cam = new Capture(this, cameras[3]);
  cam.start();
  camMirror = new PImage(640, 360);
}

// UPDATE /////////////////////////////////////////////////////////////////////

void updateCamera() {
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
}

// RENDER ///////////////////////////////////////////////////////////////////////

void renderCamera(int x, int y, float r) {
  pushMatrix();
  translate(x, y);
  scale(r);
  image(camMirror, 0, 0);
  popMatrix();
}
