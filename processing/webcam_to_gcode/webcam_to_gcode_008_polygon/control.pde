// CONTROL INTERFACE : buttons, events 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
ControlP5 cp5;
PImage snapshot;
int p_gray_treshold;         // dynamic parameter
int p_polygon;               // dynamic parameter //<>//
int x1 = 20;                 // UI reference constant : x level 1          
int y1 = 20;                 // UI ref
int w1 = 256;                // UI ref
int h1 = 10;                 // UI ref
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION 
void initControl() {
  cp5 = new ControlP5(this);
  cp5.addButton("take_photo")
    .setPosition(x1, y1)
    .setSize(w1, h1); //<>//
  cp5.addSlider("p_gray_treshold")
    .setPosition(x1, 2*y1)
    .setSize(w1, h1)
    .setRange(0, 255)
    .setValue(c_gray_treshold_init); //<>//
  cp5.addSlider("p_polygon") //<>//
    .setPosition(x1, 3*y1)
    .setSize(w1, h1)
    .setRange(0, 30)
    .setValue(c_polygon_init);
} //<>//

////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE BUTTON : TAKE PHOTO and copying it into img to process
void take_photo() {
  camMirror.save(path_photo);               // save camera view
  copyPImagePixels(camMirror, snapshot);   // copy camMirror into snapshot
  img = snapshot;                          // img to process : snapshot
  update();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE PARAMETER : GRAY TRESHOLD
void p_gray_treshold(int v) {
  p_gray_treshold = v;
  update();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE PARAMETER : APPROXIMATION FACTOR
void p_polygon(int v) {
  p_polygon = v;
  update();
}
