import guru.ttslib.*;

import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Timer;
import java.util.TimerTask;
BiquadFilter biFilter;

//declare global variables at the top of your sketch
//AudioContext ac; is declared in helper_functions
SamplePlayer bp1, btcold, bthot, hr1,hr2, pain1, rr1, feedback, START, ping, confirm;
ControlP5 cp5;
Patient patient1,patient2,patient3;
Gain g, g2;// master gain
Glide glide;

boolean[] detected;
int BPSysValue, BPDiasValue, HRValue, RRValue,  PainValue;
int BPSysValue2, BPDiasValue2, HRValue2, RRValue2,  PainValue2;
int BPSysValue3, BPDiasValue3, HRValue3, RRValue3,  PainValue3;
float BTValue, BTValue2,BTValue3;
CheckBox patientCheckBox,vitalCheckBox;
public static Comparator<Notification> idComparator;
NotificationHandler Handler;
CheckBox patientBox, vitalBox, detectedBox1,detectedBox2,detectedBox3 ;
Sensor sensor1,sensor2,sensor3;
//end global variables

//runs once when the Play button above is pressed
void setup() {
  size(1280, 720); //size(width, height) must be the first line in setup()
  ac = new AudioContext(); //AudioContext ac; is declared in helper_functions
  cp5 = new ControlP5(this);
  Handler = new NotificationHandler();
    g = new Gain(ac, 2, 0.5);
    g2 = new Gain(ac, 1, 0.1);
  biFilter = new BiquadFilter(ac,BiquadFilter.Type.LP,20000.0,0.8);

 
  detected = new boolean[3];
  detected[0] = false;
  detected[1] =false;
  detected[2] = false;
  ping = getSamplePlayer("dun1.mp3");
  START = getSamplePlayer("start.wav");
  bp1 = getSamplePlayer("feedback.wav");
  btcold = getSamplePlayer("temp.wav");
  bthot = getSamplePlayer("temp.wav");
  hr1 = getSamplePlayer("hr1.wav");
  hr2 = getSamplePlayer("hr1.wav");
  pain1 = getSamplePlayer("painWave.wav");
  rr1 = getSamplePlayer("rr1.wav");
  feedback = getSamplePlayer("feedback.wav");
  confirm = getSamplePlayer("verify.wav");

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
     
  cp5.addButton("listPatients")
   .setPosition(100,520)
   .setSize(100,30)
   .setLabel("List Patients");
   
  cp5.addButton("vitalFocus")
   .setPosition(100,220)
   .setSize(100,30)
   .setLabel("Focus Vital");
  cp5.addButton("removeVitalFocus")
   .setPosition(100,260)
   .setSize(100,30)
   .setLabel("Remove Vital Focus");
  
  vitalCheckBox = cp5.addCheckBox("vitalCheckBox")
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
  
  cp5.addButton("summary")
   .setPosition(100,300)
   .setSize(100,30)
   .setLabel("summary");
   
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
  detectedBox1 = cp5.addCheckBox("detectedCheckBox1")
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
    .setRange(0,70)
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
    .setValue(0)
    .setLabel("Pain")
    ;
   //cp5.addCheckBox("Afflictions1")
   // .setPosition(950, 150)
   // .setColorForeground(color(120))
   // .setColorActive(color(255))
   // .setColorLabel(color(255))
   // .setSize(10, 10)
   // .setItemsPerRow(3)
   // .setSpacingColumn(80)
   // .setSpacingRow(20)
   // .addItem("HR Irregular 1", 0)
   // .addItem("Unconscious 1", 0)
   // .addItem("Breathing Obstructed 1", 0);
    
    
    
    //PATIENT 2
  cp5.addTextlabel("label2")
      .setText("Patient 2")
      .setPosition(800,270)
      .setColorValue(0xffffff00)
      .setFont(createFont("Georgia",20))
      ;
  //Detected checkbox
  detectedBox2= cp5.addCheckBox("detectedCheckBox2")
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
    .setRange(0,70)
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
    .setValue(0)
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
  detectedBox3=cp5.addCheckBox("detectedCheckBox3")
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
    .setRange(0,70)
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
    .setValue(0)
    .setLabel("Pain")
    ;


  patient1 = new Patient(1, (int)BPSysValue, (int)BPDiasValue,(int)HRValue, (int)RRValue, BTValue, (int)PainValue,0);
  patient2 = new Patient(2, (int)BPSysValue2, (int)BPDiasValue2,(int)HRValue2, (int)RRValue2, BTValue2, (int)PainValue2,1);
  patient3 = new Patient(3, (int)BPSysValue3, (int)BPDiasValue,(int)HRValue, (int)RRValue3, BTValue3, (int)PainValue3,2);
  sensor1 = new Sensor(patient1);
  sensor2 = new Sensor(patient2);
  sensor3 = new Sensor(patient3);
  patient1.setSensor(sensor1);
  patient2.setSensor(sensor2);
  patient3.setSensor(sensor3);
  
  confirm.pause(true);
  ping.pause(true);
  bp1.pause(true);
  btcold.pause(true);
  bthot.pause(true);
  hr1.pause(true);
  hr2.pause(true);
  pain1.pause(true);
  rr1.pause(true);
  feedback.pause(true);
  g2.addInput(ping);
  g2.addInput(START);
  g2.addInput(confirm);
  biFilter.addInput(bp1);
  biFilter.addInput(btcold);
  biFilter.addInput(bthot);
  biFilter.addInput(hr1);
  biFilter.addInput(hr2);
  biFilter.addInput(pain1);
  biFilter.addInput(rr1);
  biFilter.addInput(feedback);
  g.addInput(biFilter);
  ac.out.addInput(g);
  ac.out.addInput(g2);
  ac.start();
}

