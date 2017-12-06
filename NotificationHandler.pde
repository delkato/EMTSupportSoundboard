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
               queue.schedule( new HRSound(notif.getPatient().getHRFreq()), (long)amount);
               amount += hr1.getSample().getLength();
               queue.schedule( new RRSound(notif.getPatient().getRRFreq()), (long)amount);
               amount += hr1.getSample().getLength();
               queue.schedule( new BPDSound(notif.getPatient().getBPSFreq()), (long)amount);
               amount += bp1.getSample().getLength();
               queue.schedule( new BPDSound(notif.getPatient().getBPDFreq()), (long)amount);
               amount += hr1.getSample().getLength();
               queue.schedule( new HRSound(notif.getPatient().getBTFreq()), (long)amount);
               amount += bthot.getSample().getLength();
               queue.schedule( new HRSound(notif.getPatient().getPLFreq()), (long)amount);
               amount += pain1.getSample().getLength();
              return amount;
            }
            
           else if(notif.getType()== NotificationType.SystemResponse){//play system sounds like confirming a choice was made, or notes sent
             
             return ttsPlayback(notif.getMessage());
           }
           else if(notif.getType()== NotificationType.Alert){//alert for when vitals go too far. get the notif.getVitalType(), then notif.getPatient().getState() to determine how critical, then present sound to emt
              Timer queue = new Timer();
              double amount = 0;
             switch(notif.getVitalType()){
               case BPS:
                 queue.schedule( new BPDSound(notif.getPatient().getBPSFreq()), (long)amount);
                   amount += bp1.getSample().getLength();
                   return amount;
               case BPD:
                 queue.schedule( new BPDSound(notif.getPatient().getBPDFreq()), (long)amount);
                   amount += hr1.getSample().getLength();
                   return amount;
               case HR:
                
                   queue.schedule( new HRSound(notif.getPatient().getHRFreq()), (long)amount);
                   amount += hr1.getSample().getLength();
                   return amount;

               case RR:
                   queue.schedule( new RRSound(notif.getPatient().getRRFreq()), (long)amount);
                   amount += hr1.getSample().getLength();
                   return amount;
                 
               case BT:
                 queue.schedule( new HRSound(notif.getPatient().getBTFreq()), (long)amount);
                   amount += bthot.getSample().getLength();
                   return amount;
               case PL:
                 queue.schedule( new HRSound(notif.getPatient().getPLFreq()), (long)amount);
                   amount += pain1.getSample().getLength();
                   return amount;
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
    float freq;
    public BPDSound(float frequ) {
      freq = frequ;
  }
    public void run() {
      Glide pitchValue1;
        pitchValue1 = new Glide(ac, freq, 50);
        bp1.setPitch(pitchValue1);
        bp1.setToLoopStart();
        bp1.start();
    }
  }
  class HRSound extends TimerTask {

    float freq;
    public HRSound(float frequ) {
      freq = frequ;
  }
    public void run() {
        if(freq>.5){
          Glide pitchValue1;
          pitchValue1 = new Glide(ac, freq, 50);
          hr1.setPitch(pitchValue1);
          hr1.setToLoopStart();
          hr1.start();
        }
        else{
          Glide pitchValue1;
          pitchValue1 = new Glide(ac, freq, 50);
          hr1.setPitch(pitchValue1);
          hr1.setToLoopStart();
          hr1.start();
          Glide pitchValue2;
          pitchValue2 = new Glide(ac, 3+freq, 50);
          hr2.setPitch(pitchValue2);
          hr2.setToLoopStart();
          hr2.start();
        }
    }
  }
  class RRSound extends TimerTask {
        float freq;
    public RRSound(float frequ) {
      freq = frequ;
    }
    public void run() {
     Glide pitchValue1;
        pitchValue1 = new Glide(ac, freq, 50);
        rr1.setPitch(pitchValue1);
        rr1.setToLoopStart();
        rr1.start();
    }
  }
  
  class TempSound extends TimerTask {
    float freq;
    public TempSound(float frequ) {
      freq = frequ;
  }
    public void run() {
        bthot.setToLoopStart();
        bthot.start();
    }
  }
 
  class PLSound extends TimerTask {
    float freq;
    public PLSound(float frequ) {
      freq = frequ;
  }
    public void run() {
       Glide pitchValue1;
        pitchValue1 = new Glide(ac, freq, 50);
        hr1.setPitch(pitchValue1);
        hr1.setToLoopStart();
        hr1.start();
    }
  }
  
  
  
}