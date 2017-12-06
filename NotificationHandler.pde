import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;
import java.util.Set;
import controlP5.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Timer;
import java.util.TimerTask;

class NotificationHandler {
    PriorityQueue<Notification> notificationPriorityQueue;
    TextToSpeechMaker ttsMaker;
    SamplePlayer textToSpeech;
    boolean busy = false;
    boolean timed = false;
    HashMap<VitalType,Boolean> vitals = new HashMap<VitalType,Boolean>(); //focus vital
    HashMap<Integer,Boolean> patientList = new HashMap<Integer, Boolean>(); //added patients (NEED TO ADD A PATIENT FOCUS LIST + LOGIC)
    
    Timer timer;
      
      public NotificationHandler() {
       super();
      idComparator = new Comparator<Notification>(){
        @Override
        public int compare(Notification c1, Notification c2) {
          if(  c1.getPriorityLevel()>c2.getPriorityLevel()) {  return -1;  }
          else if (  c1.getPriorityLevel()<c2.getPriorityLevel()){  return 1; }
                else{  return 0;}  
      }
    };
    patientList.put(0,true);
       notificationPriorityQueue = new PriorityQueue<Notification>(100,idComparator);
       ttsMaker = new TextToSpeechMaker();
       
      }
    
    
    public void notificationReceived(Notification notification) { 
          notificationPriorityQueue.offer(notification);
          notificationHandle();
      }

    public void notificationHandle(){
          if(!busy && !timed){
            busy = true;
             println("notification grab");
             println(notificationPriorityQueue.size());
            Notification current = notificationPriorityQueue.poll();
            if(current!=null){
              println(current.getPatientID() + " and " + patientList.keySet());
              //check for whether to play the notification due to focuses
              if(current.getType() == NotificationType.SystemResponse) {
                        println("system statement");
                        timed = true;
                        double x = play(current);
                        timer = new Timer();
                        timer.schedule(new HandlerTask(), (long)x);   //x is the time to wait, given from play()
                        current = null;
              }
              else if(patientList.containsKey(current.getPatientID())) {
                  println("check for focus");
                  if((vitals.get(current.getVitalType())!=null)|| vitals.isEmpty()){
                        timed = true;
                        double x = play(current);
                        timer = new Timer();
                        timer.schedule(new HandlerTask(), (long)x);   //x is the time to wait, given from play()
                        current = null;
                  //play notification HERE
                  //attach an endlistener to call notification handle again

                  }
                  else if(current.getPriorityLevel() > 2) {
                  
                    //play here is critical priority
                    //attach an endlistener to call notification handle again
                        timed = true;
                        double x = play(current);
                        timer = new Timer();
                        timer.schedule(new HandlerTask(), (long)x);   //x is the time to wait, given from play()
                        current = null;
                  }
                  else{
                    current = null;
                    timer = new Timer();
                    timer.schedule(new HandlerTask(), 1);
                  }
              }
              else{
                  timer = new Timer();
                  timer.schedule(new HandlerTask(), 1);
                  current = null;

              }
            }
            else{
              busy=false;
            }
          }

      }
      
      
      class HandlerTask extends TimerTask {
        public HandlerTask() { }
        
        public void run() {
          busy=false;
          timed = false;
          notificationHandle();
        }
      }
      
