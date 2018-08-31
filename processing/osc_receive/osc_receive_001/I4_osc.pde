OscP5 oscP5;
NetAddress myRemoteLocation;

void osc_init() {
  oscP5 = new OscP5(this, 3337);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/vResistivity")==true) {
    if (msg.checkTypetag("i")) {
      int v_resistivity = msg.get(0).intValue();
      if (ok_print_osc) println(millis() + " OSC IN  "+ v_resistivity);
      return;
    }
  }
}
