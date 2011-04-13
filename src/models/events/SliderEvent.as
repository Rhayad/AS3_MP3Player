package models.events {

  import flash.events.Event;

  public class SliderEvent extends Event {

    public static const CHANGE:String = "SliderEvent.CHANGE";
    public static const CHANGED:String = "SliderEvent.CHANGED";
    public static const START_CHANGE:String = "SliderEvent.START_CHANGE";

    private var _value:Number;

    public function SliderEvent(type:String, value:Number) {
      super(type, true, true);

      _value = value;
    }

    public function get value():Number {
      return _value;
    }

  }

}
