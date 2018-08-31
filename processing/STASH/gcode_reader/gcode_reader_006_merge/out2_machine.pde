// GCODE SEND
////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// GCODE Table
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

// Objects
Serial serial_port;
String serial_received_msg;

// Counters and indicators
int serial_queued_commands = 0;
PVector serial_pen = new PVector(0, 0);

PVector pen_send = new PVector(0, 0);
PVector pen_prev_send = new PVector(0, 0);
/////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
void initSerialPort() {
  String portName = Serial.list()[serialPortNumber];
  if (ok_print_serial_port_list) {
    printArray(Serial.list());
  }
  if (ok_print_serial_port_name) {
    println(portName);
  }
  serial_port = new Serial(this, portName, 115200);
  serial_port.clear();
}
void initMachine() {                            // triggered when port is ready
  send(s_zero_position);
  send(s_feedrate);
  send(s_incremental_programming);
  ok_serial_gcode_init = true;
}
////////////////////////////////////////////////////////////////////////////////////////
// GCODE READ: string -> gcode send
void serial_send_gcode_read(String line) {
  if (line == null) {
    ok_reader_reading = false;
  } else {
    String[] instruction = split(line, ' ');
    switch(instruction[0]) {
    case "G1": 
      pen_send.x = float(instruction[1].substring(1));
      pen_send.y = float(instruction[2].substring(1));
      send_gcode_continueDraw(pen_prev_send, pen_send);
      pen_prev_send.set(pen_send);
      break;
    case "G0":
      pen_send.x = float(instruction[1].substring(1));
      pen_send.y = float(instruction[2].substring(1));
      send_gcode_moveAndDraw(pen_prev_send, pen_send);
      pen_prev_send.set(pen_send);
      break;
    case "M03":
      serial_pen_up();
      break;
    case "M05":
      serial_pen_down();
      break;
    case "G92 x0 y0 z0":
      serial_set_zero();
      break;
    case "G0 x0 y0":
      serial_go_home();
      break;
    default: 
      break;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : GLINE
void send_gcode_moveAndDraw(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  scale(c_scale);
  stroke(0, 255, 0);
  strokeWeight(3);
  line(p1.x, p2.y, p2.x, p2.y);
  popMatrix();
  popStyle();

  serial_move_fast(p1.x, p1.y);
  counterLines++;
}

void send_gcode_continueDraw(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  scale(c_scale);
  stroke(0, 255, 0, 140);
  strokeWeight(3);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
  popStyle();

  serial_move_abs(p2.x, p2.y);

  counterLines++;
}

///////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE | converts coordinates to fit with the drawing machine characteristics
void serial_move_abs(float x, float y) {
  serial_port.clear();
  PVector temp = gcode_coor(x, y);
  serial_port.clear();
  send("G1 X"+temp.x+" Y"+temp.y);
  serial_pen.x = x;
  serial_pen.y = y;
  if (ok_print_serial_pen_coor) print_serial_pen_coor();
}

///////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE | converts coordinates to fit with the drawing machine characteristics
void serial_move_fast(float x, float y) {
  serial_port.clear();
  PVector temp = gcode_coor(x, y);
  serial_port.clear();
  send("G0 X"+temp.x+" Y"+temp.y);
  serial_pen.x = x;
  serial_pen.y = y;
  if (ok_print_serial_pen_coor) print_serial_pen_coor();
}


/////////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE DIRECTION | with keyboard
void serial_move(int dir) {
  serial_port.clear();
  send("G91");
  switch(dir) {
  case UP: 
    send("G01 X-14.142136 Y14.142136");
    serial_pen.y += 10;
    break;
  case DOWN: 
    send("G01 X14.142136 Y-14.142136");
    serial_pen.y -= 10;
    break;
  case RIGHT:
    send("G01 X-14.142136 Y-14.142136");
    serial_pen.x += 10;
    break;
  case LEFT:
    send("G01 X14.142136 Y14.142136");
    serial_pen.x -= 10;
    break;
  default: 
    break;
  }
  send("G90");
  if (ok_print_serial_pen_coor) {
    if (ok_print_serial_pen_coor) print_serial_pen_coor();
  }
}

////////////////////////////////////////////////////////////////////////////////
// ROTATION
// (Aug 30 2018) To Do : change gcode_coor to take whatever rotation angle to change
PVector gcode_coor(float x, float y) {     // changement de base
  PVector res = new PVector();
  res.x = -sqrt(2)*(x+y);
  res.y = sqrt(2)*(y-x);
  return res;
}



////////////////////////////////////////////////////////////////////////////////////
// GCODE ACTIONS
void serial_pen_down() {
  send("M05");
  if (ok_print_serial_pen_state) {
    println(millis()+"     PEN DOWN");
  }
}
void serial_pen_up() {
  send("M03");
  if (ok_print_serial_pen_state) {
    println(millis()+"     PEN UP");
  }
}
void serial_set_zero() {
  send(s_zero_position);
  if (ok_print_serial_pen_state) {
    println(millis()+"     NEW ZERO SET");
  }
}
void serial_go_home() {
  send("G0 x0 y0");
  serial_pen.x = 0;
  serial_pen.y = 0;
  if (ok_print_serial_pen_state) {
    println(millis()+"     GOING HOME");
    print_serial_pen_coor();
  }
}
void serial_set_speed(int s) {
  send("F"+s);
  if (ok_print_serial_pen_state) {
    println(millis()+"     SPEED SET TO F"+s);
  }
}

void print_serial_pen_coor() {
  println(millis()+"     PEN X" + serial_pen.x + " Y" + serial_pen.y);
}


///////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : SEND SERIAL
void send(String str) {
  serial_queued_commands += 1;
  serial_port.clear();
  serial_port.write(str);
  serial_port.write('\n');
  if (ok_print_serial_OUT) {
    println(millis()+ " (" + serial_queued_commands + ") OUT > " + str);
  }
  serial_port.clear();
}

// UPDATE
void decrement_serial_queued_commands() {
  serial_queued_commands -= 1;
}
