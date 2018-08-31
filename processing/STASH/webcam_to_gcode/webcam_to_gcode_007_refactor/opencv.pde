// OPENCV image processing : thresholding, contour finding, etc ...
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
OpenCV opencv;
PImage img, resultImg, processed;
PImage src, dst;
ArrayList<Contour> contours;
ArrayList<Contour> polygons;
ArrayList<Line> lines;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE CONTOURS

void initOpenCV() {
}

void updateOpenCV() {  
  resultImg = createImage(img.width, img.height, RGB);     // create PImage  
  opencv = new OpenCV(this, img);                          // load image in opencv
  opencv.gray();                                           // black and white                                                                                     
  //opencv.findCannyEdges(150, 150);                       // find edges
  opencv.threshold(pGrayTreshold);                         // threshold with parameter
  //opencv.dilate();                                                                
  //opencv.erode();                                                   
  //opencv.erode();                                                      
  //opencv.dilate();                                                            
  //opencv.blur(1);

  dst = opencv.getOutput();
  contours = opencv.findContours();
  processed = opencv.getSnapshot();

  String buf="F3000";
  OUTPUT.println(buf);

  pushMatrix();
  translate(380, 100);
  float r = 2*L1/ ((float)max_line_x);
  scale(r);
  grayRect(0, 0, 2*L1, 2*L1, 255);

  //find contour lines
  for (Contour contour : contours) {
    contour.setPolygonApproximationFactor(pApproximationFactor);
    beginShape();
    PVector old_p2;
    old_p2 = new PVector(0, 0);
    Contour c=  contour.getPolygonApproximation();
    for (int i = 0; i < c.getPoints ().size()-1; i++) {
      PVector p1 = c.getPoints().get(i);
      PVector p2 = c.getPoints().get(i+1);
      if (old_p2 == p1)
        GlineCont(p1.x, p1.y, p2.x, p2.y);
      else
        Gline(p1.x, p1.y, p2.x, p2.y);
      old_p2=p2;
    }
  }     
  endShape();
  popMatrix();

  buf="M03";
  OUTPUT.println(buf);
  OUTPUT.flush();
  OUTPUT.close();

  save("processed/"+fileN);
}

void printContours() {
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
  println("Lines GCode:"+counterGlines);
  println("processed/"+fileN);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// RENDER PROCESSED image on screen

void renderProcessed(int x, int y, int L) {
  pushMatrix();
  translate(x, y);
  float r = L/((float)dst.width);
  scale(r);
  image(dst, 0, 0);
  popMatrix();
}
