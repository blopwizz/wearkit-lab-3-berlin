///////////////////////////////////////////////////////////////////////////////////////////
// READER 
///////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
BufferedReader reader;
String line;
int n_lines;
int i_reader;
///////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
void reader_init() { 
  ok_reader_busy = true;
  reader = createReader(path_gcode);
  n_lines = reader_count_lines(path_gcode);
  i_reader = 0;
  if (ok_print_debug) print_debug("Reading file ...");
}

// RESET
void closeReader() {
  try {
    reader.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////
// UPDATE | gets a new line from the file, and update the flag
void reader_update() {
  try {
    line = reader.readLine();
    ok_reader_busy = line!=null;
    if (ok_reader_busy) {
      i_reader++;
    } else {
      closeReader();
      if (ok_print_debug) print_debug("Reader closed.");
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
    noLoop();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////
// UTILS
int reader_count_lines(String path) {
  BufferedReader tempReader = createReader(path);
  int n_lines = 0;
  try {
    while (tempReader.readLine() != null) {
      n_lines++;
    }
    tempReader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  return n_lines;
}
