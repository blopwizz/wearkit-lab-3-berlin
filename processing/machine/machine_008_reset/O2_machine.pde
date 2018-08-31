////////////////////////////////////////////////////////////////////////////////////////
// GCODE SEND to the machine
////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES

// Objects for serial communication
Serial serial_port;
String serial_received_msg;

// gcode strings
String s_zero_position = "G92 x0 y0 z0";
String s_feedrate = "F3000";
String s_incremental_programming = "G91";

// Counters and indicators
int n_queued_commands = 0;
PVector machine_pen = new PVector(0, 0);
PVector machine_pen_prev = new PVector(0, 0);

/////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION

void machine_init() {                            // triggered when port is ready
  serial_send(s_zero_position);
  serial_send(s_feedrate);
  serial_send(s_incremental_programming);
  ok_machine_ready = true;
  if (ok_print_debug) print_debug("Machine ready!");
}

void machine_launch_task() {
  ok_machine_busy = true;
  set_zero();
  machine_move_manual(UP);
  go_home();
  reader_init();
  if (ok_print_debug) print_debug("Machine busy ... ");
}

////////////////////////////////////////////////////////////////////////////////////////
// UPDATE
void machine_update() {
  if (ok_machine_busy && ok_reader_busy && !ok_previz_busy && n_queued_commands == 0) { 
    reader_update();
    if (ok_reader_busy) {
      machine_send_instruction(line);
    } else {
      ok_machine_busy = false;
      go_home();
      if (ok_print_debug) print_debug("Machine idle.");
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////
// GCODE READ: string -> gcode send
void machine_send_instruction(String line) {
  String[] instruction = split(line, ' ');
  switch(instruction[0]) {
  case "G1": 
    machine_pen.x = float(instruction[1].substring(1));
    machine_pen.y = float(instruction[2].substring(1));
    machine_move_abs(machine_pen.x, machine_pen.y);
    machine_pen_prev.set(machine_pen);
    break;
  case "G0":
    machine_pen.x = float(instruction[1].substring(1));
    machine_pen.y = float(instruction[2].substring(1));
    machine_move_fast(machine_pen.x, machine_pen.y);
    machine_pen_prev.set(machine_pen);
    break;
  case "M03":
    pen_up();
    break;
  case "M05":
    pen_down();
    break;
  case "G92 x0 y0 z0":
    set_zero();
    break;
  case "G0 x0 y0":
    go_home();
    break;
  default: 
    break;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : line

///////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE | converts coordinates to fit with the drawing machine characteristics
void machine_move_abs(float x, float y) {
  serial_port.clear();
  PVector temp = machine_translate_coor(x, y);
  serial_port.clear();
  serial_send("G1 X"+temp.x+" Y"+temp.y);
  if (ok_print_pen_coor) print_pen_coor();
}

///////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE | converts coordinates to fit with the drawing machine characteristics
void machine_move_fast(float x, float y) {
  serial_port.clear();
  PVector temp = machine_translate_coor(x, y);
  serial_port.clear();
  serial_send("G0 X"+temp.x+" Y"+temp.y);
  machine_pen.x = x;
  machine_pen.y = y;
  if (ok_print_pen_coor) print_pen_coor();
}


/////////////////////////////////////////////////////////////////////////////////////
// SERIAL MOVE DIRECTION | with keyboard
void machine_move_manual(int dir) {
  serial_port.clear();
  serial_send("G91");
  switch(dir) {
  case UP: 
    serial_send("G01 X-14.142136 Y14.142136");
    machine_pen.y += 10;
    break;
  case DOWN: 
    serial_send("G01 X14.142136 Y-14.142136");
    machine_pen.y -= 10;
    break;
  case RIGHT:
    serial_send("G01 X-14.142136 Y-14.142136");
    machine_pen.x += 10;
    break;
  case LEFT:
    serial_send("G01 X14.142136 Y14.142136");
    machine_pen.x -= 10;
    break;
  default: 
    break;
  }
  serial_send("G90");
  if (ok_print_pen_coor) {
    if (ok_print_pen_coor) print_pen_coor();
  }
}

////////////////////////////////////////////////////////////////////////////////
// ROTATION
// (Aug 30 2018) To Do : change gcode_coor to take whatever rotation angle to change
PVector machine_translate_coor(float x, float y) {     // changement de base
  PVector res = new PVector();
  res.x = -sqrt(2)*(x+y);
  res.y = sqrt(2)*(y-x);
  return res;
}



////////////////////////////////////////////////////////////////////////////////////
// GCODE ACTIONS
void pen_down() {
  serial_send("M05");
  if (ok_print_pen_state) {
    println(millis()+"     PEN DOWN");
  }
}
void pen_up() {
  serial_send("M03");
  if (ok_print_pen_state) {
    println(millis()+"     PEN UP");
  }
}
void set_zero() {
  serial_send(s_zero_position);
  machine_pen.x = 0;
  machine_pen.y = 0;
  if (ok_print_pen_state) {
    println(millis()+"     NEW ZERO SET");
  }
}
void go_home() {
  serial_send("G0 x0 y0");
  machine_pen.x = 0;
  machine_pen.y = 0;
  if (ok_print_pen_state) {
    println(millis()+"     GOING HOME");
    print_pen_coor();
  }
}
void set_speed(int s) {
  serial_send("F"+s);
  if (ok_print_pen_state) {
    println(millis()+"     SPEED SET TO F"+s);
  }
}

void print_pen_coor() {
  println(millis()+" PEN X" + machine_pen.x + " Y" + machine_pen.y);
}

// UPDATE
void increment_queued_commands(int v) {
  n_queued_commands += v;
}
