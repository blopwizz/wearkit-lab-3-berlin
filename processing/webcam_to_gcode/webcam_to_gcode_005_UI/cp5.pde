// control P5
ControlP5 cp5;

void initControl() {
  cp5 = new ControlP5(this);
  cp5.addSlider("pGrayTreshold")
    .setPosition(20, 20)
    .setSize(256, 10)
    .setRange(0, 255)
    .setValue(30);
}

void renderInterface() {
  pushMatrix();
  pushStyle();
  noStroke();
  fill(200);
  rect(0, 0, 380, 100);
  popStyle();
  popMatrix();
}
