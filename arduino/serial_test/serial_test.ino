char val;
int ledPin = 13;
boolean ledState = LOW;

void setup() {
  pinMode(ledPin, OUTPUT);
  Serial.begin(115200);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
    val = Serial.read();
    Serial.println(String(val));
    delay(10);
  }
  else {
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");
    delay(300);
  }
}
