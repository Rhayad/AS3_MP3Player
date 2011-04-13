package models {

  import models.comp.DragableItemContainer;
  import models.events.TrackEvent;
  import models.Track;

  import flash.display.Sprite;
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  public class TrackList extends DragableItemContainer {

    private var currentTrack:Track;
    private var holder:Sprite;

    public function TrackList() {
      super();

      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function loadXML(path:String):void {

      var urlLoader:URLLoader = new URLLoader();
      urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
      urlLoader.load(new URLRequest(path));
    }

    public function setTrack(track:Track):void {
      if (currentTrack != null) {
        currentTrack.active = false;
      }

      currentTrack = track;
      track.active = true;
    }

    private function onXMLLoaded(event:Event):void {

      var xml:XML = new XML(event.target.data);

      for each (var node:XML in xml.children()) {
        insertElementInContainer(new Track(node.@path, node.@artist, node.@title));
      }

    }

    private function onNextTrack(event:TrackEvent):void {
      if (!contains(currentTrack)) {
        if (numChildren > 0) {
          var nextTrack:Track = Track(getChildAt(0));

          dispatchEvent(new TrackEvent(TrackEvent.PLAY_TRACK, nextTrack.path, true));
          setTrack(nextTrack);
        }

        return;
      }

      nextTrack = Track(getChildAt((getChildIndex(currentTrack) + 1) % numChildren));

      dispatchEvent(new TrackEvent(TrackEvent.PLAY_TRACK, nextTrack.path, true));
      setTrack(nextTrack);
    }

    private function onAddedToStage(event:Event):void {
      parent.addEventListener(TrackEvent.NEXT_TRACK, onNextTrack);
    }
  }
}