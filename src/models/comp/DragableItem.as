package models.comp {

  import models.events.ButtonEvent;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;

  public class DragableItem extends MultiSelectableItem {

    private var _dragContainer:DisplayObjectContainer;
    private var _container:DisplayObjectContainer;

    public function DragableItem() {
      super();
    }

    protected override function onMouseAction(event:MouseEvent):void {
      super.onMouseAction(event);

      if (event.type == "mouseDown")
        addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      else if (event.type == "mouseUp")
        removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onMouseMove(event:MouseEvent):void {
      removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      dispatchEvent(new ButtonEvent(ButtonEvent.START_DRAG, true));
    }

    public function makeImage():Sprite {
      var bitmapData:BitmapData = new BitmapData(this.width, this.height);
      bitmapData.draw(this);

      var picture:Bitmap = new Bitmap(bitmapData);

      var returnSprite:Sprite = new Sprite();
      returnSprite.addChild(picture);

      return returnSprite;
    }

    public function get dragContainer():DisplayObjectContainer {
      return _dragContainer;
    }

    public function set dragContainer(value:DisplayObjectContainer):void {
      _dragContainer = value;
    }

    public function get container():DisplayObjectContainer {
      return _container;
    }

    public function set container(value:DisplayObjectContainer):void {
      _container = value;
    }


  }
}