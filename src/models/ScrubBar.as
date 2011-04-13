package models {

  import models.events.SliderEvent;
  import models.comp.HSlider;

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.text.TextField;

  public class ScrubBar extends MovieClip {

    public var slider:HSlider;
    public var timeField:TextField;

    private var _value:Number = 0;
    private var _length:Number = 0;

    private var isScrubbing:Boolean;
    private var totalTime:String;

    public function ScrubBar() {
      super();

      isScrubbing = false;
      slider = new HSlider();
	  addChild(slider);
      
	  timeField = new TextField();
      timeField.width = 55;
	  timeField.height = 20;
	  timeField.y = slider.y + 35;
	  timeField.x = slider.width / 2 - timeField.width / 2;
      addChild(timeField);
      

      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    private function onAddedToStage(event:Event):void {
      slider.addEventListener(SliderEvent.CHANGED, onSliderChanged);
      slider.addEventListener(SliderEvent.START_CHANGE, onSliderStartChange);
    }

    private function onRemovedFromStage(event:Event):void {
      slider.removeEventListener(SliderEvent.CHANGED, onSliderChanged);
      slider.removeEventListener(SliderEvent.START_CHANGE, onSliderStartChange);
    }

    private function onSliderChanged(event:SliderEvent):void {
      Player(parent).goto(event.value);
      isScrubbing = false;
    }

    private function onSliderStartChange(event:SliderEvent):void {
      isScrubbing = true;
    }

    public function set length(value:Number):void {
      _length = value;
      slider.max = value;

      var date:Date = new Date();
      date.setTime(value);

      totalTime = date.getMinutes() + ":" + date.getSeconds();
    }

    public function set value(value:Number):void {
      _value = value;

      var date:Date = new Date();
      date.setTime(value);

      timeField.text = date.getMinutes() + ":" + date.getSeconds() + " / " + totalTime;

      if (!isScrubbing)
        slider.value = value;
    }

  }
}