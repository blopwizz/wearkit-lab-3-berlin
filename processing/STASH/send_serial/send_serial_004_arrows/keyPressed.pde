void keyPressed() {  
  switch (key) {
  case CODED:
    {
      switch(keyCode) {
      case UP: 
        move(UP); 
        break;
      case DOWN: 
        move(DOWN); 
        break;
      case RIGHT: 
        move(RIGHT); 
        break;
      case LEFT: 
        move(LEFT); 
        break;
      default: 
        break;
      }
    }
    break;
  case ':': 
    pen_down(); 
    break;
  case '=': 
    pen_up(); 
    break;
  case BACKSPACE:
  case TAB:
  case ENTER:
  case RETURN:
  case ESC:
  case DELETE:
  case 'a': 
    set_speed(1000);
    break;
  case 'b': 
    set_speed(3000);
    break;
  case 'c': 
    set_speed(3500);
    break;
  case '9': 
    go_home(); 
    break;
  case '0': 
    set_zero(); 
    break; 
  case 'd': move(10, 10);
  break;
  case 'e': 
  case 'f': 
  case 'g': 
  case 'h': 
  case 'i': 
  case 'j': 
  case 'k': 
  case 'l': 
  case 'm': 
  case 'n': 
  case 'o': 
  case 'p': 
  case 'q': 
  case 'r': 
  case 's': 
  case 't': 
  case 'u': 
  case 'v': 
  case 'w': 
  case 'x': 
  case 'y': 
  case 'z':
  case 'A': 
  case 'B': 
  case 'C': 
  case 'D': 
  case 'E': 
  case 'F': 
  case 'G': 
  case 'H': 
  case 'I': 
  case 'J': 
  case 'K': 
  case 'L': 
  case 'M': 
  case 'N': 
  case 'O': 
  case 'P': 
  case 'Q': 
  case 'R': 
  case 'S': 
  case 'T': 
  case 'U': 
  case 'V': 
  case 'W': 
  case 'X': 
  case 'Y': 
  case 'Z': 
  case '1': 
  case '2': 
  case '3': 
  case '4': 
  case '5': 
  case '6': 
  case '7': 
  case '8': 
  case ' ':
  case '.':
  case '_': 
  case '&': 
  case '\\': 
  default: 
    println("ERROR: unknown key " + key);
    break;
  }
}