enum Status { Healthy, HRIrregular, Unconscious, BreathingObstructed }

// send notifications based on patient status
class Sensor {
  Status status;
  int patientID;
  
  public Sensor(int patientID) {
    this.status = Status.Healthy;
    this.patientID = patientID;
  }
  
  public Sensor(int patientID, Status status) {
    this.status = status;
    this.patientID = patientID;
  }
  
  public void getSensorNotifications() {
    if (status == Status.HRIrregular) {
      // heart beating too fast at rest (above 100 bpm, Tachycardia)
      // change glider to match status
      HRGlide.setValue(120);
      new Notification(patientID, false, VitalType.HR).outputNotification();
    } else if (status == Status.Unconscious) {
      new Notification(patientID, false, null).outputNotification();
      //ttsPlayback("Patient " + patientID + " unconscious");
    } else if (status == Status.BreathingObstructed) {
      // patient cannot breathe so respiratory rate increases to compensate
      // change glider to match status
      RRGlide.setValue(30);
      new Notification(patientID, false, VitalType.RR).outputNotification();
    }
  }
}