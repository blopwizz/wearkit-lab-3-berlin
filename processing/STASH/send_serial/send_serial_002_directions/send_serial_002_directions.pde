// SERIAL
///////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;
Serial port;
String msg;

// Flags
boolean f_initPort = false;     // initialization of first contact completed
boolean f_initGCode = false;   // initialization of  gcode completed
int queued_commands = 0;

// GCODE
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

void setup() {
  size(200, 200);
  initPort();
}

void draw() {
  if (f_initPort && !f_initGCode) {
    initGCode();
  }
  delay(2);
}

void serialEvent(Serial myPort) {
  msg = myPort.readStringUntil('\n');  // reading a message
  if (msg != null) {
    msg = trim(msg);

    if (msg.equals("M3S90ok")) {
      f_initPort = true;
      f_initGCode = false;
    }

    if (msg.equals("ok")) {
      queued_commands -= 1;
      if (queued_commands==0 && !f_initGCode) {
        println(millis() + " LOG > Initialization complete.");
        f_initGCode = true;
      }
    }
    port.clear();
    println(millis()+ " (" + queued_commands + ") IN  > "+ msg);
  }
}

void send(String str) {
  queued_commands += 1;
  port.clear();
  port.write(str);
  port.write('\n');
  println(millis()+ " (" + queued_commands + ") OUT > " + str);
  port.clear();
}

void move(int dir) {
  port.clear();
  send("G91");
  switch(dir) {
  case UP: 
    send("G01 X-10 Y10");
  case DOWN: 
    send("G01 X10 Y-10");
  case RIGHT:
    send("G01 X10 Y10");
  case LEFT:
    send("G01 X-10 Y-10");
  default: 
    break;
  }
  send("G90");
}
