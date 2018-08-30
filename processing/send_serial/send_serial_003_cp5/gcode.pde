// GCODE
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

void move(int dir) {
  port.clear();
  send("G91");
  switch(dir) {
  case UP: 
    send("G0 X-10 Y10");
    break;
  case DOWN: 
    send("G0 X10 Y-10");
    break;
  case RIGHT:
    send("G0 X-10 Y-10");
    break;
  case LEFT:
    send("G0 X10 Y10");
    break;
  default: 
    break;
  }
  send("G90");
}


void pen_down() {
  send("M05");
}

void pen_up() {
  send("M03");
}
