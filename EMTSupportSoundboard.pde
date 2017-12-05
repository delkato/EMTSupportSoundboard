import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Timer;
import java.util.TimerTask;


//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
SamplePlayer bp1, btcold, bthot, hr1, pain1, rr1, feedback;
ControlP5 cp5;
Patient patient1,patient2,patient3;
Glide BPSysGlide, BPDiasGlide, HRGlide, RRGlide, BTGlide, PainGlide;
Glide BPSysGlide2, BPDiasGlide2, HRGlide2, RRGlide2, BTGlide2, PainGlide2;
Glide BPSysGlide3, BPDiasGlide3, HRGlide3, RRGlide3, BTGlide3, PainGlide3;
CheckBox patientCheckBox;
public static Comparator<Notification> idComparator;
ArrayList<Notification> notifications;

CheckBox patientBox, vitalBox;

//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(1280, 720); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions
  cp5 = new ControlP5(this);
  

  idComparator = new Comparator<Notification>(){
      @Override
      public int compare(Notification c1, Notification c2) {
        if(  c1.getPriorityLevel()>c2.getPriorityLevel()) {  return -1;  }
        else if (  c1.getPriorityLevel()<c2.getPriorityLevel()){  return 1; }
              else{  return 0;}  
      }
    };
  
  bp1 = getSamplePlayer("bp1.wav");
  btcold = getSamplePlayer("btcold.wav");
  bthot = getSamplePlayer("bthot.wav");
  hr1 = getSamplePlayer("hr1.wav");
  pain1 = getSamplePlayer("pain1.wav");
  rr1 = getSamplePlayer("rr1.wav");
  feedback = getSamplePlayer("feedback.wav");
  
  BPSysGlide = new Glide(ac, 0.0, 50);
  BPDiasGlide = new Glide(ac, 0.0, 50);
  HRGlide = new Glide(ac, 0.0, 50);
  RRGlide = new Glide(ac, 0.0, 50);
  BTGlide = new Glide(ac, 0.0, 50);
  PainGlide = new Glide(ac, 0.0, 50);
  BPSysGlide2 = new Glide(ac, 0.0, 50);
  BPDiasGlide2 = new Glide(ac, 0.0, 50);
  HRGlide2 = new Glide(ac, 0.0, 50);
  RRGlide2 = new Glide(ac, 0.0, 50);
  BTGlide2 = new Glide(ac, 0.0, 50);
  PainGlide2 = new Glide(ac, 0.0, 50);
  BPSysGlide3 = new Glide(ac, 0.0, 50);
  BPDiasGlide3 = new Glide(ac, 0.0, 50);
  HRGlide3 = new Glide(ac, 0.0, 50);
  RRGlide3 = new Glide(ac, 0.0, 50);
  BTGlide3 = new Glide(ac, 0.0, 50);
  PainGlide3 = new Glide(ac, 0.0, 50);
  
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
   
  patientCheckBox = cp5.addCheckBox("patientCheckBox")
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
    .setRange(0,220)
    .setValue(120)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider1")
    .setPosition(1040,10)
    .setSize(15,100)
    .setRange(0,160)
    .setValue(80)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider1")
    .setPosition(1080,10)
    .setSize(15,100)
    .setRange(0,220)
    .setValue(80)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider1")
    .setPosition(1120,10)
    .setSize(15,100)
    .setRange(0,30)
    .setValue(12)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider1")
    .setPosition(1160,10)
    .setSize(15,100)
    .setRange(95,106)
    .setValue(98.6)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider1")
    .setPosition(1205,10)
    .setSize(15,100)
    .setRange(0,10)
    .setValue(5)
    .setLabel("Pain")
    ;
   cp5.addCheckBox("Afflictions1")
    .setPosition(950, 150)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .setSpacingRow(20)
    .addItem("HR Irregular 1", 0)
    .addItem("Unconscious 1", 0)
    .addItem("Breathing Obstructed 1", 0);
    
    
    
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
    .setRange(0,220)
    .setValue(120)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider2")
    .setPosition(1040,260)
    .setSize(15,100)
    .setRange(0,160)
    .setValue(80)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider2")
    .setPosition(1080,260)
    .setSize(15,100)
    .setRange(0,220)
    .setValue(80)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider2")
    .setPosition(1120,260)
    .setSize(15,100)
    .setRange(0,30)
    .setValue(12)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider2")
    .setPosition(1160,260)
    .setSize(15,100)
    .setRange(95,106)
    .setValue(98.6)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider2")
    .setPosition(1205,260)
    .setSize(15,100)
    .setRange(0,10)
    .setValue(5)
    .setLabel("Pain")
    ;
   cp5.addCheckBox("Afflictions2")
    .setPosition(950, 400)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .setSpacingRow(20)
    .addItem("HR Irregular 2", 0)
    .addItem("Unconscious 2", 0)
    .addItem("Breathing Obstructed 2", 0);
    
    
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
  cp5.addSlider("BPSysSlider3")
    .setPosition(1000,510)
    .setSize(15,100)
    .setRange(0,220)
    .setValue(120)
    .setLabel("BPS")
    ;
  // Vertical Blood Pressure Slider
  cp5.addSlider("BPDiasSlider3")
    .setPosition(1040,510)
    .setSize(15,100)
    .setRange(0,160)
    .setValue(80)
    .setLabel("BPD")
    ;
  // Vertical Heart Rate Slider
  cp5.addSlider("HRSlider3")
    .setPosition(1080,510)
    .setSize(15,100)
    .setRange(0,220)
    .setValue(80)
    .setLabel("HR")
    ;
  // Vertical Respiratory Rate Slider
  cp5.addSlider("RRSlider3")
    .setPosition(1120,510)
    .setSize(15,100)
    .setRange(0,30)
    .setValue(12)
    .setLabel("RR")
    ;
  // Vertical Body Temp Slider
  cp5.addSlider("BTSlider3")
    .setPosition(1160,510)
    .setSize(15,100)
    .setRange(95,106)
    .setValue(98.6)
    .setLabel("BT")
    ;
  // Vertical Pain Level Slider
  cp5.addSlider("PainSlider3")
    .setPosition(1205,510)
    .setSize(15,100)
    .setRange(0,10)
    .setValue(5)
    .setLabel("Pain")
    ;
  cp5.addCheckBox("Afflictions3")
    .setPosition(950, 650)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setSize(10, 10)
    .setItemsPerRow(3)
    .setSpacingColumn(80)
    .setSpacingRow(20)
    .addItem("HR Irregular 3", 0)
    .addItem("Unconscious 3", 0)
    .addItem("Breathing Obstructed 3", 0);

  //ac.out.addInput();
  
  patient1 = new Patient(1, (int)BPSysGlide.getValue(), (int)BPDiasGlide.getValue(),(int)HRGlide.getValue(), (int)RRGlide.getValue(), BTGlide.getValue(), (int)PainGlide.getValue());
  patient2 = new Patient(2, (int)BPSysGlide2.getValue(), (int)BPDiasGlide2.getValue(),(int)HRGlide2.getValue(), (int)RRGlide2.getValue(), BTGlide2.getValue(), (int)PainGlide2.getValue());
  patient3 = new Patient(3, (int)BPSysGlide3.getValue(), (int)BPDiasGlide3.getValue(),(int)HRGlide3.getValue(), (int)RRGlide3.getValue(), BTGlide3.getValue(), (int)PainGlide3.getValue());
  
  Glide BPSysGlide, BPDiasGlide, HRGlide, RRGlide, BTGlide, PainGlide;
  Glide BPSysGlide2, BPDiasGlide2, HRGlide2, RRGlide2, BTGlide2, PainGlide2;
  Glide BPSysGlide3, BPDiasGlide3, HRGlide3, RRGlide3, BTGlide3, PainGlide3;
  
  bp1.pause(true);
  btcold.pause(true);
  bthot.pause(true);
  hr1.pause(true);
  pain1.pause(true);
  rr1.pause(true);
  feedback.pause(true);
  
  ac.out.addInput(bp1);
  ac.out.addInput(btcold);
  ac.out.addInput(bthot);
  ac.out.addInput(hr1);
  ac.out.addInput(pain1);
  ac.out.addInput(rr1);
  ac.out.addInput(feedback);
  
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

