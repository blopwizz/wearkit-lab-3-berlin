// CAMERA : processing camera input
////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES 
Capture cam ;
PImage camMirror;
int id_cam = 3;
int w_cam = 640;
int h_cam = 360;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION 
void initCamera() {
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[id_cam]);
  cam.start();
  camMirror = new PImage(w_cam, h_cam);
  snapshot = new PImage(w_cam, h_cam);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE 
void updateCamera() {
  if (cam.available()) cam.read();
  cam.loadPixels();
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      camMirror.pixels[x+y*cam.width] = cam.pixels[(cam.width-(x+1))+y*cam.width];
    }
  }
  camMirror.updatePixels();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// RENDER 
void renderCamera(int x, int y, float L) {
  pushMatrix();
  translate(x, y);
  float r = L/((float)camMirror.width);
  scale(r);
  image(camMirror, 0, 0);
  popMatrix();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
// PRINT LOG
void printLogCameraList() {
  String[] cameras = Capture.list();
  printArray(cameras);
}
