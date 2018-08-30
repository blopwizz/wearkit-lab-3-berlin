//////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT
void serialEvent(Serial myPort) {
  serial_received_msg = myPort.readStringUntil('\n');  // reading a message
  if (serial_received_msg != null) {
    serial_received_msg = trim(serial_received_msg);
    if (serial_received_msg.equals("M3S90ok")) {
      ok_serial_port_init = true;
      ok_serial_gcode_init = false;
      initGCode();
    }

    if (serial_received_msg.equals("ok")) {
      serial_queued_commands -= 1;
    }
    serial_port.clear();
    println(millis()+ " (" + serial_queued_commands + ") IN  > "+ serial_received_msg);
  }
}
//////////////////////////////////////////////////////////////////////////////////
// USER EVENT : keyboard, mouse
void keyPressed() {  
  switch (key) {
  case CODED:
    {
      switch(keyCode) {
      case UP: 
        serial_move(UP); 
        break;
      case DOWN: 
        serial_move(DOWN); 
        break;
      case RIGHT: 
        serial_move(RIGHT); 
        break;
      case LEFT: 
        serial_move(LEFT); 
        break;
      default: 
        break;
      }
    }
    break;
  case ':': 
    serial_pen_down(); 
    break;
  case '=': 
    serial_pen_up(); 
    break;
  case BACKSPACE:
  case TAB:
  case ENTER:
  case RETURN:
  case ESC:
  case DELETE:
  case 'a': 
    serial_set_speed(1000);
    break;
  case 'b': 
    serial_set_speed(3000);
    break;
  case 'c': 
    serial_set_speed(3500);
    break;
  case '9': 
    serial_go_home(); 
    break;
  case '0': 
    serial_set_zero(); 
    break; 
  case 'd': 
    serial_move(10, 10);
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
