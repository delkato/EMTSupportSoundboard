//enum VitalType{ BP,HR, RR,BT,PL} //Blood pressure, heart rate, respir rate, body temp, pain level
import java.util.Timer;
import java.util.TimerTask;

class Patient {
  int BPSys, BPDias, HRate, RRate, PLevel;  //Blood pressure, heart rate, respir rate, body temp, pain level
  float BTemp;
  int TargetBPSys, TargetBPDias, TargetHRate, TargetRRate, TargetPLevel;
  float TargetBTemp;
  int patientID;
  Sensor sensor;
  
  public Patient(int patientID, int BPS, int BPD, int HR, int RR, float BT, int PL, int ID){
    this.patientID = patientID;
    BPSys = BPS;
    BPDias = BPD;
    HRate = HR;
    RRate = RR;
    BTemp = BT;
    PLevel = PL;
    patientID = ID;
    //sensor = new Sensor(this);
  }
  public int getSystolicBloodPressure() { return BPSys; }
  public int getDiastolicBloodPressure() { return BPDias; }
  public int getHeartRate() { return HRate; }
  public int getRespiratoryRate() { return RRate; }
  public float getBodyTemperature() { return BTemp; }
  public int getPainLevel() { return PLevel; }
  public int getPatientID() { return patientID; }
  public Sensor getSensor() { return sensor; }
  
  
  public void setSystolicBloodPressure(int BPSys) { this.BPSys = BPSys; }
  public void setDiastolicBloodPressure(int BPDias) { this.BPDias = BPDias; }
  public void setHeartRate(int HRate) { this.HRate = HRate; }
  public void setRespiratoryRate(int RRate) { this.RRate = RRate; }
  public void setBodyTemperature(float BTemp) { this.BTemp = BTemp; }
  public void setPainLevel(int PLevel) { this.PLevel = PLevel; }
  public void setSensor(Sensor sensor) { this.sensor = sensor; }
  
  
  public float getHRFreq(){
    State modifier = getHRState();
      switch (modifier){
      case Critical:
        if(HRate>100){
          return 1.5 + ((float)HRate-180)/40;
        }
        else{
          return 0.7-(20-(float)HRate)/60;
        }
      case Moderate:
        if(HRate>100){
          return 1.2 + ((float)HRate-140)/40;
        }
        else{
          return 0.8 - (40- (float)HRate)/80;
        }
      case Normal:
        return 1.0;
    }
    return 1.0;
  }
  
  public float getRRFreq(){
    State modifier = getRRState();
    switch (modifier){
      case Critical:
        if(RRate>40){
          return 2.0 + ((float)RRate-60)/40;
        }
        else{
          return 0.2;
        }
      case Moderate:
        if(RRate>40){
          return 1.5 + ((float)RRate-40)/40;
        }
        else{
          return 0.5;
        }
      case Normal:
        return 1.0;
    }
    return 1.0;
  }
  public float getBTFreq(){
      State modifier = getBTState();
      switch (modifier){
        case Critical:
          if(BTemp>100){
            return 1.2 + ((float)BTemp-100)/10;
          }
          else{
            return 0.4;
          }
        case Moderate:
          if(BTemp>100){
            return 1.1 + ((float)BTemp-100)/10;
          }
          else{
            return 0.6;
          }
        case Normal:
          return 1.0;
      }
      return 1.0;
  }
  
  public float getPLFreq(){
      State modifier = getPLState();
      switch (modifier){
      case Critical:
          return 2.0;
      case Moderate:
          return 1.6;
      case Normal:
        return 1.0;
    }
    return 1.0;
  }
  public float getBPSFreq() {
      State modifier = getBPSState();
      switch (modifier){
      case Critical:
          return 2.0;
      case Moderate:
          return 1.6;
      case Normal:
        return 1.0;
    }
    return 1.0;
  }
  public float getBPDFreq() {
  State modifier = getBPDState();
      switch (modifier){
      case Critical:
          return 2.0;
      case Moderate:
          return 1.6;
      case Normal:
        return 1.0;
    }
    return 1.0;
  }
  
  
  //immediate update of values
  public void updateVital(VitalType vital, float input) {
    switch (vital){
      case BPS:
        BPSys = (int) input;
      case BPD:
        BPDias = (int) input;
      case HR:
        HRate = (int) input;
      case RR:
        RRate = (int) input;
      case BT:
        BTemp =  input;
      case PL:
        PLevel = (int) input;
      break;
    }
  }
  
