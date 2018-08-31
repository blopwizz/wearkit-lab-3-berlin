import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;
import controlP5.*;

// global variables
PImage img, resultImg, processed;
PImage src, dst;

// values to tweak
int pGrayTreshold = 30;

// image dimensions
int large = 700;

void setup() {
  size(1400, 700);
  selectFile();
  updateDimensions();
  updateDrawing();
  initControl();
}

void draw() {
}

// event slider
void pGrayTreshold(int v) {
  pGrayTreshold = v;
  updateDrawing();
}
