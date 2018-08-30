// UTILITAIRIES FUNCTIONS: dimension, initialization ...
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES : paper and drawing dimension
int     A3=0;
int     vert=1;
float   paper_size_x = 200+120*A3;   
float   paper_size_y = 280;
float   paper_x_offset;
float   paper_y_offset;
float   image_size_x = 0;
float   image_size_y = 0;
PrintWriter OUTPUT;   
float  adj_x=0;
float  adj_y=0;
String fileN;
float rapp_xy;
String outFile = "GCODE/test.nc.txt";

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
void initFile() {
  // INPUT FILE
  img = loadImage("test.jpg");
  // OUPUT FILE
  OUTPUT = createWriter(outFile);
}

void printOutputFilePath() {
  println("output file:"+outFile);
  println("******************************************************");
}
////////////////////////////////////////////////////////////////////////////////////////////
// INIT DIMENSIONS : output A3, vert, offset, adj
void initDimensions(int state) {
  if (state == 1) {
    paper_size_x = 280;
    paper_size_y = 200;
    paper_x_offset = 0;
    paper_y_offset = 0;
    adj_x = 0.55;
    adj_y = 0.55;
  } else {
    // revise dimensions according to L1, with portrait or landscape resize
    rapp_xy=float(img.width) / float(img.height);

    if (img.width > L1 || img.height > L1) {  // image out of dimensions
      if (rapp_xy > 1)  
        img.resize(L1, int(L1/rapp_xy));      // landscape format
      else              
      img.resize(int(L1*rapp_xy), L1);      // portrait format
    }
    rapp_xy=float(img.width) / float(img.height);
    image_size_x = img.width;
    image_size_y = img.height;

    //resize the image in the paper (vertical or horizontal and the proportion)
    if (image_size_x>image_size_y) {           // horizontal
      rapp_xy=image_size_x/image_size_y;
      vert=0;
    } else {                                   // vertical
      rapp_xy=image_size_y/image_size_x;
      A3=0;
      vert=1;
    }

    if (vert==1)  // vertical, only A4 dimension
      if (rapp_xy > 1.4) {  // 1.4 is ratio of A4 format : if x is too big ...
        paper_size_y=280;             // then y is set to the maximum of A4
        paper_size_x=200/rapp_xy*1.4; // and x is adapted according to ratio 
        paper_x_offset=(200-paper_size_x)/2;  // an offset for x is created, to center
        paper_y_offset=0;
      } else {
        paper_size_x = 200;  // in this case, y is too big, and x is set to max of A4
        paper_size_y= 280*rapp_xy/1.4;  // y is adapted according to the ratio
        paper_x_offset=0;
        paper_y_offset=(280-paper_size_y)/2; // and the offset goes to y to center the drawing
      }


    if (vert==0)                                // horizontal
      if (A3==0) {                              // A4 format
        if (rapp_xy < 1.4) {                    // if y is too big
          paper_size_y= 200;                    // y is set to max of horizontal A4
          paper_size_x = 280*rapp_xy/1.4;       // and x is adapted according to the ratio 
          paper_x_offset=(280-paper_size_x)/2;  // offset for centering
          paper_y_offset=0;                     // no need to offset because y is max
        } else {                                // here, x is too big
          paper_size_x = 280;                   // so x is set to max of horizontal A4
          paper_size_y = 200/rapp_xy*1.4;       // and y is adapted according to ratio                    
          paper_x_offset=0;                     // no need to offset because x is max
          paper_y_offset=(200-paper_size_y)/2;  // offset for centering on y-axis
        }
      } else {                                  // A3 horizontal format : ratio 1.17
        if (rapp_xy < 1.17) {                   // if y is too big
          paper_size_y= 280;                    // set y to max of A3 horizontal
          paper_size_x = 330*rapp_xy/1.17;      // and x is adapted                     
          paper_x_offset=(330-paper_size_x)/2;  // offset to center x              
          paper_y_offset=0;                     // no need to offset because y is max
        } else {                                // x is too big                     
          paper_size_x = 330;                   // so x is set to max of A3 horizontal format                                 
          paper_size_y = 280/rapp_xy*1.17;      // and y is adapted                        
          paper_x_offset=0;                     // no need to offset because x is max                    
          paper_y_offset=(280-paper_size_y)/2;  // offset to center y
        }
      }   

    adj_x=paper_size_x/image_size_x;            // ratio between image and paper size
    adj_y=paper_size_y/image_size_y;
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : reset buffer
void resetBuffer() {
  OUTPUT.flush();                          // empty output buffer
  OUTPUT.close();                          // close output buffer
  OUTPUT = createWriter(outFile);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// COPY PIMAGE : copy pixel by pixel
void copyPImagePixels(PImage img1, PImage img2) {
  img1.loadPixels();                 
  for (int x = 0; x < img1.width; x++) {
    for (int y = 0; y < img1.height; y++) {
      img2.pixels[x+y*img1.width] = img1.pixels[x+y*img1.width];
    }
  }
  img2.updatePixels();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT : print dimensions
void printDimensions() {
  println("Original dim: "+img.width+" x "+ img.height + " ratio_xy:"+rapp_xy);
  println("Revised dim: "+img.width+" x "+ img.height + " ratio_xy:"+rapp_xy);
  println("PaperSize: "+paper_size_x+" x "+paper_size_y);
  println("Offset: "+paper_x_offset + " x " +paper_y_offset);
  println("Expected max dimension: "+ (image_size_x*adj_x+paper_x_offset) + " x " +(image_size_y*adj_y+paper_y_offset));
  println("******************************************************");
} 

// DRAW GRAY RECTANGLE /////////////////////////////////////////////////////////////////////////////////
void grayRect(int x, int y, int w, int h, int c) {
  pushMatrix();
  pushStyle();
  noStroke();
  fill(c);
  rect(x, y, w, h);
  popStyle();
  popMatrix();
}
