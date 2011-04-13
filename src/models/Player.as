package models {

  import flash.display.MovieClip;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.net.URLRequest;
  import flash.text.TextFormat;
  import flash.utils.Timer;
  
  import models.CenterTextField;
  import models.ScrubBar;
  import models.events.TrackEvent;
 
  public class Player extends MovieClip {

    public var balanceSlider:BalanceSlider;
    public var playButton:PausePlayButton;
    public var scrubSlider:ScrubBar;
    public var stopButton:PausePlayButton;
    public var volumeSlider:VolumeSlider;

    private var currentPosition:Number;
    private var isPlaying:Boolean;
    private var sound:Sound;

    private var soundChannel:SoundChannel;
    private var timer:Timer;
	private var balanceText:CenterTextField;
	private var volumeText:CenterTextField;
	private var headerText:CenterTextField;
	private var scrubText:CenterTextField;
	private var trackListText:CenterTextField;
	private var fontSize:TextFormat;
	private var headerSize:TextFormat;
	private var stageCenter:int = 1280;
	

    public function Player() {
      super();

      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	  
	  fontSize = new TextFormat();
	  fontSize.size = 18;
	  
	  headerText = new CenterTextField(140, 35, 10, stageCenter, "MP3 Player");
	  headerSize = new TextFormat();
	  headerSize.size = 26;
	  headerSize.underline = true;
	  headerText.setTextFormat(headerSize);
	  addChild(headerText);
	  
	  balanceText = new CenterTextField(70, 25, 60, stageCenter, "Balance");
	  balanceText.setTextFormat(fontSize);
	  addChild(balanceText);
	  
	  volumeText = new CenterTextField(70, 25, 140, stageCenter, "Volume");
	  volumeText.setTextFormat(fontSize);
	  addChild(volumeText);
	  
	  scrubText = new CenterTextField(50, 25, 220, stageCenter, "Scrub");
	  scrubText.setTextFormat(fontSize);
	  addChild(scrubText);
	  
	  trackListText = new CenterTextField(70, 25, 380, stageCenter, "Tracklist");
	  trackListText.setTextFormat(fontSize);
	  addChild(trackListText);

      timer = new Timer(1000);
      timer.addEventListener(TimerEvent.TIMER, onTimer);

      scrubSlider = new ScrubBar();
      balanceSlider = new BalanceSlider();
      volumeSlider = new VolumeSlider();
      playButton = new PausePlayButton();
      stopButton = new PausePlayButton();

      playButton.gotoAndStop("play");
      stopButton.gotoAndStop("stop");

      playButton.y = stopButton.y = 310;
	  playButton.x = stageCenter / 2 - playButton.width;
	  stopButton.x = stageCenter / 2 + 10;


      playButton.buttonMode = true;
      stopButton.buttonMode = true;

      
      addChild(balanceSlider).y = balanceText.y + 30;
      addChild(volumeSlider).y = volumeText.y + 30;
	  addChild(scrubSlider).y = scrubText.y + 30;
      addChild(playButton);
      addChild(stopButton);
	  scrubSlider.x = volumeSlider.x = balanceSlider.x = stageCenter / 2 - scrubSlider.width / 2;
    }

    public function goto(time:Number):void {
      if (!soundChannel)
        return;

      soundChannel.stop();
      soundChannel = sound.play(time);
      setSoundTransform();
      isPlaying = true;

      playButton.gotoAndStop("pause");
    }


    public function playTrack(event:TrackEvent):void {

      if (soundChannel)
        soundChannel.stop();

      try {
        if (sound)
          sound.close()
      } catch (error:*) {
      }

      sound = new Sound();
      sound.addEventListener(Event.COMPLETE, onSoundLoaded);
      sound.load(new URLRequest(event.path));

    }

    private function onAddedToStage(event:Event):void {
      playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
      stopButton.addEventListener(MouseEvent.CLICK, onStopClick);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

      parent.addEventListener(TrackEvent.PLAY_TRACK, playTrack);
    }

    private function onPlayClick(event:MouseEvent):void {
      if (!soundChannel)
        return;

      if (!isPlaying) {

        isPlaying = true;
        soundChannel = sound.play(currentPosition);
        setSoundTransform();
        timer.start();
        playButton.gotoAndStop("pause");

      } else {

        currentPosition = soundChannel.position;
        isPlaying = false;
        soundChannel.stop();
        timer.stop();
        playButton.gotoAndStop("play");

      }
    }

    private function onRemovedFromStage(event:Event):void {
      removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

      playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
      stopButton.removeEventListener(MouseEvent.CLICK, onStopClick);

      parent.removeEventListener(TrackEvent.PLAY_TRACK, playTrack);
    }

    private function onSoundComplete(event:Event):void {
      dispatchEvent(new TrackEvent(TrackEvent.NEXT_TRACK, null, true));
    }

    private function onSoundLoaded(event:Event):void {

      soundChannel = sound.play();
      setSoundTransform();
      isPlaying = true;

      timer.stop();
      timer.start();

      playButton.gotoAndStop("pause");
    }

    private function onStopClick(event:MouseEvent):void {
      if (!soundChannel)
        return;

      isPlaying = false;
      soundChannel.stop();
      timer.stop();
      currentPosition = 0;
      scrubSlider.value = 0;
      playButton.gotoAndStop("play");
    }

    private function onTimer(event:TimerEvent):void {
      scrubSlider.value = soundChannel.position;
    }

    private function setSoundTransform():void {

      var transform:SoundTransform = new SoundTransform();
      transform.pan = balanceSlider.value;
      transform.volume = volumeSlider.value;

      soundChannel.soundTransform = transform;
      soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);

      balanceSlider.soundChannel = soundChannel;
      volumeSlider.soundChannel = soundChannel;

      scrubSlider.length = sound.length;
    }
  }
}