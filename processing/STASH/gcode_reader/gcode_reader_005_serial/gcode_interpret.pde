// GCODE INTERPRET
///////////////////////////////////////////////////////////////////////////////////////////
// STRING -> RENDER GCODE 
void gcode_interpret(String line) {
  String[] instruction = split(line, ' ');
  println(line);
  switch(instruction[0]) {
  case "G1": 
    pen.x = float(instruction[1].substring(1));
    pen.y = float(instruction[2].substring(1));
    gcode_drawLine(pen_prev, pen);
    pen_prev.set(pen);
    break;
  case "G0":
    pen.x = float(instruction[1].substring(1));
    pen.y = float(instruction[2].substring(1));
    gcode_hoverLine(pen_prev, pen);
    pen_prev.set(pen);
  default: 
    break;
  }
}
