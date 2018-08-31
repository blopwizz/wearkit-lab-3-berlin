// GCODE
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

void move(int dir) {
  port.clear();
  send("G91");
  switch(dir) {
  case UP: 
    send("G01 X-10 Y10");
    pen_serial.y += 10;
    break;
  case DOWN: 
    send("G01 X10 Y-10");
    pen_serial.y -= 10;
    break;
  case RIGHT:
    send("G01 X-10 Y-10");
    pen_serial.x += 10;
    break;
  case LEFT:
    send("G01 X10 Y10");
    pen_serial.x -= 10;
    break;
  default: 
    break;
  }
  send("G90");
  println("X " + pen_serial.x + "Y " + pen_serial.y);
}

void move(float x, float y) {
  PVector temp = gcode_coor(x, y);
  port.clear();
  send("G01 X"+temp.x+" Y"+temp.y);
  pen_serial.x = x;
  pen_serial.y = y;
}

void pen_down() {
  send("M05");
}

void pen_up() {
  send("M03");
}

void set_zero() {
  pen_serial.x = 0;
  pen_serial.y = 0;
  send(s_zero_position);
}

void go_home() {
  send("G0 x0 y0");
}

void set_speed(int s) {
  send("F"+s);
}

PVector gcode_coor(float x, float y) {     // changement de base
  PVector res = new PVector();
  res.x = -sqrt(2)*(x+y);
  res.y = sqrt(2)*(y-x);
  return res;
}
