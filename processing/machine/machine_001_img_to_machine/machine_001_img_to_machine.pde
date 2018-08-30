// DRAWINMACHINE //<>// //<>//
// reader -> previz
// machine, user, reader -> machine
//////////////////////////////////////////////////////////////////////////////////////////
// LIBRAIRIES
import processing.serial.*;
//////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// I/O
String path = "gcode/test_006.nc.txt";               // path of gcode file to read

// User Constants
int serialPortNumber = 1;
float c_scale = 2;                          // scale of visualization

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
boolean ok_print_debug = true;

//////////////////////////////////////////////////////////////////////////////////////////
// SETUP AND INITIALIZATION
void setup() {
  size(1000, 700);
  background(200);
  serial_init();
  previz_init();
}
//////////////////////////////////////////////////////////////////////////////////////////
// DRAWING LOOP
void draw() {
  previz_update();
  machine_update();
  delay(2);            // stability good practice when working with motors
}

void print_debug(String s) {
  println(millis() + " (debug) " + s);
}
