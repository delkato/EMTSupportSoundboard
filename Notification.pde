enum NotificationType { StatusUpdate, SystemResponse, Alert}
enum Response { TurnOn }
enum VitalType{ BPS, BPD , HR, RR,BT,PL} //Blood pressure, heart rate, respir rate, body temp, pain level
enum State {Normal, Moderate, Critical}
enum Level {High,Low}

//RR should have notice if breathing is impaired
//HR should have indication of irregular heartbeat/palpitations


class Notification {
  NotificationType type = null; 
  Patient patient = null;
  int patientID = 0;
  int priority = 0; //0 to 3
  boolean busyIgnore = false;
  String message = null;
  VitalType vital =null;
  int intensity = 0; //0 to 10 if distortion needed
  
  public Notification() { }
  
  public Notification(NotificationType type, Patient patient, int patientID, int priority, boolean busyIgnore, String message, VitalType vital, int intensity) {
    this.type = type;
    this.patient = patient;
    this.patientID = patientID;
    this.priority = priority;
    this.busyIgnore = busyIgnore;
    this.message = message;
    this.vital = vital;
    this.intensity = intensity;
    println("created notification for patient "+ patientID  + " of priority " + priority + " of Type " + vital.name() );
  }
   public Notification(NotificationType type, int patientID, int priority, String message) {
    this.type = type;
    this.patientID = patientID;
    this.priority = priority;
    this.message = message;
    println("created notification for patient "+ patientID  + " of priority " + priority);
  }
  public NotificationType getType() { return type; }
  public String getMessage() { return message; }
  public int getPriorityLevel() { return priority; }
  public boolean getBusyIgnore() { return busyIgnore; }
  public int getPatientID() { return patientID; }
  public Patient getPatient() { return patient; }
  public VitalType getVitalType() { return vital; }
}

  
  //public String toString() {
  //    String output = getType().toString() + ": ";
  //    output += "(" + getSender() + ")";
  //    output += " " + getMessage();
  //    return output;
  //  }