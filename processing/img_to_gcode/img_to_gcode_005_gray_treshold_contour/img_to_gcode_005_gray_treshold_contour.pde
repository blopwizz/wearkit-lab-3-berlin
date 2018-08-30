import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;

PImage img, resultImg, processed;
PImage src, dst;

// values to tweak
int paramGrayTreshold = 30;
int paramBlur = 5;

// paper and drawing dimension
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
boolean is_pen_down;
float  max_gcode_x=0;
float  max_gcode_y=0;
float  min_gcode_x=10000;
float  min_gcode_y=10000;
float  min_line_x=10000;
float  min_line_y=10000;
float  max_line_x=0;
float  max_line_y=0;

// file variables
String filename;
String [] myInputFileContents ;
String path;
String fileN;
String fileNoExt;

// opencv variables
OpenCV opencv;
ArrayList<Contour> contours;
ArrayList<Contour> polygons;
ArrayList<Line> lines;

int Glines=0;
int liness=0;

boolean cont=true;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  // INPUT FILE
  selectInput("Select a file to process:", "fileSelected");
  while (myInputFileContents == null) {
    println("waiting for file ...");
  }
  img = loadImage(filename);
  String outFile = "GCODE/"+fileNoExt+".nc.txt";
  OUTPUT = createWriter(outFile);
  println("output file:"+outFile);
  println("******************************************************");

  //picture dimension
  int large=800;
  float rapp_xy=float(img.width) / float(img.height);
  println("Original dim: "+img.width+" x "+ img.height + " ratio_xy:"+rapp_xy);

  if (img.width > large || img.height > large) {
    if (rapp_xy > 1) 
      img.resize(large, int(large/rapp_xy));
    else
      img.resize(int(large*rapp_xy), large);
  }

  rapp_xy=float(img.width) / float(img.height);
  println("Revised dim: "+img.width+" x "+ img.height + " ratio_xy:"+rapp_xy);
  image_size_x = img.width;
  image_size_y = img.height;

  size(1600, 800);

  //resize the image in the paper (vertical or horizontal and the proportion)
  if (image_size_x>image_size_y) {
    rapp_xy=image_size_x/image_size_y;
    vert=0;
  } else {
    rapp_xy=image_size_y/image_size_x;
    A3=0;
    vert=1;
  }

  // vertical - only A4 dimension
  if (vert==1)
    if (rapp_xy > 1.4) {
      paper_size_y=280;
      paper_size_x=200/rapp_xy*1.4;
      paper_x_offset=(200-paper_size_x)/2; 
      paper_y_offset=0;
    } else {
      paper_size_x = 200;  
      paper_size_y= 280*rapp_xy/1.4;
      paper_x_offset=0;
      paper_y_offset=(280-paper_size_y)/2;
    }

  if (vert==0)
    if (A3==0) {
      if (rapp_xy < 1.4) {
        paper_size_x = 280*rapp_xy/1.4;  
        paper_size_y= 200;
        paper_x_offset=(280-paper_size_x)/2;
        ;
        paper_y_offset=0;
      } else {
        paper_size_x = 280;  
        paper_size_y = 200/rapp_xy*1.4;
        paper_x_offset=0;
        paper_y_offset=(200-paper_size_y)/2;
      }
    } else { //A3==1
      if (rapp_xy < 1.17) {
        paper_size_x = 330*rapp_xy/1.17;  
        paper_size_y= 280;
        paper_x_offset=(330-paper_size_x)/2;
        ;
        paper_y_offset=0;
      } else {
        paper_size_x = 330;  
        paper_size_y = 280/rapp_xy*1.17;
        paper_x_offset=0;
        paper_y_offset=(280-paper_size_y)/2;
      }
    }   

  adj_x=paper_size_x/image_size_x;
  adj_y=paper_size_y/image_size_y;

  println("PaperSize: "+paper_size_x+" x "+paper_size_y);
  println("Offset: "+paper_x_offset + " x " +paper_y_offset);
  println("Expected max dimension: "+ (image_size_x*adj_x+paper_x_offset) + " x " +(image_size_y*adj_y+paper_y_offset));
  println("******************************************************");

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
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    filename = selection.getAbsolutePath();
    println("\n ******************************************************");
    println("User selected file: " + filename);
    myInputFileContents = loadStrings(filename) ;// this moves here...
    int indFile= filename.lastIndexOf("/");
    path=filename.substring(0, indFile+1);
    fileN=filename.substring(indFile+1, filename.length() ); 
    println("Input Path:"+path);
    println("Input FileName:"+fileN);
    fileNoExt=fileN.substring(0, fileN.length()-4 );
  }
}
