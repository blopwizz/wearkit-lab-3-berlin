import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;
import controlP5.*;
import processing.video.*;

// global variables
PImage img, resultImg, processed;
PImage src, dst;

// values to tweak
int pGrayTreshold = 30;

// screen dimensions
int large = 350;

// grid
int x0 = 0;
int x1 = 100;
int x2 = x1+large;
int y0=0;
int y1 = 100;
int y2 = y1+large;
int y3 = y2 +large;

void setup() {
  size(1400, 700, P2D);
  initCamera();
  selectFile();
  updateDimensions();
  updateDrawing();
  initControl();
}

void draw() {
  updateCamera();
  renderInterface();
  renderCamera(0, 100, 0.5);
  renderProcessed(0, 300, 1);
  renderDrawing(380, 0, 2);
}

// event slider
void pGrayTreshold(int v) {
  pGrayTreshold = v;
  updateDrawing();
}
