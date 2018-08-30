// Control interface : buttons, events
ControlP5 cp5;

// PARAMETER : GRAY TRESHOLD //////////////////////////////////////////////////////////////////////////
void pGrayTreshold(int v) {
  pGrayTreshold = v;
  updateContours();
}

// BUTTON : TAKE PHOTO ////////////////////////////////////////////////////////////////////////////////

void takePhoto() {
  camMirror.save("test.jpg");
  selectFile();
  updateContours();
}

//

void grayRect(int x, int y, int w, int h) {
  pushMatrix();
  pushStyle();
  noStroke();
  fill(200);
  rect(x, y, w, h);
  popStyle();
  popMatrix();
}

void initControl() {
  cp5 = new ControlP5(this);
  cp5.addSlider("pGrayTreshold")
    .setPosition(20, 20)
    .setSize(256, 10)
    .setRange(0, 255)
    .setValue(30);
  cp5.addButton("takePhoto")
    .setPosition(20, 40)
    .setSize(256, 10);
}
