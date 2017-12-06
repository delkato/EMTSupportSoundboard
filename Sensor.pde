// send notifications based on patient status
class Sensor {
  Timer timer;
  Patient patient;
  State BPSState, BPDState, HRState, RRState, BTState, PLState;
  boolean busy =false;
  public Sensor(Patient patient) {
    this.patient = patient;
    //nh = new NotificationHandler();
    timer = new Timer();
    // timer set to update states every 10 seconds
    timer.scheduleAtFixedRate(new UpdatePatientStates(), 3000,5000);
    
  }
  
  public void updatePatientStates() {
    BPSState = patient.getBPSState();
    BPDState = patient.getBPDState();
    HRState = patient.getHRState();
    RRState = patient.getRRState();
    BTState = patient.getBTState();
    PLState = patient.getPLState();
    //timer.schedule(new UpdatePatientStates(), 5000);
      notificationManager();
    
  }
  
  public void notificationManager() {
    //println("looking to making notifications " + patient.getPatientID());
    HashMap<VitalType,Integer> set = new HashMap<VitalType,Integer>();
    if (BPSState == State.Critical) {
      //createNotifications(VitalType.BPS, 3);
      set.put(VitalType.BPS, 3);
    } else if (BPSState ==  State.Moderate) {
      //createNotifications(VitalType.BPS, 2);
      set.put(VitalType.BPS, 2);
    } else if (BPSState ==  State.Normal) {
      //createNotifications(VitalType.BPS, 1);
    }
    if (BPDState ==  State.Critical) {
      //createNotifications(VitalType.BPD, 3);
      set.put(VitalType.BPD, 3);
    } else if (BPDState ==  State.Moderate) {
      //createNotifications(VitalType.BPD, 2);
      set.put(VitalType.BPD, 2);
    } else if (BPDState ==  State.Normal) {
      //createNotifications(VitalType.BPD, 1);
    }
    if (HRState == State.Critical) {
      //createNotifications(VitalType.HR, 3);
      set.put(VitalType.HR, 3);
    } else if (HRState == State.Moderate) {
      //createNotifications(VitalType.HR, 2);
      set.put(VitalType.HR, 2);
    } else if (HRState == State.Normal) {
      //createNotifications(VitalType.HR, 1);
    }
    if (RRState == State.Critical) {
      //createNotifications(VitalType.RR, 3);
      set.put(VitalType.RR, 3);
    } else if (RRState == State.Moderate) {
      //createNotifications(VitalType.RR, 2);
      set.put(VitalType.RR, 2);
    } else if (RRState == State.Normal) {
      //createNotifications(VitalType.RR, 1);
    }
    if (BTState == State.Critical) {
     // createNotifications(VitalType.BT, 3);
      set.put(VitalType.BT, 3);
    } else if (BTState == State.Moderate) {
     // createNotifications(VitalType.BT, 2);
      set.put(VitalType.BT, 2);
    } else if (BTState == State.Normal) {
      //createNotifications(VitalType.BT, 1);
    }
    if (PLState == State.Critical) {
      //createNotifications(VitalType.PL, 3);
      set.put(VitalType.PL, 3);
    } else if (PLState == State.Moderate) {
      //createNotifications(VitalType.PL, 2);
      set.put(VitalType.PL, 2);
    } else if (PLState == State.Normal) {
      //createNotifications(VitalType.PL, 1);
    }
    if(set.size() < 3) {
      for(Map.Entry m:set.entrySet()){  
           createNotifications((VitalType)m.getKey(), (int)m.getValue());  
        } 
    }
    else {
       createNotificationGroup(set.size(), 3);
      
    
    }
  }
  
  public void createNotifications(VitalType vital, int priority) {
    Notification notif = new Notification(NotificationType.Alert, patient, patient.getPatientID(), priority, false, "", vital, patient.getPainLevel());
    Handler.notificationReceived(notif);
  }
  public void createNotificationGroup(int numberOfProblems, int priority) {
    String out = "patient ";
    out.concat(Integer.toString(patient.getPatientID()));
    out.concat(" has ");
    out.concat(Integer.toString(numberOfProblems));
    out.concat(" of 7 problems");
    Notification notifp = new Notification(NotificationType.SystemResponse, patient.getPatientID(), priority,"Patient "+Integer.toString(patient.getPatientID())+" is "+Integer.toString(numberOfProblems)+ " of 7");
    Handler.notificationReceived(notifp);
  }
  
  class UpdatePatientStates extends TimerTask {
    public UpdatePatientStates() { }
    public void run() {
      updatePatientStates();

    }
  }
}