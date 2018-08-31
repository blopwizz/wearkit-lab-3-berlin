// GCODE : writing out gcode instructions for the printer
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
boolean is_pen_down;
float  max_gcode_x=0;
float  max_gcode_y=0;
float  min_gcode_x=10000;
float  min_gcode_y=10000;
boolean cont = true;
boolean f_hoveredToFirstPoint = false; // hovered to first point
boolean f_new_contour = true;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE GCODE CONTOURS
void contour_update() {
  counterLines = 0;                                         //counter
  gcode_set_speed(c_speed);

  pushMatrix();
  if (ok_ui_debug) rect_draw(contour_x, contour_y, L1, height, 255);

  translate(contour_x, contour_y);
  scale(contour_scale);
  noStroke();

  for (Contour contour : contours) {
    f_new_contour = true;
    contour.setPolygonApproximationFactor(p_polygon);    
    Contour c = contour.getPolygonApproximation();         // A list of points drawing multiple broken lines,
    beginShape();
    for (int i=0; i<c.getPoints().size()-1; i++) {    // for all the points in the contour list.
      PVector p1 = c.getPoints().get(i);                   // Get one point,
      PVector p2 = c.getPoints().get(i+1);                 // and its successor.
      float x1 = p1.x*adj_x + paper_x_offset;              // scale
      float x2 = p2.x*adj_x + paper_x_offset;
      float y1 = p1.y*adj_y + paper_y_offset;
      float y2 = p2.y*adj_y + paper_y_offset;
      if (inBoundaries(p1, p2)) {
        if (f_new_contour) {                                // if same contour
          gcode_moveAndDraw(x1, y1, x2, y2); 
          f_new_contour = false;
        } else {                                   
          gcode_continueDraw(x1, y1, x2, y2);
        }
      }
    }
  }     
  endShape();
  popMatrix();
  gcode_pen_up();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : PEN UP AND DOWN
void gcode_pen_up() {
  String buf = "M03";
  is_pen_down = false;
  printBufferToOutput(buf);
}
void gcode_pen_down() {
  String buf = "M05"; 
  is_pen_down = true;
  printBufferToOutput(buf);
}
void gcode_set_speed(int s) {
  String buf = "F"+s;
  printBufferToOutput(buf);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : hover LINE
void gcode_moveAndDraw(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);
  if (dist(x1, y1, x2, y2) > 100 || cont) {
    if (ok_ui_debug) line(x1, y1, x2, y2);
    updateLineBoundaries(x1, y1, x2, y2);
    gcode_pen_up();
    move_fast(x1, y1);
    gcode_pen_down();
    move_abs(x2, y2);
    counterLines++;
  }
}

void gcode_continueDraw(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);
  if (ok_ui_debug) line(x1, y1, x2, y2);
  updateLineBoundaries(x1, y1, x2, y2);
  move_abs(x2, y2);
  counterLines++;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : MOVE INSTRUCTIONS
void move_abs(float x, float y) {
  String buf = "G1 X" + x + " Y" + y+" F"+c_speed;  // F is the speed of the arm. Decrease it if is too fast
  printBufferToOutput(buf);
  updateGCodeBoundaries(x, y);
}
void move_fast(float x, float y) {
  String buf = "G0 X" + x + " Y" + y;
  printBufferToOutput(buf);
  updateGCodeBoundaries(x, y);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE LOG: GCODE BOUNDARIES : update gcode max and min
void updateGCodeBoundaries(float x, float y) {
  if (x*adj_x+paper_x_offset> max_gcode_x)  max_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset> max_gcode_y) max_gcode_y=y*adj_y+paper_y_offset;
  if (x*adj_x+paper_x_offset< min_gcode_x)  min_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset< min_gcode_y) min_gcode_y=y*adj_y+paper_y_offset;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE LOG:LINE BOUNDARIES : line max and min
void updateLineBoundaries(float x1, float y1, float x2, float y2) {
  if (x1< min_line_x) min_line_x=x1;
  if (x2< min_line_x) min_line_x=x2;
  if (x1> max_line_x) max_line_x=x1;
  if (x2> max_line_x) max_line_x=x2;
  if (y1< min_line_y) min_line_y=y1;
  if (y2< min_line_y) min_line_y=y2;
  if (y1> max_line_y) max_line_y=y1;
  if (y2> max_line_y) max_line_y=y2;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT: PRINT BUFFER TO OUTPUT
void printBufferToOutput(String buf) {
  OUTPUT.println(buf);
  if (ok_print_buffer) println(millis() + " " + buf);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT: SAVE GCODE AND PROCESSED IMAGE
void gcode_save() {
  OUTPUT.flush();
  OUTPUT.close();
  save("processed/"+fileN);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PRINT LOG CONTOURS SIZE
void printlog_contour() {
  println("found " + contours.size() + " contours");

  println("******************************************************");

  println("Min Line x:"+min_line_x+ "  y:"+min_line_y); 
  println("Max Line x:"+max_line_x+ "  y:"+max_line_y);
  println("Max Gcode X:"+max_gcode_x+ "  y:"+max_gcode_y); 
  println("Min Gcode X:"+min_gcode_x+ "  y:"+min_gcode_y);
  float d1=max_gcode_x-min_gcode_x;
  float d2=max_gcode_y-min_gcode_y;
  println("Delta Gcode  X:"+ d1 + " Y:"+ d2);
  println("Lines:"+counterLines);
  println("processed/"+fileN);
}


boolean inBoundaries(PVector p1, PVector p2) {
  boolean res = true;
  if ((p1.x<2.0 && p2.x<2.0)||(p1.y<2.0 && p2.y<2.0) ||(p1.y > 356.0 && p2.y > 356.0)) {
    res = false;
  }
  return res;
}
