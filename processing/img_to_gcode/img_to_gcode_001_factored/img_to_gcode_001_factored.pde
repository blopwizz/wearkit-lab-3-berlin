import gab.opencv.*;
import java.util.ArrayList;
import org.opencv.core.Mat;

PImage img, resultImg, processed;
PImage src, dst;

// values to tweak
int paramGrayTreshold = 30;
int paramBlur = 5;

// screen dimensions (change also size())
int large = 700;

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
  size(1400, 700);
  selectFile();
  updateDimensions();
  updateDrawing();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
