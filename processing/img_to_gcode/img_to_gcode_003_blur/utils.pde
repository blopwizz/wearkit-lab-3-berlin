void selectFile() {
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
}


void updateDimensions() {
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
}


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
