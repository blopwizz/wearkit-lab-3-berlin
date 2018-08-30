// GCODE
////////////////////////////////////////////////////////////////////////////////
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

// ROTATION
PVector gcode_coor(float x, float y) {     // changement de base
  PVector res = new PVector();
  res.x = -sqrt(2)*(x+y);
  res.y = sqrt(2)*(y-x);
  return res;
}

// SERIAL MOVE | 
// converts coordinates to fit with the drawing machine characteristics
// (Aug 30 2018) To Do : change gcode_coor to take whatever rotation angle to change
void serial_move(float x, float y) {
  PVector temp = gcode_coor(x, y);
  serial_port.clear();
  send("G01 X"+temp.x+" Y"+temp.y);
  serial_pen.x = x;
  serial_pen.y = y;
}


void serial_move(int dir) {
  serial_port.clear();
  send("G91");
  switch(dir) {
  case UP: 
    send("G01 X-10 Y10");
    serial_pen.y += 10;
    break;
  case DOWN: 
    send("G01 X10 Y-10");
    serial_pen.y -= 10;
    break;
  case RIGHT:
    send("G01 X-10 Y-10");
    serial_pen.x += 10;
    break;
  case LEFT:
    send("G01 X10 Y10");
    serial_pen.x -= 10;
    break;
  default: 
    break;
  }
  send("G90");
  println("X " + serial_pen.x + "Y " + serial_pen.y);
}


void serial_pen_down() {
  send("M05");
}

void serial_pen_up() {
  send("M03");
}

void serial_set_zero() {
  serial_pen.x = 0;
  serial_pen.y = 0;
  send(s_zero_position);
}

void serial_go_home() {
  send("G0 x0 y0");
}

void serial_set_speed(int s) {
  send("F"+s);
}
