/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VISUALIZATION GCODE : vectors -> draw
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
PVector previz_pen = new PVector(0, 0);
PVector previz_pen_prev = new PVector(0, 0);
float min_line_x=10000;
float min_line_y=10000;
float max_line_x=0;
float max_line_y=0;
int counterLines=0;
///////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION : rendering previzualisation
void previz_init() {
  rect_draw(previz_x, previz_y, 1000, 800, 255);
  ok_previz_busy = true;
  reader_init();
  if (ok_print_debug) print_debug("Previz loading ...");
}
///////////////////////////////////////////////////////////////////////////////////////////
// UPDATE
void previz_update() {
  if (ok_reader_busy && ok_previz_busy) {
    reader_update(); 
    if (ok_reader_busy) {
      previz_gcode_read(line);
    } else {
      ok_previz_busy = false;
      if (ok_print_debug) print_debug("Previz rendered.");
      if (ok_print_debug) printLogContours();
    }
  }
}
///////////////////////////////////////////////////////////////////////////////////////////
// GCODE READ: string -> gcode previzualisation
void previz_gcode_read(String line) {
  String[] instruction = split(line, ' ');
  switch(instruction[0]) {
  case "G1": 
    previz_pen.x = float(instruction[1].substring(1));
    previz_pen.y = float(instruction[2].substring(1));
    previz_render_line(previz_pen_prev, previz_pen);
    previz_pen_prev.x = previz_pen.x;
    previz_pen_prev.y = previz_pen.y;
    break;
  case "G0":
    previz_pen.x = float(instruction[1].substring(1));
    previz_pen.y = float(instruction[2].substring(1));
    previz_render_hover(previz_pen_prev, previz_pen);
    previz_pen_prev.x = previz_pen.x;
    previz_pen_prev.y = previz_pen.y;
    break;
  default: 
    break;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : GLINE
void previz_render_hover(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  translate(previz_x, previz_y);
  scale(previz_scale);
  stroke(0, 0, 0, 50);
  strokeWeight(1);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
  popStyle();
  previz_gcode_updateLineBoundaries(p1, p2);
  counterLines++;
}

void previz_render_line(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  translate(previz_x, previz_y);
  scale(previz_scale);
  stroke(0, 0, 255);
  strokeWeight(1);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
  popStyle();
  previz_gcode_updateLineBoundaries(p1, p2);
  counterLines++;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE LOG:LINE BOUNDARIES : line max and min
void previz_gcode_updateLineBoundaries(PVector p1, PVector p2) {
  if (p1.x< min_line_x) min_line_x=p1.x;
  if (p2.x< min_line_x) min_line_x=p2.x;
  if (p1.x> max_line_x) max_line_x=p1.x;
  if (p2.x> max_line_x) max_line_x=p2.x;
  if (p1.y< min_line_y) min_line_y=p1.y;
  if (p2.y< min_line_y) min_line_y=p2.y;
  if (p1.y> max_line_y) max_line_y=p1.y;
  if (p2.y> max_line_y) max_line_y=p2.y;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PRINT LOG CONTOURS SIZE
void printLogContours() {
  println("******************************************************");
  println("Min Line x:"+min_line_x+ "  y:"+min_line_y); 
  println("Max Line x:"+max_line_x+ "  y:"+max_line_y);
  println("Lines:"+counterLines);
}
