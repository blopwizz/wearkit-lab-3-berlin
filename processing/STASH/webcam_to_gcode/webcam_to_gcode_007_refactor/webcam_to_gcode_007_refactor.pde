
///////////////////////////////////////////////////////////////////////////////////////////////////////

import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;
import controlP5.*;
import processing.video.*;

// values to tweak
int pGrayTreshold = 30;
int pApproximationFactor = 2;

// interface dimensions
int L1 = 360;

void setup() {
  size(1400, 700);
  background(200);
  initFile();
  initDimensions();
  initControl();
  initCamera();
  initOpenCV();
  updateOpenCV();
}

void draw() {
  updateCamera();
  grayRect(0, 0, L1, 100, 150);
  renderCamera(0, 100, L1);
  renderProcessed(0, 300, L1);
}
