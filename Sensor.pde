// send notifications based on patient status
class Sensor {
  Timer timer;
  Patient patient;
  NotificationHandler nh;
  State BPSState, BPDState, HRState, RRState, BTState, PLState;
  
  public Sensor(Patient patient) {
    this.patient = patient;
    nh = new NotificationHandler();
    timer = new Timer();
    // timer set to update states every 10 seconds
    timer.schedule(new UpdatePatientStates(), 10000);
  }
  
  public void updatePatientStates() {
    BPSState = patient.getBPSState();
    BPDState = patient.getBPDState();
    HRState = patient.getHRState();
    RRState = patient.getRRState();
    BTState = patient.getBTState();
    PLState = patient.getPLState();
    notificationManager();
  }
  
  public void notificationManager() {
    if (BPSState == State.Critical) {
      createNotifications(VitalType.BPS, 3);
    } else if (BPSState ==  State.Moderate) {
      createNotifications(VitalType.BPD, 2);
    } else if (BPSState ==  State.Normal) {
      createNotifications(VitalType.BPD, 1);
    }
    if (BPDState ==  State.Critical) {
      createNotifications(VitalType.BPD, 3);
    } else if (BPDState ==  State.Moderate) {
      createNotifications(VitalType.BPD, 2);
    } else if (BPDState ==  State.Normal) {
      createNotifications(VitalType.BPD, 1);
    }
    if (HRState == State.Critical) {
      createNotifications(VitalType.HR, 3);
    } else if (HRState == State.Moderate) {
      createNotifications(VitalType.HR, 2);
    } else if (HRState == State.Normal) {
      createNotifications(VitalType.HR, 1);
    }
    if (RRState == State.Critical) {
      createNotifications(VitalType.RR, 3);
    } else if (RRState == State.Moderate) {
      createNotifications(VitalType.RR, 2);
    } else if (RRState == State.Normal) {
      createNotifications(VitalType.RR, 1);
    }
    if (BTState == State.Critical) {
      createNotifications(VitalType.BT, 3);
    } else if (BTState == State.Moderate) {
      createNotifications(VitalType.BT, 2);
    } else if (BTState == State.Normal) {
      createNotifications(VitalType.BT, 1);
    }
    if (PLState == State.Critical) {
      createNotifications(VitalType.PL, 3);
    } else if (PLState == State.Moderate) {
      createNotifications(VitalType.PL, 2);
    } else if (PLState == State.Normal) {
      createNotifications(VitalType.PL, 1);
    }
  }
  
  public void createNotifications(VitalType vital, int priority) {
    Notification notif = new Notification(NotificationType.StatusUpdate, patient, patient.getPatientID(), priority, false, "", vital, patient.getPainLevel());
    nh.notificationReceived(notif);
  }
  
  class UpdatePatientStates extends TimerTask {
    public UpdatePatientStates() { }
    public void run() {
      updatePatientStates();
    }
  }
}