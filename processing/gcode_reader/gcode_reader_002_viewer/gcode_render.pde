// GCODE VIEWER 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
boolean is_pen_down;
PVector pen_next = new PVector(0, 0);
PVector pen_prev = new PVector(0, 0);
float min_line_x=10000;
float min_line_y=10000;
float max_line_x=0;
float max_line_y=0;
int counterLines=0;
boolean cont=false;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : GLINE
void gcode_hoverLine(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  stroke(180);
  strokeWeight(3);
  if (dist(p1.x, p1.y, p2.x, p2.y) > 100 || cont) {
    line(p1.x, p2.y, p2.x, p2.y);
  }
  popMatrix();
  popStyle();
  updateLineBoundaries(p1, p2);
}

void gcode_drawLine(PVector p1, PVector p2) { 
  pushStyle();
  pushMatrix();
  stroke(0);
  strokeWeight(3);
  line(p1.x, p1.y, p2.x, p2.y);
  popMatrix();
  popStyle();
  updateLineBoundaries(p1, p2);
  counterLines++;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE LOG:LINE BOUNDARIES : line max and min
void updateLineBoundaries(PVector p1, PVector p2) {
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
