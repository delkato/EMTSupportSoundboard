import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
SamplePlayer bp1, btcold, bthot, hr1, pain1, rr1;
ControlP5 cp5;
Glide BPSysGlide, BPDiasGlide, HRGlide, RRGlide, BTGlide, PainGlide;

//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(320, 240); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions
  cp5 = new ControlP5(this);
  bp1 = getSamplePlayer("bp1.wav");
  btcold = getSamplePlayer("btcold.wav");
  bthot = getSamplePlayer("bthot.wav");
  hr1 = getSamplePlayer("hr1.wav");
  pain1 = getSamplePlayer("pain1.wav");
  rr1 = getSamplePlayer("rr1.wav");
  
  BPSysGlide = new Glide(ac, 0.0, 50);
  BPDiasGlide = new Glide(ac, 0.0, 50);
  HRGlide = new Glide(ac, 0.0, 50);
  RRGlide = new Glide(ac, 0.0, 50);
  BTGlide = new Glide(ac, 0.0, 50);
  PainGlide = new Glide(ac, 0.0, 50);

  // Vertical Blood Pressure Slider
  cp5.addSlider("BPSysSlider")
    .setPosition(0,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider")
    .setPosition(40,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider")
    .setPosition(80,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider")
    .setPosition(120,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider")
    .setPosition(160,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider")
    .setPosition(200,0)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("Pain")
    ;

  //ac.out.addInput();
  ac.start();
}

void draw() {
  background(0);  //fills the canvas with black (0) each frame
}

public void BPSysSlider(int newGain) {
  BPSysGlide.setValue(newGain/100.0);
}

public void BPDiasSlider(int newGain) {
  BPDiasGlide.setValue(newGain/100.0);
}

public void HRSlider(int newGain) {
  HRGlide.setValue(newGain/100.0);
}

public void RRSlider(int newGain) {
  RRGlide.setValue(newGain/100.0);
}

public void BTSlider(int newGain) {
  BTGlide.setValue(newGain/100.0);
}

public void PainSlider(int newGain) {
  PainGlide.setValue(newGain/100.0);
}