void draw() {
  background(0);  //fills the canvas with black (0) each frame
}


public void detectedCheckBox1(){
  println("checkbox");
  if(detectedBox1.getArrayValue()[0] == 1) {
    if(!detected[0]){
      ping.setToLoopStart();
        ping.start(); 
        detected[0] = true;
    }
  }
  else{
    detected[0] =false;
  }
}
public void detectedCheckBox2(){
  if(detectedBox2.getArrayValue()[0] == 1) {
    if(!detected[1]){
      ping.setToLoopStart();
        ping.start();  
        detected[1] = true;
    }
  }
  else{
    detected[1] =false;
  }
}
public void detectedCheckBox3(){
  if(detectedBox3.getArrayValue()[0] == 1) {
    if(!detected[2]){
        ping.setToLoopStart();
        ping.start();  
        detected[2] = true;
    }
  }
  else{
    detected[2] =false;
  }
}


public void BPSysSlider1(int newGain) {
  BPSysValue=(int) newGain;
}

public void BPDiasSlider1(int newGain) {
  BPDiasValue=(int) newGain;
}

public void HRSlider1(int newGain) {
  HRValue=(int) newGain;
}

public void RRSlider1(int newGain) {
  RRValue = (int) newGain;
}

public void BTSlider1(float newGain) {
  BTValue =newGain;
}

public void PainSlider1(int newGain) {
  PainValue=(int) newGain;
}
public void BPSysSlider2(int newGain) {
  BPSysValue2=(int) newGain;
}

public void BPDiasSlider2(int newGain) {
  BPDiasValue2=(int) newGain;
}

public void HRSlider2(int newGain) {
  HRValue2=(int) newGain;
}

public void RRSlider2(int newGain) {
  RRValue2 = (int) newGain;
}

public void BTSlider2(float newGain) {
  BTValue2 =newGain;
}

public void PainSlider2(int newGain) {
  PainValue2=(int) newGain;
}
public void BPSysSlider3(int newGain) {
  BPSysValue3=(int) newGain;
}

public void BPDiasSlider3(int newGain) {
  BPDiasValue3=(int) newGain;
}

public void HRSlider3(int newGain) {
  HRValue3=(int) newGain;
}

public void RRSlider3(int newGain) {
  RRValue3 = (int) newGain;
}

public void BTSlider3(float newGain) {
  BTValue3 =newGain;
}

public void PainSlider3(int newGain) {
  PainValue3=(int) newGain;
}
public void HealthButton1() {
  patient1.setSystolicBloodPressure((int)BPSysValue);
  patient1.setDiastolicBloodPressure((int)BPDiasValue);
  patient1.setHeartRate((int)HRValue);
  patient1.setRespiratoryRate((int)RRValue);
  patient1.setBodyTemperature(BTValue);
  patient1.setPainLevel((int)PainValue);

    if(detectedBox1.getArrayValue()[0] == 1) {
    if(!detected[0]){
      ping.setToLoopStart();
        ping.start(); 
        detected[0] = true;
    }
  }
  else{
    detected[0] =false;
  }
}

public void HealthButton2() {
  patient2.setSystolicBloodPressure((int)BPSysValue2);
  patient2.setDiastolicBloodPressure((int)BPDiasValue2);
  patient2.setHeartRate((int)HRValue2);
  patient2.setRespiratoryRate((int)RRValue2);
  patient2.setBodyTemperature(BTValue2);
  patient2.setPainLevel((int)PainValue2);

  if(detectedBox2.getArrayValue()[0] == 1) {
    if(!detected[1]){
      ping.setToLoopStart();
        ping.start();  
        detected[1] = true;
    }
  }
  else{
    detected[1] =false;
  }
}

