// SERIAL
///////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
// Objects
Serial serial_port;
String serial_received_msg;

// Counters and indicators
int serial_queued_commands = 0;
PVector serial_pen = new PVector(0, 0);
///////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION
void initSerial() {
  initPort();
  initGCode();
}
void initPort() {
  String portName = Serial.list()[1];
  println(portName);
  serial_port = new Serial(this, portName, 115200);
  serial_port.clear();
}
void initGCode() {                            // triggered when port is ready
  send(s_zero_position);
  send(s_feedrate);
  send(s_incremental_programming);
  ok_serial_gcode_init = true;
}
///////////////////////////////////////////////////////////////////////////////////////////
// UPDATE : SEND SERIAL
void send(String str) {
  serial_queued_commands += 1;
  serial_port.clear();
  serial_port.write(str);
  serial_port.write('\n');
  println(millis()+ " (" + serial_queued_commands + ") OUT > " + str);
  serial_port.clear();
}
