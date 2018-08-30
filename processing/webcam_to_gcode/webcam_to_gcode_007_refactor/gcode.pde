// GCODE : writing out gcode instructions for the printer
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
boolean is_pen_down;
float  max_gcode_x=0;
float  max_gcode_y=0;
float  min_gcode_x=10000;
float  min_gcode_y=10000;
float  min_line_x=10000;
float  min_line_y=10000;
float  max_line_x=0;
float  max_line_y=0;
int counterGlines=0;
int counterLines=0;
boolean cont=false;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PEN UP AND DOWN
void pen_up() {
  String buf = "M03";
  is_pen_down = false;
  OUTPUT.println(buf);
}
void pen_down() {
  String buf = "M05"; 
  is_pen_down = true;
  OUTPUT.println(buf);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// MOVE INSTRUCTIONS
void move_abs(float x, float y) {
  String buf = "G1 X" + (x*adj_x+paper_x_offset) + " Y" + (paper_size_y-y*adj_y+paper_y_offset)+" F3000";  //<--- F is the speed of the arm. Decrease it if is too fast
  OUTPUT.println(buf);
  counterGlines++;
  updateGCodeBoundaries(x, y);
}
void move_fast(float x, float y) {
  String buf = "G0 X" + (x*adj_x+paper_x_offset) + " Y" + (paper_size_y-y*adj_y+paper_y_offset);
  OUTPUT.println(buf);
  counterGlines++;
  updateGCodeBoundaries(x, y);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// GLINE
void Gline(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);
  if (dist(x1, y1, x2, y1) > 100 || cont) {
    line(x1, y1, x2, y2);
    updateLineBoundaries(x1, y1, x2, y2);
    pen_up();
    move_fast(x1, y1);
    pen_down();
    move_abs(x2, y2);
    counterLines++;
  }
}

void GlineCont(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);
  line(x1, y1, x2, y2);
  updateLineBoundaries(x1, y1, x2, y2);
  move_abs(x2, y2);
  counterLines++;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE GCODE BOUNDARIES : update gcode max and min
void updateGCodeBoundaries(float x, float y) {
  if (x*adj_x+paper_x_offset> max_gcode_x)  max_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset> max_gcode_y) max_gcode_y=y*adj_y+paper_y_offset;
  if (x*adj_x+paper_x_offset< min_gcode_x)  min_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset< min_gcode_y) min_gcode_y=y*adj_y+paper_y_offset;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE LINE BOUNDARIES : line max and min
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