  //update over time
  public void updateVitalOverTime(VitalType vital, float input) {
      switch (vital){
        case BPS:
          TargetBPSys = (int)input;
        case BPD:
          TargetBPDias = (int) input;
        case HR:
          TargetHRate = (int) input;
        case RR:
          TargetRRate = (int) input;
        case BT:
          TargetBTemp =  input;
        case PL:
          TargetPLevel = (int) input;
        break;
      }
      transitionVital(vital);
  }
  
  //recursive call to change vital 
  public void transitionVital(VitalType vital) {
    int difference;
    long timeLag = 30;
     Timer timer = new Timer();           
    switch (vital){
        case BPS:
          difference = (TargetBPSys - BPSys)/4 ;
          if(abs(difference) > 2){
            BPSys =  BPSys + difference;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            BPSys = TargetBPSys;
          }
        case BPD:
          difference = (TargetBPDias - BPDias)/4 ;
          if(abs(difference) > 2){
            BPDias =  BPDias + difference;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            BPDias = TargetBPDias;
          }
        case HR:
          difference = (TargetHRate - HRate)/4 ;
          if(abs(difference) > 2){
            HRate =  HRate + difference;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            HRate = TargetHRate;
          }
        case RR:
          difference = (TargetRRate - RRate)/4 ;
          if(abs(difference) > 2){
            RRate =  RRate + difference;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            RRate = TargetRRate;
          }
        case BT:
          float differenceF = (TargetBTemp - BTemp)/4 ;
          if(abs(differenceF) > 2){
            BTemp =  BTemp + differenceF;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            BTemp = TargetBTemp;
          }
        case PL:
          difference = (TargetPLevel - PLevel)/4 ;
          if(abs(difference) > 2){
            PLevel =  PLevel + difference;
            timer.schedule(new VitalTask(vital), timeLag);
          }
          else{
            PLevel = TargetPLevel;
          }
        break;
      }
  }
  
  public State getBPSState() { 
    if (BPSys > 140) {
      if(BPSys > 180) {
        return State.Critical; //hypertensive crisis
      }
      else{
        return State.Moderate;
      }
    }
    else{
      return State.Normal;
    } 
  }
  public State getBPDState() { 
     if (BPDias > 90) { 
          if(BPDias > 120) {
            return State.Critical; //hypertensive crisis
          }
          else{
            return State.Moderate; //stage 2 hypertension
              }
      }
      else{
        return State.Normal;
      } 
  }
  public State getHRState() { 
    if (HRate > 140) { 
          if(HRate > 180) {
            return State.Critical; //hypertensive crisis
          }
          else{
            return State.Moderate; //stage 2 hypertension
              }
      }
      else if(HRate < 40){
        if(HRate < 20) {
            return State.Critical; //hypertensive crisis
          }
        return State.Moderate;
      } 
      else{
        return State.Normal;
      } 
  }
  public State getRRState() {
    if (RRate > 40) { 
          if(RRate > 60) {
            return State.Critical; //hypertensive crisis
          }
          else{
            return State.Moderate; //stage 2 hypertension
              }
      }
      else if(RRate < 8){
        if(RRate < 4) {
            return State.Critical; //hypertensive crisis
          }
        return State.Moderate;
      } 
      else{
        return State.Normal;
      } 
  }
  public State getBTState() { 
  if (BTemp > 100) { 
          if(BTemp > 104) {
            return State.Critical; //hypertensive crisis
          }
          else{
            return State.Moderate; //stage 2 hypertension
              }
      }
      else if(BTemp < 95.5){
            return State.Critical; //hypertensive crisis
      } 
      else{
        return State.Normal;
      } 
  }
  public State getPLState() { 
      if (PLevel > 3){
        if(PLevel > 6){
          return State.Critical;
        }
        return State.Moderate;
      }
      else{
       return State.Normal;
      }
  }
  
  class VitalTask extends TimerTask {
    VitalType vitalT;
    public VitalTask(VitalType in) {
      super();
      vitalT = in;
    }
    public void run() {
      transitionVital(vitalT);
    }
  }
}