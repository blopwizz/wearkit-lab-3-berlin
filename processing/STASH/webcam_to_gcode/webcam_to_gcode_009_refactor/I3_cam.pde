// CAMERA : processing camera input
////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES 
Capture cam ;
PImage cam_mirror;
int id_cam = 3;
int w_cam = 640;
int h_cam = 360;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION 
void cam_init() {
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[id_cam]);
  cam.start();
  cam_mirror = new PImage(w_cam, h_cam);
  snapshot = new PImage(w_cam, h_cam);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE 
void cam_update() {
  if (cam.available()) cam.read();
  cam.loadPixels();
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      cam_mirror.pixels[x+y*cam.width] = cam.pixels[(cam.width-(x+1))+y*cam.width];
    }
  }
  cam_mirror.updatePixels();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// RENDER 
void cam_render(int x, int y, float L) {
  pushMatrix();
  translate(x, y);
  float r = L/((float)cam_mirror.width);
  scale(r);
  image(cam_mirror, 0, 0);
  popMatrix();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
// PRINT LOG
void printlog_camera_list() {
  String[] cameras = Capture.list();
  printArray(cameras);
}
