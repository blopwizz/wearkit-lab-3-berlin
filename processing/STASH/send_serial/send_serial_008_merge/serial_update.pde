// event serial
void serialEvent(Serial myPort) {
  msg = myPort.readStringUntil('\n');  // reading a message
  if (msg != null) {
    msg = trim(msg);

    if (msg.equals("M3S90ok")) {
      f_initPort = true;
      f_initGCode = false;
      initGCode();
    }

    if (msg.equals("ok")) {
      queued_commands -= 1;
    }
    port.clear();
    println(millis()+ " (" + queued_commands + ") IN  > "+ msg);
  }
}


void send(String str) {
  queued_commands += 1;
  port.clear();
  port.write(str);
  port.write('\n');
  println(millis()+ " (" + queued_commands + ") OUT > " + str);
  port.clear();
}
