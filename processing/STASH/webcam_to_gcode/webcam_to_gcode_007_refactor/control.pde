// CONTROL INTERFACE : buttons, events 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// VARIABLES
ControlP5 cp5;
PImage snapshot;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// INITIALIZATION 
void initControl() {
  cp5 = new ControlP5(this);
  cp5.addButton("takePhoto")
    .setPosition(20, 20)
    .setSize(256, 10);
  cp5.addSlider("pGrayTreshold")
    .setPosition(20, 40)
    .setSize(256, 10)
    .setRange(0, 255)
    .setValue(30);
  cp5.addSlider("pApproximationFactor")
    .setPosition(20, 60)
    .setSize(256, 10)
    .setRange(0, 30)
    .setValue(2);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// BUTTON : TAKE PHOTO 
void takePhoto() {
  camMirror.save(savePath("test.jpg"));    // save camera view
  copyPImagePixels(camMirror, snapshot);   // copy camMirror into snapshot
  img = snapshot;                          // img to process : snapshot
  resetBuffer();
  updateOpenCV();                        // update new contours
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// PARAMETER : GRAY TRESHOLD
void pGrayTreshold(int v) {
  pGrayTreshold = v;
  resetBuffer();
  updateOpenCV();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
// PARAMETER : APPROXIMATION FACTOR
void pApproximationFactor(int v) {
  pApproximationFactor = v;
  resetBuffer();
  updateOpenCV();
}
