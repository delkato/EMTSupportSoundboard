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
    boolean busy = false;
    boolean timed = false;
    HashMap<VitalType,Boolean> vitals = new HashMap<VitalType,Boolean>();
    HashMap<Integer,Boolean> patientList = new HashMap<Integer, Boolean>();
    Timer timer;
      
      public NotificationHandler() {
       super();

       notificationPriorityQueue = new PriorityQueue<Notification>(20,idComparator);
      }
    
    
    public void notificationReceived(Notification notification) { 

          notificationPriorityQueue.offer(notification);
          notificationHandle();
        
      }

    public void notificationHandle(){
    
          if(!busy && !timed){

            busy = true;
            Notification current = notificationPriorityQueue.poll();
            if(current!=null){
              //check for whether to play the notification due to focuses
              if(current.getType() == NotificationType.SystemResponse) {
                
              }
              else if(patientList.get(current.getPatientID())!=null) {
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
              };
              
              timed = true;
            }
            else{
              busy=false;
            }
          }
    
        
      }
      
      
      class HandlerTask extends TimerTask {;
        
        public HandlerTask() {
        }
          public void run() {
    
          busy=false;
          timed = false;
          notificationHandle();
        }
      }
      
      public double play(Notification notif){
        //define how to play the sounds based on notification, then return the time the clip will take
        
          switch (notif.getType()){
            if(notif.getType()== NotificationType.StatusUpdate){ //play update sounds based on current patient health
            }
           else if(notif.getType()== NotificationType.SystemResponse){//play system sounds like confirming a choice was made, or notes sent
           }
           else if(notif.getType()== NotificationType.Alert){//alert for when vitals go too far. get the notif.getVitalType(), then notif.getPatient().getState() to determine how critical, then present sound to emt
           }
            
          }
          return 0;
        }

}