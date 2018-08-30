// GCODE READER
//////////////////////////////////////////////////////////////////////////////////////////
// LIBRAIRIES
import processing.serial.*;
//////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// I/O
String path = "test001.nc.txt";               // path of gcode file to read

// User Constants
float c_scale = 2;                            // scale of visualization

// Flags
boolean ok_reader_new_line = true;          // new line available in the reader
boolean ok_viz_drawing = false;             // drawing completed in visualization
boolean ok_serial_port_init = false;        // serial port initiated
boolean ok_serial_gcode_init = false;       // gcode script initiated
boolean ok_serial_state_idle = false;       // serial in idle state

//////////////////////////////////////////////////////////////////////////////////////////
// SETUP AND INITIALIZATION
void setup() {
  size(1400, 700);
  background(200);
  init();
}
void init() {
  initReader();
  initSerial();
}
//////////////////////////////////////////////////////////////////////////////////////////
// DRAWING LOOP
void draw() {
  update();
  delay(2);                                                           // stability good practice when working with motors
}

void update() {
  updateReader();
  if (ok_reader_new_line) {
    viz_gcode_read(line);
  } else if (!ok_viz_drawing) {
    printLogContours();
    ok_viz_drawing = true;
  }
  ok_serial_state_idle = (serial_queued_commands == 0 && ok_serial_gcode_init && ok_serial_port_init);       // flag update
  if (ok_serial_state_idle) {
  }
}