public void HealthButton3() {
  patient3.setSystolicBloodPressure((int)BPSysValue3);
  patient3.setDiastolicBloodPressure((int)BPDiasValue3);
  patient3.setHeartRate((int)HRValue3);
  patient3.setRespiratoryRate((int)RRValue3);
  patient3.setBodyTemperature(BTValue3);
  patient3.setPainLevel((int)PainValue3);
  
  if(detectedBox3.getArrayValue()[0] == 1) {
    if(!detected[2]){
        ping.setToLoopStart();
        ping.start();  
        detected[2] = true;
    }
  }
  else{
    detected[2] =false;
  }
}

public void addPatient() {
  boolean play =false;
  for(int i = 0; i < 3; i++){
    if(patientCheckBox.getArrayValue()[i] == 1) {
      Handler.addPatient(i+1);
      play = true;
    }
  } 
  if(play) {
        confirm.setToLoopStart();
        Glide pitchValue1;
        pitchValue1 = new Glide(ac, 1.1, 50);
        confirm.setPitch(pitchValue1);
        confirm.start(); 
  }
}
public void removePatient() {
  boolean play =false;
  for(int i = 0; i < 3; i++){
    if(patientCheckBox.getArrayValue()[i] == 1) {
      Handler.removePatient(i+1);
      play = true;
    }
  } 
    if(play) {
      confirm.setToLoopStart();
       Glide pitchValue1;
        pitchValue1 = new Glide(ac, 0.9, 50);
        confirm.setPitch(pitchValue1);
        confirm.start();  
    }
}
public void patientFocus() {
  boolean play =false;
  for(int i = 0; i < 3; i++){
    if(patientCheckBox.getArrayValue()[i] == 1) {
      Handler.addPatient(i+1);
      play = true;
    }
  }
  if(play) {
      confirm.setToLoopStart();
       Glide pitchValue1;
        pitchValue1 = new Glide(ac, 1.0, 50);
        confirm.setPitch(pitchValue1);
        confirm.start();  
    }
}
public void patientCheckBox() {
}
public void vitalFocus() {
  boolean play =false;
  for(int i = 0; i < 5; i++){
    if(vitalCheckBox.getArrayValue()[i] == 1) {
      play = true;
      switch(i){
        case 0: Handler.addVital(VitalType.BPD);
                Handler.addVital(VitalType.BPS);
                break;
        case 1: Handler.addVital(VitalType.HR);
        break;
        case 2:Handler.addVital(VitalType.RR);
        break;
        case 3:Handler.addVital(VitalType.BT);
        break;
        case 4:Handler.addVital(VitalType.PL);
        break;
      }
    }
  }
  if(play) {
      confirm.setToLoopStart();
       Glide pitchValue1;
        pitchValue1 = new Glide(ac, 1.1, 50);
        confirm.setPitch(pitchValue1);
        confirm.start();  
    }
}
public void removeVitalFocus() {
  boolean play =false;
  for(int i = 0; i < 5; i++){
    if(vitalCheckBox.getArrayValue()[i] == 1) {
      play= true;
      switch(i){
        case 0: Handler.removeVital(VitalType.BPD);
                Handler.removeVital(VitalType.BPS);
                break;
        case 1: Handler.removeVital(VitalType.HR);
        break;
        case 2:Handler.removeVital(VitalType.RR);
        break;
        case 3:Handler.removeVital(VitalType.BT);
        break;
        case 4:Handler.removeVital(VitalType.PL);
        break;
      }
    }
  }
  if(play) {
      confirm.setToLoopStart();
       Glide pitchValue1;
        pitchValue1 = new Glide(ac, 0.9, 50);
        confirm.setPitch(pitchValue1);
        confirm.start();  
    }
}
public void listPatients(){
  String out = "Patients " + Handler.patientsFound();
  Notification notifi = new Notification(NotificationType.SystemResponse,  00, 5,out);
  Handler.notificationReceived(notifi);
}

public void vitalCheckBox() {
}
public void addNotes() {
  Handler.ttsPlayback("Report Created");
}
public void sendNotes() {
  Handler.ttsPlayback("Report Sent");
}
public void summary() {
  Notification notifi1 = new Notification(NotificationType.StatusUpdate,  patient1, patient1.getPatientID(), 1, false, "", VitalType.RR, patient1.getPainLevel());
  Handler.notificationReceived(notifi1);
  Notification notifi2 = new Notification(NotificationType.StatusUpdate,  patient2, patient2.getPatientID(), 1, false, "", VitalType.RR, patient2.getPainLevel());
  Handler.notificationReceived(notifi2);
  Notification notifi3 = new Notification(NotificationType.StatusUpdate,  patient3, patient3.getPatientID(), 1, false, "", VitalType.RR, patient3.getPainLevel());
  Handler.notificationReceived(notifi3);
}
  