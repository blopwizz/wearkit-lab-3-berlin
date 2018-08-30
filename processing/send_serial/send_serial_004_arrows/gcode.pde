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
    pen.y += 10;
    break;
  case DOWN: 
    send("G01 X10 Y-10");
    pen.y -= 10;
    break;
  case RIGHT:
    send("G01 X-10 Y-10");
    pen.x += 10;
    break;
  case LEFT:
    send("G01 X10 Y10");
    pen.x -= 10;
    break;
  default: 
    break;
  }
  send("G90");
  println("X " + pen.x + "Y " + pen.y);
}

void move(float x, float y) {
  port.clear();
  send("G01 X"+x+" Y"+y);
  pen.x += x;
  pen.y += y;
}

void pen_down() {
  send("M05");
}

void pen_up() {
  send("M03");
}

void set_zero() {
  pen.x = 0;
  pen.y = 0;
  send(s_zero_position);
}

void go_home() {
  send("G0 x0 y0");
}

void set_speed(int s) {
  send("F"+s);
}
