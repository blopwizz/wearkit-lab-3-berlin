void initPort() {
  String portName = Serial.list()[1];
  println(portName);
  port = new Serial(this, portName, 115200);
  port.clear();
}

void initGCode() {
  send(s_zero_position);
  send(s_feedrate);
  send(s_incremental_programming);
}
