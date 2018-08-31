// SERIAL
///////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;

Serial port;
String msg;

// Flags
boolean f_initPort = false;     // initialization of first contact completed
boolean f_initGCode = false;   // initialization of  gcode completed
int queued_commands = 0;
boolean f_Idle = false;

PVector pen = new PVector(0,0);

void setup() {
  size(200, 200);
  initPort();
}

void draw() {
  if (queued_commands == 0 && f_initGCode && f_initPort) {
    f_Idle = true;
  } else {
    f_Idle = false;
  }
  if (f_Idle) {
  }
  delay(2); // for stability when working with motors
}

void mouseClicked() {
}
