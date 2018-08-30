//////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT : RECEIVE MSG
void serialEvent(Serial myPort) {
  serial_received_msg = myPort.readStringUntil('\n');  // reading a message
  if (serial_received_msg != null) {
    serial_received_msg = trim(serial_received_msg);
    if (serial_received_msg.equals("M3S90ok")) {
      ok_serial_port_init = true;
      ok_serial_gcode_init = false;
      initMachine();
    }

    if (serial_received_msg.equals("ok")) {
      decrement_serial_queued_commands();
    }
    serial_port.clear();
    if (ok_print_serial_IN) {
      println(millis()+ " (" + serial_queued_commands + ") IN  > "+ serial_received_msg);
    }
  }
}
