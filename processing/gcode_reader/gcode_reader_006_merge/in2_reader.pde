// READER
///////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
BufferedReader reader;
String line;
int n_lines;
int i_reader;
///////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
void initReader() {                   
  reader = createReader(path);
  n_lines = countLines(path);
  i_reader = 0;
  ok_reader_reading = true;
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
void updateReader() {
  try {
    line = reader.readLine();
    ok_reader_reading = (line!=null);                
    if (ok_reader_reading) {
      i_reader++;
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
    noLoop();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////
// UTILS
int countLines(String path) {
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
