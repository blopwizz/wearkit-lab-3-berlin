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
// INITIALIZATION
void opencv_init() {
  if (ok_import_photo) {
    PImage imported = loadImage("images/joy.jpg");
    imported.resize(360, 0);
    img = imported;
  }
  opencv = new OpenCV(this, img);                          // load image in opencv
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE OPENCV
void opencv_update() {  
  resultImg = createImage(img.width, img.height, RGB);     // create PImage  
  opencv.loadImage(img);                          // load image in opencv
  opencv.gray();                                           // black and white                                                                                     
  //opencv.findCannyEdges(150, 150);                       // find edges
  opencv.threshold(p_gray_treshold);                         // threshold with parameter
  //opencv.blur(2);
  //opencv.dilate();                                                                
  //opencv.erode();                                                   
  //opencv.erode();                                                      
  //opencv.dilate();                                                            

  dst = opencv.getOutput();
  contours = opencv.findContours();
  processed = opencv.getSnapshot();
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT: RENDER PROCESSED image on screen
void threshold_render(int x, int y, int L) {
  pushMatrix();
  translate(x, y);
  float r = L/((float)dst.width);
  scale(r);
  image(dst, 0, 0);
  popMatrix();
}
