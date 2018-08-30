// CONTROL INTERFACE : buttons, events 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
ControlP5 cp5;
PImage snapshot;
int p_gray_treshold;         // dynamic parameter
int p_polygon;               // dynamic parameter
int x1 = 20;                 // UI reference constant : x level 1          
int y1 = 20;                 // UI ref
int w1 = 256;                // UI ref
int h1 = 10;                 // UI ref
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION 
void cp5_init() {
  cp5 = new ControlP5(this);
  cp5.addButton("take_photo")
    .setPosition(x1, y1)
    .setSize(w1, h1);
  cp5.addSlider("p_gray_treshold")
    .setPosition(x1, 2*y1)
    .setSize(w1, h1)
    .setRange(0, 255)
    .setValue(c_gray_treshold_init);
  cp5.addSlider("p_polygon")
    .setPosition(x1, 3*y1)
    .setSize(w1, h1)
    .setRange(0, 30)
    .setValue(c_polygon_init);
  cp5.addButton("previsualization")
    .setPosition(x1, 4*y1)
    .setSize(w1, h1);
  cp5.addButton("launch_machine")
    .setPosition(x1, 5*y1)
    .setSize(w1, h1);
  if (ok_print_debug) print_debug(" CP5 INIT");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE BUTTON : TAKE PHOTO and copying it into img to process
void take_photo() {
  cam_mirror.save(path_photo);               // save camera view
  copy_PImage(cam_mirror, snapshot);   // copy camMirror into snapshot
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
////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT BUTTON : previz
void previsualization() {
  previz_init();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT BUTTON : launch machine
void launch_machine() {
  set_zero();
  machine_launch_task();
}
