// GCODE READER
//////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
String path = "test001.nc.txt";
boolean f_drawingCompleted = false;
boolean f_newLine = true;
float c_scale = 2;
//////////////////////////////////////////////////////////////////////////////////////////
// SETUP
void setup() {
  size(1400, 700);
  background(200);
  initReader();
}
//////////////////////////////////////////////////////////////////////////////////////////
// DRAW
void draw() {
  update();
}

void update() {
  updateReader();
  updateFlags();
  if (f_newLine) {
    gcode_interpret(line);
  } else if (!f_drawingCompleted) {
    printLogContours();
    f_drawingCompleted = true;
  }
}

void updateFlags() {
  if (line!=null) f_newLine = true; 
  else f_newLine = false;
}
