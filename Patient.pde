//enum VitalType{ BP,HR, RR,BT,PL} //Blood pressure, heart rate, respir rate, body temp, pain level
import java.util.Timer;
import java.util.TimerTask;

class Patient {
  int BPSys, BPDias, HRate, RRate, PLevel;  //Blood pressure, heart rate, respir rate, body temp, pain level
  float BTemp;
  int TargetBPSys, TargetBPDias, TargetHRate, TargetRRate, TargetPLevel;
  float TargetBTemp;
  public Patient(int BPS, int BPD, int HR, int RR, float BT, int PL){
    BPSys = BPS;
    BPDias = BPD;
    HRate = HR;
    RRate = RR;
    BTemp = BT;
    PLevel = PL;
  }
  public int getSystolicBloodPressure() { return BPSys; }
  public int getDiastolicBloodPressure() { return BPDias; }
  public int getHeartRate() { return HRate; }
  public int getRespiratoryRate() { return RRate; }
  public float getBodyTemperature() { return BTemp; }
  public int getPainLevel() { return BPSys; }
  
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