public void BTSlider1(float newGain) {
  BTGlide.setValue(newGain/100.0);
}

public void PainSlider1(int newGain) {
  PainGlide.setValue(newGain/100.0);
}
public void BPSysSlider2(int newGain) {
  BPSysGlide2.setValue(newGain/100.0);
}

public void BPDiasSlider2(int newGain) {
  BPDiasGlide2.setValue(newGain/100.0);
}

public void HRSlider2(int newGain) {
  HRGlide2.setValue(newGain/100.0);
}

public void RRSlider2(int newGain) {
  RRGlide2.setValue(newGain/100.0);
}

public void BTSlider2(float newGain) {
  BTGlide2.setValue(newGain/100.0);
}

public void PainSlider2(int newGain) {
  PainGlide2.setValue(newGain/100.0);
}
public void BPSysSlider3(int newGain) {
  BPSysGlide3.setValue(newGain/100.0);
}

public void BPDiasSlider3(int newGain) {
  BPDiasGlide3.setValue(newGain/100.0);
}

public void HRSlider3(int newGain) {
  HRGlide3.setValue(newGain/100.0);
}

public void RRSlider3(int newGain) {
  RRGlide3.setValue(newGain/100.0);
}

public void BTSlider3(float newGain) {
  BTGlide3.setValue(newGain/100.0);
}

public void PainSlider3(int newGain) {
  PainGlide3.setValue(newGain/100.0);
}
public void healthButton1() {
  patient1.setSystolicBloodPressure((int)BPSysGlide.getValue());
  patient1.setDiastolicBloodPressure((int)BPDiasGlide.getValue());
  patient1.setHeartRate((int)HRGlide.getValue());
  patient1.setRespiratoryRate((int)RRGlide.getValue());
  patient1.setBodyTemperature((int)BTGlide.getValue());
  patient1.setPainLevel((int)PainGlide.getValue());
}
public void healthButton2() {
  patient2.setSystolicBloodPressure((int)BPSysGlide2.getValue());
  patient2.setDiastolicBloodPressure((int)BPDiasGlide2.getValue());
  patient2.setHeartRate((int)HRGlide2.getValue());
  patient2.setRespiratoryRate((int)RRGlide2.getValue());
  patient2.setBodyTemperature((int)BTGlide2.getValue());
  patient2.setPainLevel((int)PainGlide2.getValue());
}
public void healthButton3() {
  patient3.setSystolicBloodPressure((int)BPSysGlide3.getValue());
  patient3.setDiastolicBloodPressure((int)BPDiasGlide3.getValue());
  patient3.setHeartRate((int)HRGlide3.getValue());
  patient3.setRespiratoryRate((int)RRGlide3.getValue());
  patient3.setBodyTemperature((int)BTGlide3.getValue());
  patient3.setPainLevel((int)PainGlide3.getValue());
}

public void addPatient() {
  if (patientCheckBox.getState(10) == true) {
    
  }
}
public void removePatient() {
}
public void patientFocus() {
}
public void patientCheckBox() {
}
public void vitalFocus() {
}
public void removeVitalFocus() {
}
public void vitalCheckBox() {
}
public void addNotes() {
}
public void sendNotes() {
}