package models.events {

  import flash.events.Event;

  public class TrackEvent extends Event {

    public static const PLAY_TRACK:String = "PLAY_TRACK";
    public static const START_DRAG:String = "START_DRAG";
    public static const NEXT_TRACK:String = "NEXT_TRACK";

    private var _path:String;

    public function TrackEvent(type:String, path:String, bubbles:Boolean = false, cancelable:Boolean = false) {

      super(type, bubbles, cancelable);

      _path = path;

    }

    public function get path():String {
      return _path;
    }
  }
}