      public double play(Notification notif){
        //define how to play the sounds based on notification, then return the time the clip will take
            if(notif.getType()== NotificationType.StatusUpdate){ //play update sounds based on current patient health
              Timer queue = new Timer();
              double amount = 0;
              switch(notif.getPatient().getHRState()){
                case Critical:queue.schedule( new HRSound(State.Critical), (long)amount);
                   amount += hr1.getSample().getLength();
                   break;
                case Moderate:queue.schedule( new HRSound(State.Moderate), (long)amount);
                   amount += hr1.getSample().getLength();
                   break;
                case Normal:
                   queue.schedule( new HRSound(State.Normal), (long)amount);
                   amount += hr1.getSample().getLength();
                   break;
              }
              switch(notif.getPatient().getRRState()){
                case Critical:queue.schedule( new RRSound(State.Critical), (long)amount);
                   amount += rr1.getSample().getLength();
                   break;
                case Moderate:queue.schedule( new RRSound(State.Moderate), (long)amount);
                   amount += rr1.getSample().getLength();
                   break;
                case Normal:
                   queue.schedule( new RRSound(State.Normal), (long)amount);
                   amount += rr1.getSample().getLength();
                   break;
              }
              switch(notif.getPatient().getBPSState()){
                case Critical:
                  queue.schedule( new BPDSound(State.Critical), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
                case Moderate:
                  queue.schedule( new BPDSound(State.Moderate), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
                case Normal:
                  queue.schedule( new BPDSound(State.Normal), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
              }
              switch(notif.getPatient().getBPDState()){
                case Critical:
                  queue.schedule( new BPDSound(State.Critical), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
                case Moderate:
                  queue.schedule( new BPDSound(State.Moderate), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
                case Normal:
                   queue.schedule( new BPDSound(State.Normal), (long)amount);
                   amount += bp1.getSample().getLength();
                   break;
              }

              switch(notif.getPatient().getBTState()){
                case Critical:
                    if (notif.getPatient().getBodyTemperature() < 95.5) {
                       queue.schedule( new ColdSound(State.Normal), (long)amount);
                       amount += btcold.getSample().getLength();
                     } else if (notif.getPatient().getBodyTemperature() > 100) {
                       queue.schedule( new HotSound(State.Normal), (long)amount);
                       amount += bthot.getSample().getLength();
                     }
                case Moderate:
                case Normal:
                       queue.schedule( new HotSound(State.Normal), (long)amount);
                       amount += bthot.getSample().getLength();
                     }
              
              switch(notif.getPatient().getPLState()){
                case Critical:
                queue.schedule( new PLSound(State.Critical), (long)amount);
                       amount += pain1.getSample().getLength();
                       break;
                case Moderate:
                  queue.schedule( new PLSound(State.Moderate), (long)amount);
                       amount += pain1.getSample().getLength();
                       break;
                case Normal:
                     queue.schedule( new PLSound(State.Normal), (long)amount);
                       amount += pain1.getSample().getLength();
                       break;
              }
              return amount;
            }
            
           else if(notif.getType()== NotificationType.SystemResponse){//play system sounds like confirming a choice was made, or notes sent
             
             return ttsPlayback(notif.getMessage());
           }
           else if(notif.getType()== NotificationType.Alert){//alert for when vitals go too far. get the notif.getVitalType(), then notif.getPatient().getState() to determine how critical, then present sound to emt
             switch(notif.getVitalType()){
               case BPS:
                 if (notif.getPatient().getBPSState() == State.Critical) {
                   bp1.setToLoopStart();
                   bp1.start();
                   return bp1.getSample().getLength();
                 }
               case BPD:
                 if (notif.getPatient().getBPDState() == State.Critical) {
                   bp1.setToLoopStart();
                   bp1.start();
                   return bp1.getSample().getLength();
                 }
               case HR:
                 if (notif.getPatient().getHRState() == State.Critical) {
                   hr1.setToLoopStart();
                   hr1.start();
                   return hr1.getSample().getLength();
                 }
               case RR:
                 if (notif.getPatient().getRRState() == State.Critical) {
                   rr1.setToLoopStart();
                   rr1.start();
                   return rr1.getSample().getLength();
                 }
               case BT:
                 if (notif.getPatient().getBTState() == State.Critical) {
                   if (notif.getPatient().getBodyTemperature() < 95.5) {
                     btcold.setToLoopStart();
                     btcold.start();
                     return btcold.getSample().getLength();
                   } else if (notif.getPatient().getBodyTemperature() > 100) {
                     bthot.setToLoopStart();
                     bthot.start();
                     return bthot.getSample().getLength();
                   } else {
                      btcold.setToLoopStart();
                     btcold.start();
                     return btcold.getSample().getLength();
                   }
                 }
               case PL:
                 if (notif.getPatient().getPLState() == State.Critical) {
                   pain1.setToLoopStart();
                   pain1.start();
                   return pain1.getSample().getLength();
                 }
             }
           }
            
          
          return 1;
        }
        
        public void addPatient(int input) {
          patientList.put(input,false);
          println("added " + input);
          println(patientList.keySet());
        }
        public void removePatient(int input) {
          patientList.remove(input);
          println("removed " + input);
          println(patientList.keySet());
        }
        public void addPatientFocus(int input) {
          patientList.put(input,true);
          println("added " + input);
          println(patientList.keySet());
        }

         public void addVital(VitalType input) {
          vitals.put(input,false);
          println("added " + input.name());
          println(vitals.keySet());
        }
        public void removeVital(VitalType input) {
          vitals.remove(input);
          println("removed " + input.name());
          println(vitals.keySet());
        }
        
  public double ttsPlayback(String inputSpeech) {
    String ttsFilePath = ttsMaker.createTTSWavFile(inputSpeech);
    textToSpeech = getSamplePlayer(ttsFilePath, false);
    ac.out.addInput(textToSpeech);
    textToSpeech.setToLoopStart();
    textToSpeech.start();
    return textToSpeech.getSample().getLength();
  }
  
  class BPDSound extends TimerTask {
    State state1;
    public BPDSound(State state) {state1 = state; }
    public void run() {
      Glide pitchValue1;
      switch(state1){
        case Critical: 
          pitchValue1 = new Glide(ac, 1.9, 50);
          bp1.setPitch(pitchValue1);
          break;
        case Moderate:  
          pitchValue1 = new Glide(ac, 1.5, 50);
          bp1.setPitch(pitchValue1);
          break;
        case Normal:  
          pitchValue1 = new Glide(ac, 1.0, 50);
          bp1.setPitch(pitchValue1);
          break;
      }
        bp1.setToLoopStart();
        bp1.start();
    }
  }
  class HRSound extends TimerTask {
    State state1;
    public HRSound(State state) {state1 = state; }
    public void run() {
       Glide pitchValue1;
      switch(state1){
        case Critical: 
          pitchValue1 = new Glide(ac, 1.9, 50);
          hr1.setPitch(pitchValue1);
          break;
        case Moderate:  
          pitchValue1 = new Glide(ac, 1.5, 50);
          hr1.setPitch(pitchValue1);
          break;
        case Normal:  
          pitchValue1 = new Glide(ac, 1.0, 50);
          hr1.setPitch(pitchValue1);
          break;
      }
        hr1.setToLoopStart();
        hr1.start();
    }
  }
  class RRSound extends TimerTask {
    State state1;
    public RRSound(State state) {state1 = state; }
    public void run() {
       Glide pitchValue1;
      switch(state1){
        case Critical: 
          pitchValue1 = new Glide(ac, 1.9, 50);
          rr1.setPitch(pitchValue1);
          break;
        case Moderate:  
          pitchValue1 = new Glide(ac, 1.5, 50);
          rr1.setPitch(pitchValue1);
          break;
        case Normal:  
          pitchValue1 = new Glide(ac, 1.0, 50);
          rr1.setPitch(pitchValue1);
          break;
      }
        rr1.setToLoopStart();
        rr1.start();
    }
  }
  class HotSound extends TimerTask {
    State state1;
    public HotSound(State state) {state1 = state; }
    public void run() {
        bthot.setToLoopStart();
        bthot.start();
    }
  }
  class ColdSound extends TimerTask {
    State state1;
    public ColdSound(State state) {state1 = state; }
    public void run() {
        btcold.setToLoopStart();
        btcold.start();
    }
  }
  class PLSound extends TimerTask {
    State state1;
    public PLSound(State state) { state1 = state;}
    public void run() {
       Glide pitchValue1;
      switch(state1){
        case Critical: 
          pitchValue1 = new Glide(ac, 1.9, 50);
          pain1.setPitch(pitchValue1);
          break;
        case Moderate:  
          pitchValue1 = new Glide(ac, 1.5, 50);
          pain1.setPitch(pitchValue1);
          break;
        case Normal:  
          pitchValue1 = new Glide(ac, 1.0, 50);
          pain1.setPitch(pitchValue1);
          break;
      }
        pain1.setToLoopStart();
        pain1.start();
    }
  }
  
  
  
}