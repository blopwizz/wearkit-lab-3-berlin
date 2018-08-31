// WEBCAM TO GCODE 
//  
// 1. File, Dimensions, Camera
// 2. OpenCV --> GCode Contours
// 3. Control, Render
///////////////////////////////////////////////////////////////////////////////////////////////////////
// LIBRAIRIES
import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;
import controlP5.*;
import processing.video.*;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONSTANTS
int L1 = 360;                                 // UI length unit for rendering images
String path_photo = savePath("test.jpg");     // path for the photo used
int c_gray_treshold_init = 104;               // initial value set in control / c for constant 
int c_polygon_init = 7;                       // initial value set in control
int c_speed = 3000;
int horiz1 = 150;                             // size horiz panel

boolean ok_print_buffer = false;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// SETUP
void setup() {
  size(1600, 800);
  background(200);
  init();                    // initialization routine
  update();                  // update routine
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW LOOP
void draw() {
  update();
  render();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// INIT
void init() {
  file_init();
  dim_init(1);
  cam_init();
  opencv_init();
  control_init();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE
void update() {
  cam_update();
  buffer_reset();
  opencv_update();
  contour_update();
  gcode_save();
  log_print();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// RENDER
void render() {
  rect_draw(0, 0, L1, horiz1, 150);
  cam_render(0, horiz1, L1);
  threshold_render(0, height-cam_mirror.height-50, L1);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
void log_print() {
  //printlog_camera_list();
  //printlog_contour();
  //printlog_dim();
}
