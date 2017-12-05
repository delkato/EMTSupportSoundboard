enum Status { Healthy, HRIrregular, Unconscious, BreathingObstructed }

// send notifications based on patient status
class Sensor {
  TextToSpeechMaker ttsMaker;
  SamplePlayer textToSpeech;
  Status status;
  int patientID;
  
  public Sensor(int patientID) {
    ttsMaker = new TextToSpeechMaker();
    this.status = Status.Healthy;
    this.patientID = patientID;
  }
  
  public Sensor(int patientID, Status status) {
    ttsMaker = new TextToSpeechMaker();
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
      ttsPlayback("Patient " + patientID + " unconscious");
    } else if (status == Status.BreathingObstructed) {
      // patient cannot breathe so respiratory rate increases to compensate
      // change glider to match status
      RRGlide.setValue(30);
      new Notification(patientID, false, VitalType.RR).outputNotification();
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