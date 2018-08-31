OscP5 oscP5;
NetAddress myRemoteLocation;

void osc_init() {
  oscP5 = new OscP5(this, 3337);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/vResistivity")==true) {
    if (msg.checkTypetag("i")) {
      v_resistivity = msg.get(0).intValue();
      if (ok_print_osc) println(millis() + " OSC IN  "+ v_resistivity);
      return;
    }
  }
}

void osc_update() {
  if (v_resistivity != 1024) {
    if (ok_print_debug && !ok_osc_detected) print_debug(" OSC DETECTED !");
    ok_osc_detected = true;
  }
  if (v_resistivity < 200 && !ok_machine_busy && !ok_sequence_busy) {
    ok_sequence_busy = true;
    cam_mirror.save(path_photo);               // save camera view
    copy_PImage(cam_mirror, snapshot);   // copy camMirror into snapshot
    img = snapshot;                          // img to process : snapshot
    update();
    if (ok_print_debug) print_debug(" OSC -> PHOTO SHOT");

    previz_init();
    if (ok_print_debug) print_debug(" OSC -> PREVIZ");
  }
  if (ok_sequence_busy && ok_machine_ready && !ok_machine_busy && ok_previz_done) {
    machine_launch_task();
    ok_sequence_busy = false;
    if (ok_print_debug) print_debug(" OSC -> MACHINE");
  }
}
