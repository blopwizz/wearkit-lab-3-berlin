//////////////////////////////////////////////////////////////////////////////////
// USER EVENT : keyboard, mouse
void keyPressed() {  
  switch (key) {
  case CODED:
    {
      switch(keyCode) {
      case UP: 
        machine_move_manual(UP); 
        break;
      case DOWN: 
        machine_move_manual(DOWN); 
        break;
      case RIGHT: 
        machine_move_manual(RIGHT); 
        break;
      case LEFT: 
        machine_move_manual(LEFT); 
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
    machine_launch_task();
    break;
  case RETURN:
  case ESC:
  case DELETE:
  case 'a': 
  case 'b': 
  case 'c': 
  case '9': 
    go_home(); 
    break;
  case '0': 
    set_zero(); 
    break; 
  case 'd':
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
