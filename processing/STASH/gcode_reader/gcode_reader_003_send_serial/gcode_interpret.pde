void gcode_interpret(String line) {
  String[] list = split(line, ' ');
  println(line);
  switch(list[0]) {
  case "G1": 
    pen.x = float(list[1].substring(1));
    pen.y = float(list[2].substring(1));
    gcode_drawLine(pen_prev, pen);
    pen_prev.set(pen);
    break;
  case "G0":
    pen.x = float(list[1].substring(1));
    pen.y = float(list[2].substring(1));
    gcode_hoverLine(pen_prev, pen);
    pen_prev.set(pen);
  default: 
    break;
  }
}
