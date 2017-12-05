enum NotificationType { StatusUpdate, CommandResponse, Alert, CriticalAlert, SystemMessage, DataStream }
enum Response { TurnOn }
enum VitalType{ BPS, BPD , HR, RR,BT,PL} //Blood pressure, heart rate, respir rate, body temp, pain level


//RR should have notice if breathing is impaired
//HR should have indication of irregular heartbeat/palpitations


class Notification {
   

  NotificationType type; 
  int patientID;
  int priority;
  boolean busyIgnore;
  String message;
  VitalType vital;
  
  
  public Notification(JSONObject json) {
    

    String typeString = json.getString("type");
    
    try {
      this.type = NotificationType.valueOf(typeString);
    }
    catch (IllegalArgumentException e) {
      throw new RuntimeException(typeString + " is not a valid value for enum NotificationType.");
    }
    
    
    if (json.isNull("message")) {
      this.message = "";
    }
    else {
      this.message = json.getString("message");
    }
    

    this.priority = json.getInt("priority");
    //1-4 levels (1 is lowest, 4 is highest)
    

                             
  }
  public Notification() {

  }
  public NotificationType getType() { return type; }
  public String getMessage() { return message; }
  public int getPriorityLevel() { return priority; }
  public boolean getBusyIgnore() { return busyIgnore; }
}

  
  //public String toString() {
  //    String output = getType().toString() + ": ";
  //    output += "(" + getSender() + ")";
  //    output += " " + getMessage();
  //    return output;
  //  }