// GCODE READER //<>// //<>//
//////////////////////////////////////////////////////////////////////////////////////////
// LIBRAIRIES
import processing.serial.*;
//////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// I/O
String path = "test_001.nc.txt";               // path of gcode file to read

// User Constants
int serialPortNumber = 1;
float c_scale = 2;                            // scale of visualization

// Flags
boolean ok_serial_port_init = false;        // serial port initiated
boolean ok_serial_gcode_init = false;       // gcode script initiated
boolean ok_serial_state_idle = false;       // serial in idle state
boolean ok_reader_reading = false;          // state : reading, still available
boolean ok_viz_drawing = false;             // state : drawing
boolean ok_machine_drawing = false;         // state : drawing
boolean ok_print_serial_port_list = false;   
boolean ok_print_serial_port_name = true;
boolean ok_print_serial_IN = false;
boolean ok_print_serial_OUT = false;
boolean ok_print_serial_pen_coor = true;
boolean ok_print_serial_pen_state = true;
//////////////////////////////////////////////////////////////////////////////////////////
// SETUP AND INITIALIZATION
void setup() {
  size(1000, 700);
  background(200);
  initSerialPort();
  ok_viz_drawing = true;
  initReader();
}
//////////////////////////////////////////////////////////////////////////////////////////
// DRAWING LOOP
void draw() {
  update();
  delay(2);                                                           // stability good practice when working with motors
}

void update() {
  ok_serial_state_idle = (ok_serial_port_init && ok_serial_gcode_init && serial_queued_commands == 0);       
  if (ok_viz_drawing && ok_reader_reading && ok_serial_state_idle) {
    updateReader(); 
    previz_gcode_read(line);
    if (!ok_reader_reading) {
      ok_viz_drawing = false;
      closeReader();
    }
  } else if (ok_machine_drawing && ok_reader_reading && ok_serial_state_idle) {
    updateReader();
    serial_send_gcode_read(line);
    if (!ok_reader_reading) {
      ok_machine_drawing = false;
      closeReader();
    }
  } 
}
