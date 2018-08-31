void updateDrawing() {
  // Opencv elaboration
  resultImg = createImage(img.width, img.height, RGB);

  background(255);
  // load the image with opencv
  opencv = new OpenCV(this, img);

  opencv.gray();
  //opencv.findCannyEdges(150, 150);
  opencv.threshold(paramGrayTreshold);
  opencv.dilate();
  opencv.erode();
  opencv.erode();
  opencv.dilate();
  //opencv.blur(paramBlur);
  dst = opencv.getOutput();
  image(dst, img.width, 0);
  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  processed = opencv.getSnapshot();

  String buf="F3000";
  OUTPUT.println(buf);

  //find contour lines
  for (Contour contour : contours) {
    contour.setPolygonApproximationFactor(1);
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
  buf="M03";
  OUTPUT.println(buf);
  OUTPUT.flush();
  OUTPUT.close();
  println("******************************************************");

  println("Min Line x:"+min_line_x+ "  y:"+min_line_y); 
  println("Max Line x:"+max_line_x+ "  y:"+max_line_y);
  println("Max Gcode X:"+max_gcode_x+ "  y:"+max_gcode_y); 
  println("Min Gcode X:"+min_gcode_x+ "  y:"+min_gcode_y);
  float d1=max_gcode_x-min_gcode_x;
  float d2=max_gcode_y-min_gcode_y;
  println("Delta Gcode  X:"+ d1 + " Y:"+ d2);
  println("Lines:"+liness);
  println("Lines GCode:"+Glines);
  println("processed/"+fileN);
  save("processed/"+fileN);
}
