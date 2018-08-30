String path = "test.nc.txt";
boolean f_drawingCompleted = false;

void setup() {
  size(1400, 700);
  background(200);
  initReader();
}

void draw() {  
  updateReader();
  if (line!=null) {
    gcode_interpret(line);
  } else if (!f_drawingCompleted) {
    printLogContours();
    f_drawingCompleted = true;
  }
}

void mouseClicked() {
}
