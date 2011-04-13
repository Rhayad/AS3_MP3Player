package models {

  import models.comp.HSlider;
  import models.events.SliderEvent;

  import flash.events.Event;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;

  public class VolumeSlider extends HSlider {
    private var _soundChannel:SoundChannel;

    public function VolumeSlider() {
      super();

      min = 0;
      max = 1;

      value = .5;

      addEventListener(SliderEvent.CHANGE, onSliderChanged);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    private function onSliderChanged(event:SliderEvent):void {
      if (!_soundChannel)
        return;

      var transform:SoundTransform = _soundChannel.soundTransform;
      transform.volume = event.value;

      _soundChannel.soundTransform = transform;
    }

    private function onRemoved(event:Event):void {
      removeEventListener(SliderEvent.CHANGE, onSliderChanged);
      removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    public function set soundChannel(value:SoundChannel):void {
      _soundChannel = value;
    }
  }
}