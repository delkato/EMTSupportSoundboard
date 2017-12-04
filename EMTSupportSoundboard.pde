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
  size(1280, 720); //size(width, height) must be the first line in setup()
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
  
  //User Input Side
  cp5.addButton("addPatient")
   .setPosition(100,60)
   .setSize(100,30)
   .setLabel("Add Patient");
   
  cp5.addButton("removePatient")
   .setPosition(100,100)
   .setSize(100,30)
   .setLabel("Remove Patient");
   
  cp5.addButton("patientFocus")
   .setPosition(100,140)
   .setSize(100,30)
   .setLabel("Focus Patient");
   
  cp5.addCheckBox("patientCheckBox")
    .setPosition(250, 80)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(1)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Patient 1", 10)
    .addItem("Patient 2", 20)
    .addItem("Patient 3", 30);
    
   
  cp5.addButton("vitalFocus")
   .setPosition(100,220)
   .setSize(100,30)
   .setLabel("Focus Vital");
  cp5.addButton("removeVitalFocus")
   .setPosition(100,260)
   .setSize(100,30)
   .setLabel("Remove Vital Focus");
  
  cp5.addCheckBox("vitalCheckBox")
    .setPosition(250, 220)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .setSpacingRow(20)
    .addItem("BloodPressure", 0)
    .addItem("HeartRate", 1)
    .addItem("RespiratoryRate", 2)
    .addItem("BodyTemperature", 3)
    .addItem("PainLevel", 4);
    
   
  cp5.addButton("addNotes")
   .setPosition(100,360)
   .setSize(100,30)
   .setLabel("Add Notes");
   
   PFont font = createFont("arial",20);
   cp5.addTextfield("notes")
     .setPosition(260,360)
     .setSize(300,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;



  
  
  
  cp5.addButton("sendNotes")
   .setPosition(100,400)
   .setSize(100,30)
   .setLabel("Send Notes");
   
   
   
  
  //PATIENT 1
  cp5.addTextlabel("label")
      .setText("Patient 1")
      .setPosition(800,30)
      .setColorValue(0xffffff00)
      .setFont(createFont("Georgia",20))
      ;
  //Detected checkbox
  cp5.addCheckBox("detectedCheckBox1")
    .setPosition(900, 70)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Patient 1 Detected", 0);
  // Submit Heart Rate Changes Button
    cp5.addButton("HealthButton1")
   .setPosition(800,60)
   .setSize(80,30)
   .setLabel("Submit Changes");
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPSysSlider1")
    .setPosition(1000,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider1")
    .setPosition(1040,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider1")
    .setPosition(1080,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider1")
    .setPosition(1120,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider1")
    .setPosition(1160,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider1")
    .setPosition(1200,10)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("Pain")
    ;
    
    
    
    //PATIENT 2
  cp5.addTextlabel("label2")
      .setText("Patient 2")
      .setPosition(800,270)
      .setColorValue(0xffffff00)
      .setFont(createFont("Georgia",20))
      ;
  //Detected checkbox
  cp5.addCheckBox("detectedCheckBox2")
    .setPosition(900, 320)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Patient 2 Detected", 0);
  // Submit Heart Rate Changes Button
    cp5.addButton("HealthButton2")
   .setPosition(800,310)
   .setSize(80,30)
   .setLabel("Submit Changes");
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPSysSlider2")
    .setPosition(1000,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider2")
    .setPosition(1040,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider2")
    .setPosition(1080,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider2")
    .setPosition(1120,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider2")
    .setPosition(1160,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider2")
    .setPosition(1200,260)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("Pain")
    ;
     
    //PATIENT 3
  cp5.addTextlabel("label3")
      .setText("Patient 3")
      .setPosition(800,520)
      .setColorValue(0xffffff00)
      .setFont(createFont("Georgia",20))
      ;
  //Detected checkbox
  cp5.addCheckBox("detectedCheckBox3")
    .setPosition(900, 570)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .addItem("Patient 3 Detected", 0);
  // Submit Heart Rate Changes Button
    cp5.addButton("HealthButton3")
   .setPosition(800,560)
   .setSize(80,30)
   .setLabel("Submit Changes");
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPSysSlider2")
    .setPosition(1000,510)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider3")
    .setPosition(1040,510)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider3")
    .setPosition(1080,510)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider3")
    .setPosition(1120,510)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider3")
    .setPosition(1160,510)
    .setSize(15,100)
    .setRange(0,100)
    .setValue(50)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider3")
    .setPosition(1200,510)
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

public void BPSysSlider1(int newGain) {
  BPSysGlide.setValue(newGain/100.0);
}

public void BPDiasSlider1(int newGain) {
  BPDiasGlide.setValue(newGain/100.0);
}

public void HRSlider1(int newGain) {
  HRGlide.setValue(newGain/100.0);
}

public void RRSlider1(int newGain) {
  RRGlide.setValue(newGain/100.0);
}

public void BTSlider1(int newGain) {
  BTGlide.setValue(newGain/100.0);
}

public void PainSlider1(int newGain) {
  PainGlide.setValue(newGain/100.0);
}
public void BPSysSlider2(int newGain) {
  BPSysGlide.setValue(newGain/100.0);
}

public void BPDiasSlider2(int newGain) {
  BPDiasGlide.setValue(newGain/100.0);
}

public void HRSlider2(int newGain) {
  HRGlide.setValue(newGain/100.0);
}

public void RRSlider2(int newGain) {
  RRGlide.setValue(newGain/100.0);
}

public void BTSlider2(int newGain) {
  BTGlide.setValue(newGain/100.0);
}

public void PainSlider2(int newGain) {
  PainGlide.setValue(newGain/100.0);
}
public void BPSysSlider3(int newGain) {
  BPSysGlide.setValue(newGain/100.0);
}

public void BPDiasSlider3(int newGain) {
  BPDiasGlide.setValue(newGain/100.0);
}

public void HRSlider3(int newGain) {
  HRGlide.setValue(newGain/100.0);
}

public void RRSlider3(int newGain) {
  RRGlide.setValue(newGain/100.0);
}

public void BTSlider3(int newGain) {
  BTGlide.setValue(newGain/100.0);
}

public void PainSlider3(int newGain) {
  PainGlide.setValue(newGain/100.0);
}