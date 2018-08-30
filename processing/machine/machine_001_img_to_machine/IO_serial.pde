/////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT : receiving msg from the machine
/////////////////////////////////////////////////////////////////////////////////////////////////
// init
void serial_init() {
  String portName = Serial.list()[serialPortNumber];
  serial_port = new Serial(this, portName, 115200);
  serial_port.clear();
  if (ok_print_serial_port_list) printArray(Serial.list());
  if (ok_print_serial_port_name) println(portName);
  if (ok_print_debug) print_debug("Serial port connected.");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
// IN: receive serial (don't change the name of the function!)
void serialEvent(Serial myPort) {
  serial_received_msg = myPort.readStringUntil('\n');  // reading a message
  if (serial_received_msg != null) {
    serial_received_msg = trim(serial_received_msg);
    if (serial_received_msg.equals("M3S90ok")) {
      machine_init();
    }
    if (serial_received_msg.equals("ok")) {
      increment_queued_commands(-1);
    }
    if (ok_print_serial_IN) {
      println(millis()+ " (" + n_queued_commands + ") IN  > "+ serial_received_msg);
    }
    serial_port.clear();
  }
}
///////////////////////////////////////////////////////////////////////////////////////////
// OUT
void serial_send(String str) {
  increment_queued_commands(1);
  serial_port.clear();
  serial_port.write(str);
  serial_port.write('\n');
  if (ok_print_serial_OUT) println(millis()+ " (" + n_queued_commands + ") OUT > " + str);
  serial_port.clear();
}
