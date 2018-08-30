// GCODE READER //<>//
//////////////////////////////////////////////////////////////////////////////////////////
// LIBRAIRIES
import processing.serial.*;
//////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// I/O
String path = "test.nc.txt";               // path of gcode file to read

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
  size(1000, 700);
  background(200);
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
  if (ok_reader_new_line) {
    updateReader(); 
    viz_gcode_read(line);
  } else if (!ok_viz_drawing) {                                // else, if the viz is not declared as finished
    printLogContours();                                      // print the contours
    ok_viz_drawing = true;                                   // and state that the viz is finished
  }
  ok_serial_state_idle = (ok_serial_port_init && ok_serial_gcode_init&& ok_viz_drawing && serial_queued_commands == 0);       
  if (ok_serial_state_idle) {
    println(millis() + "hello");
  }
}
