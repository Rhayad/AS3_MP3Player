package models.events {

  import flash.events.Event;

  public class ButtonEvent extends Event {

    public static const START_DRAG:String = "START_DRAG";
    public static const STOP_DRAG:String = "STOP_DRAG";

    public function ButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
      super(type, bubbles, cancelable);
    }
  }
}