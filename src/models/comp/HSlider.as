package models.comp {

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;

  import models.events.SliderEvent;

  public class HSlider extends SliderGraphic {

    private var _min:Number = 0;
    private var _max:Number = 1;
    private var _value:Number = 0;

    public function HSlider() {

      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

      thumb.x = 0;
      thumb.buttonMode = true;
      thumb.tabEnabled = false;
    }

    private function onAddedToStage(event:Event):void {
      thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
    }

    private function onRemovedFromStage(event:Event):void {
      thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
    }

    private function onThumbMouseDown(event:MouseEvent):void {
      thumb.startDrag(false, new Rectangle(0, 0, background.width - thumb.width, 0));
      stage.addEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
      stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      dispatchEvent(new SliderEvent(SliderEvent.START_CHANGE, value));
    }

    private function onThumbMouseUp(event:MouseEvent):void {
      stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
      thumb.stopDrag();

      dispatchEvent(new SliderEvent(SliderEvent.CHANGED, value));
    }

    private function onMouseMove(event:MouseEvent):void {
      var thumbPercent:Number = thumb.x / (background.width - thumb.width);
      value = min + (thumbPercent * Math.abs(max - min));
    }

    protected function setThumbPosition():void {
      thumb.x = (background.width - thumb.width) * ((Math.abs(min) + value) / Math.abs(max - min));
    }

    /* ---- GETTER & SETTER ---- */
    public function get min():Number {
      return _min
    }

    public function set min(value:Number):void {
      if (value == _min)
        return;
      if (value > max)
        value = max;

      _min = value;
      setThumbPosition();
    }

    public function get max():Number {
      return _max;
    }

    public function set max(value:Number):void {
      if (value == _max)
        return;
      if (value < min)
        value = min;

      _max = value;
      setThumbPosition();
    }

    public function get value():Number {
      return _value;
    }

    public function set value(value:Number):void {
      if (value == _value)
        return;

      if (value < min)
        value = min;
      else if (value > max)
        value = max;

      _value = value;

      setThumbPosition();

      dispatchEvent(new SliderEvent(SliderEvent.CHANGE, value));
    }


  }
}
