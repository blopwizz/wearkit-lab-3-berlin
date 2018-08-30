BufferedReader reader;
String line;
int n_lines;
int i_reader;

void initReader() {                   
  reader = createReader(path);
  n_lines = countLines(path);
  i_reader = 0;
}

void updateReader() {
  try {
    line = reader.readLine();
    if (line != null) {
      i_reader++;
    } else {
      noLoop();
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
    noLoop();
  }
}

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
