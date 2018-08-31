void gcode_interpret(String line) {
  String[] list = split(line, ' ');
  print(millis() +" ("+i_reader + "/"+n_lines+") ");
  switch(list[0]) {
  case "F3000":
    print(line);
    println(" set up feed rate");
    break;
  case "G0": 
    print(line);
    println(" hoverLine");
    break;
  case "G1": 
    print(line);
    println(" drawLine");
    break;
  case "M03": 
    print(line);
    println(" pen_up");
    break;
  case "M05":
    print(line);
    println(" pen_down");
    break;
  default: 
    print(line);
    println(" unknown command"); 
    exit();
    break;
  }
}
