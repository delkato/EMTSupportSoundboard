enum NotificationType { StatusUpdate, CommandResponse, Alert, CriticalAlert, SystemMessage, DataStream }
enum Response { TurnOn }
enum VitalType{ BP,HR, RR, BT, PL} //Blood pressure, heart rate, respir rate, body temp, pain level


//RR should have notice if breathing is impaired
//HR should have indication of irregular heartbeat/palpitations


class Notification {
  TextToSpeechMaker ttsMaker;
  SamplePlayer textToSpeech;
  int patientID;
  int priority; // 3 priority levels, 3 being highest
  boolean busyIgnore;
  VitalType vital;
  
  public Notification() { }
  
  public Notification(int patientID, boolean busyIgnore, VitalType vital) {
    this.ttsMaker = new TextToSpeechMaker();
    this.patientID = patientID;
    this.busyIgnore = busyIgnore;
    this.priority = 3;
    this.vital = vital;
  }
  
  public Notification(int patientID, boolean busyIgnore, int priority, VitalType vital) {
    this.ttsMaker = new TextToSpeechMaker();
    this.patientID = patientID;
    this.busyIgnore = busyIgnore;
    this.priority = priority;
    this.vital = vital;
  }
  
  public int getPatientID() { return patientID; }
  public int getPriorityLevel() { return priority; }
  public boolean getBusyIgnore() { return busyIgnore; }
  public VitalType getVitalType() { return vital; }
  
  public void outputNotification() {
    // highest priority
    if (priority == 3) {
      // make it loudest volume
      
    } else if (priority == 2) {
      // make it normal volume
    } else if (priority == 1) {
      // make it low volume
    } else {
      System.out.println("ERROR: Invalid priority level " + priority);
    }
    if (vital == VitalType.BP) {
      bp1.setToLoopStart();
      bp1.start();
    } else if (vital == VitalType.HR) {
      hr1.setToLoopStart();
      hr1.start();
    } else if (vital == VitalType.RR) {
      rr1.setToLoopStart();
      rr1.start();
    } else if (vital == VitalType.BT) {
      // need way to check if hot or cold
      bthot.setToLoopStart();
      bthot.start();
    } else if (vital == VitalType.PL) {
      pain1.setToLoopStart();
      pain1.start();
    } else {
      ttsPlayback("Patient " + patientID + " unconscious");
    }
  }
  
  public void ttsPlayback(String inputSpeech) {
    delay(1000);
    String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
    textToSpeech = getSamplePlayer(ttsFilePath, false);
    ac.out.addInput(textToSpeech);
    textToSpeech.setToLoopStart();
    textToSpeech.start();
    int wait = (int) textToSpeech.getSample().getLength() + 1000;
    delay(wait);
  }
}
  
  //public String toString() {
  //    String output = getType().toString() + ": ";
  //    output += "(" + getSender() + ")";
  //    output += " " + getMessage();
  //    return output;
  //  }