import processing.video.*;

void setup() {
  size(1400, 700, P2D);
  initCamera();
}

void draw() {
  updateCamera();
  renderCamera();
}

void mouseClicked() {
  camMirror.save("test.jpg");
  cam.stop();
}
