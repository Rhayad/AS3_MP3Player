package models {

  import models.comp.DragableItem;
  import models.events.TrackEvent;

  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.AntiAliasType;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;

  public class Track extends DragableItem {

    private var _artist:String;
    private var _trackname:String;
    private var _path:String;
    private var _active:Boolean;

    public function Track(path:String, artist:String = "Unknown Artist", trackname:String = "Unknown Track") {
      super();

      _artist = artist;
      _trackname = trackname;
      _path = path;
      _active = false;

      mouseChildren = false;
      doubleClickEnabled = true;
      addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);

      labelField.autoSize = TextFieldAutoSize.LEFT;
      labelField.text = _trackname + " von " + _artist;
    }

    protected override function render():void {
      super.render();

      if (!labelField)
        return;

      if (active) {
        var colorChanger:TextFormat = new TextFormat(null, null, 0xFFFFFF);
        labelField.setTextFormat(colorChanger);
      } else {
        colorChanger = new TextFormat(null, null, 0x000000);
        labelField.setTextFormat(colorChanger);
      }
    }

    protected function onDoubleClick(event:MouseEvent):void {
      TrackList(parent).setTrack(this);
      dispatchEvent(new TrackEvent(TrackEvent.PLAY_TRACK, path, true));
    }

    public function getDeepCopy():Track {
      var returnTrack:Track = new Track(_path, _artist, _trackname);
      returnTrack.active = active;

      return returnTrack;
    }

    public function get artist():String {
      return _artist;
    }

    public function get trackname():String {
      return _trackname;
    }

    public function get path():String {
      return _path;
    }

    public function get active():Boolean {
      return _active;
    }

    public function set active(value:Boolean):void {
      _active = value;
      render();
    }


  }
}