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
import oscP5.*;
import netP5.*;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONSTANTS
int L1 = 360;                                 // UI length unit for rendering images
String path_photo = savePath("images/test.jpg");     // path for the photo used
int c_gray_treshold_init = 104;               // initial value set in control / c for constant 
int c_polygon_init = 7;                       // initial value set in control
int c_speed = 3000;

int horiz1 = 150;                             // size horiz panel

int cam_x = 0;
int cam_y = horiz1;
int threshold_x = 0;
int threshold_y = horiz1+205;
int contour_x = 0;
int contour_y = horiz1+205+205;
float contour_scale = 2.8;
int previz_x = 30;
int previz_y = 30;
float previz_scale = 10;

// I/O
String path_gcode = "gcode/test.nc.txt";               // path of gcode file to read
int v_resistivity = 1024;

// User Constants
int serialPortNumber = 1;

// reset memeory
PVector machine_pen_previous_session = new PVector(0, 0);



// Flags
boolean ok_import_photo;
boolean ok_ui_debug;


boolean ok_machine_ready;
boolean ok_machine_busy;
boolean ok_reader_busy;
boolean ok_previz_busy;
boolean ok_previz_done;
boolean ok_sequence_busy;
boolean ok_paused;
boolean ok_osc_detected;
boolean ok_restart_busy;
boolean ok_render_previz;

boolean ok_print_serial_port_list;
boolean ok_print_serial_port_name;
boolean ok_print_serial_IN;
boolean ok_print_serial_OUT;
boolean ok_print_pen_coor;
boolean ok_print_pen_state;
boolean ok_print_buffer;
boolean ok_print_osc;
boolean ok_print_debug;


void flag_init() {
  // Flags
  ok_import_photo = false;
  ok_ui_debug = false;


  ok_machine_ready = false;       // gcode script initiated
  ok_machine_busy = false;
  ok_reader_busy = false;
  ok_previz_busy = false;
  ok_previz_done = false;
  ok_sequence_busy = false;
  ok_paused = false;
  ok_osc_detected = false;
  ok_restart_busy = false;
  ok_render_previz = false;

  ok_print_serial_port_list = false;  // print 
  ok_print_serial_port_name = true; 
  ok_print_serial_IN = true;
  ok_print_serial_OUT = false;
  ok_print_pen_coor = true;
  ok_print_pen_state = true;
  ok_print_buffer = false;
  ok_print_osc = false;
  ok_print_debug = true;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
// SETUP
void setup() {
  fullScreen();
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
  flag_init();
  file_init();
  dim_init(1);
  cam_init();
  opencv_init();
  serial_init();
  cp5_init();
  osc_init();
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
  osc_update();
  restart_update();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// RENDER
void render() {
  if (!ok_ui_debug) {
    cp5.hide();
    if (!ok_sequence_busy && !ok_machine_busy) {
      background(0);
      for (int x = 10; x < width; x += 10) {
        for (int y = 10; y < height; y += 10) {
          float n = noise(x * 0.005, y * 0.005, frameCount * 0.03);
          pushMatrix();
          noStroke();
          rectMode(CENTER);
          frameRate(30);
          noiseDetail(2, 0.9);
          translate(x, y);
          rotate(TWO_PI * n);
          scale(10 * n);
          fill(255);
          rect(0, 0, 1, 1);
          popMatrix();
        }
      }
    } else if (!ok_previz_done) {
      if (ok_render_previz == false) {
        
      }
      ok_render_previz= true;
    } else {
      ok_render_previz = false;
    }
  } else { 
    cp5.show();
    rect_draw(0, 0, L1, horiz1, 150);
    cam_render(cam_x, cam_y, L1);
    threshold_render(0, threshold_y, L1);
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
void log_print() {
  //printlog_camera_list();
  //printlog_contour();
  //printlog_dim();
}

void restart() {
  machine_pen_previous_session.x = machine_pen.x;
  machine_pen_previous_session.y = machine_pen.y;
  serial_port.stop();
  setup();
  ok_restart_busy = true;
  print_debug("RESTART BUSY ...");
}

void restart_update() {
  if (ok_restart_busy && ok_machine_ready && !ok_machine_busy && n_queued_commands == 0) {
    ok_restart_busy = false;
    machine_move_fast(-machine_pen_previous_session.x, -machine_pen_previous_session.y);
    set_zero();
    print_debug("RESTART SUCCESS");
  }
}
