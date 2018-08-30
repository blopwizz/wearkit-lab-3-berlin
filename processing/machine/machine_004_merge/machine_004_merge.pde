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
import processing.serial.*;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONSTANTS
int L1 = 360;                                 // UI length unit for rendering images
String path_photo = savePath("images/test.jpg");     // path for the photo used
int c_gray_treshold_init = 104;               // initial value set in control / c for constant 
int c_polygon_init = 7;                       // initial value set in control
int c_speed = 3000;

int horiz1 = 150;                             // size horiz panel
int previz_x = 400;
int previz_y = 0;
float c_scale = 4.2; 
// I/O
String path_gcode = "gcode/test.nc.txt";               // path of gcode file to read
// User Constants
int serialPortNumber = 1;
// scale of visualization

// Flags
boolean ok_machine_ready = false;       // gcode script initiated
boolean ok_machine_busy = false;
boolean ok_reader_busy = false;
boolean ok_previz_busy = false;

boolean ok_print_serial_port_list = false;  // print 
boolean ok_print_serial_port_name = true; 
boolean ok_print_serial_IN = true;
boolean ok_print_serial_OUT = false;
boolean ok_print_pen_coor = true;
boolean ok_print_pen_state = true;
boolean ok_print_buffer = false;
boolean ok_print_debug = true;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// SETUP
void setup() {
  size(1600, 800);
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
  serial_init();
  cp5_init();
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
  previz_update();
  machine_update();
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
