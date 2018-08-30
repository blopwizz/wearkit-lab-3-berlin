// SERIAL
///////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;
Serial port;
String msg;

// Flags
boolean fFirstContact = false;
boolean fInitiated = false;

// GCODE
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";
String s_down_10 = "G01 X10 Y-10";
String s_up_10 = "G01 X-10 Y10";

String D = "d";
String U = "u";

void s_move(String dir, int step) {
  String s_result = new String();
  if (dir=="d") {s_result = "G01 X" + step + " Y-" + step;}
  if (dir=="u") {s_result = "G01 X-" + step + " Y" + step;}
  send(s_result);
}

void setup() {
  size(200, 200);
  String portName = Serial.list()[1];
  println(portName);
  port = new Serial(this, portName, 115200);
  port.clear();
}

void init() {
  send(s_zero_position);
  send(s_feedrate);
  send(s_incremental_programming);
  fInitiated = true;
}

void draw() {
  if (fFirstContact && !fInitiated) {
    init();
  }
}

void mousePressed() {
  s_move(D, 10);
}
void mouseReleased() {
  s_move(U, 10);
}

void serialEvent(Serial myPort) {
  msg = myPort.readStringUntil('\n');
  if (msg != null) {
    msg = trim(msg);
    println(millis()+ " IN  > "+ msg);

    if (fFirstContact == false) {
      if (msg.equals("M3S90ok")) {
        myPort.clear();
        fFirstContact= true;
        println(millis() + " LOG > First contact established");
      }
    }
  }
}

void send(String str) {
  port.write(str);
  port.write('\n');
  println(millis()+ " OUT > " + str);
}
