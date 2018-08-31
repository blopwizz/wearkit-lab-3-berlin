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

// interface dimensions
int L1 = 380;

void setup() {
  size(1400, 700, P2D);
  initControl();
  initCamera();
  selectFile();
  initDimensions();
  printDimensions();
  updateContours();
}

void draw() {
  updateCamera();
  grayRect(0, 0, L1, 100);
  renderCamera(0, 100, L1);
  renderProcessed(0, 300, L1);
}
