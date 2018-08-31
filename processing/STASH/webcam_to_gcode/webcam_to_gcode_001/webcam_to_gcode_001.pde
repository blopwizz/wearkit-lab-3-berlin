import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;
import controlP5.*;
import processing.video.*;

Capture video;
PImage prev;

// values to tweak
int pGrayTreshold = 30;

// screen dimensions (change also size())
int large = 700;

void setup() {
  size(1400, 700);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[3]);
  video.start();
  prev = createImage(640, 360, RGB);
  selectFile();
  updateDimensions();
  updateDrawing();
  initControl();
}

void draw() {
  renderDrawing();
  video.loadPixels();
  prev.loadPixels();
  pushMatrix();
  scale(-0.5, 0.5);
  image(video, -640, 100);
  popMatrix();
}

// UI events
void pGrayTreshold(int v) {
  pGrayTreshold = v;
  //updateDrawing();
}

void takePhoto() {
  println("photo took");
}

void captureEvent(Capture webcam)
{
  video.read();
}


void mouseClicked() {
}
