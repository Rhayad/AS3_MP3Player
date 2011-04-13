package {

  import models.Player;
  import models.TrackList;

  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;

  public class Main extends Sprite {

    public var dragContainer:Sprite;
    public var trackList:TrackList;
    public var player:Player;

    public function Main() {

		
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
	  
      trackList = new TrackList();
      trackList.loadXML("runtime-assets/tracklist.xml");
      trackList.x = stage.stageWidth / 2 - 110;
	  trackList.y = 420;

      player = new Player();
      player.x = player.y = 10;

      addChild(player);
      addChild(trackList);

	}

  }
}