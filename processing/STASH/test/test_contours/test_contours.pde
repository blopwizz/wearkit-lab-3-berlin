import gab.opencv.*;

int paramGrayTreshold = 140;
int paramStrokeWeight = 5;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  src = loadImage("test.jpg"); 
  size(1080, 360);
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(paramGrayTreshold);
  dst = opencv.getOutput();
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
}

void draw() {
  background(255);
  scale(0.5);
  //image(src, 0, 0);
  image(dst, src.width, 0);

  noFill();
  strokeWeight(paramStrokeWeight);
  
  for (Contour contour : contours) {
    stroke(0,0, 0);
    contour.draw();
    //stroke(0, 0, 0);
    //beginShape();
    //for (PVector point : contour.getPolygonApproximation().getPoints()) {
    //  vertex(point.x, point.y);
    //}
    //endShape();
  }
}
