package models.comp {

  import models.Track;
  import models.events.ButtonEvent;

  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class DragableItemContainer extends MovieClip {

    private var _items:Vector.<DragableItem> = new Vector.<DragableItem>();
    private var holder:Sprite;

    private var dropPlace:int = -1;
    private var removeElements:Array = new Array();


    public function DragableItemContainer() {
      super();

      addEventListener(ButtonEvent.START_DRAG, onStartDragElements);
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function insertElementInContainer(item:DragableItem):void {
      items.push(item);
      item.y = 40 * numChildren;
      addChild(item);
    }

    private function onStartDragElements(event:ButtonEvent):void {

      var counter:int = 0;

      for (var i:uint = 0; i < numChildren; i++) {
        var currentItem:DragableItem = getChildAt(i) as DragableItem;

        if (!currentItem.selected)
          continue;

        var imagePlaceHolder:Sprite = currentItem.makeImage();
        imagePlaceHolder.x = currentItem.x;
        imagePlaceHolder.y = currentItem.y;
        imagePlaceHolder.alpha = .3;

        var insertIndex:int = getChildIndex(currentItem);

        removeChild(currentItem);

        currentItem.y = 40 * holder.numChildren;
        holder.addChild(currentItem);
        addChildAt(imagePlaceHolder, insertIndex);

        removeElements.push(imagePlaceHolder);

        counter++;
      }

      //var rect:Rectangle = new Rectangle(x, y, 0, height);
      holder.startDrag(true/*, rect*/);

      stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragElements);
      stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    protected function onMouseMove(event:MouseEvent):void {
      var currentY:Number = Math.max(0, mouseY);
      var index:int = int(Math.min(currentY / 40, items.length));

      if (index == dropPlace)
        return;

      dropPlace = Math.min(index, items.length);
      dropPlace = Math.max(0, dropPlace);

      for (var i:uint = 0; i < numChildren; i++) {
        var element:DisplayObject = getChildAt(i);
        element.y = 40 * i + ((dropPlace <= i) ? 10 : 0);
        element.x = 0;
      }
    }

    protected function onStopDragElements(event:MouseEvent):void {
      holder.startDrag(true);

      stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragElements);
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

      for (var v:uint = 0; v < removeElements.length; v++) {
        removeChild((removeElements[v] as Sprite));
      }

      removeElements = [];

      dropPlace = Math.min(dropPlace, items.length - removeElements.length);

      while (holder.numChildren > 0) {
        var transferChild:DragableItem = holder.removeChildAt(holder.numChildren - 1) as DragableItem;
        transferChild.selected = true;

        addChildAt(transferChild, dropPlace);
      }

      dropPlace = -1;

      for (var i:uint = 0; i < numChildren; i++) {
        var element:DisplayObject = getChildAt(i);
        element.y = 40 * i;
        element.x = 0;

        DragableItem(element).selected = false;
      }
    }

    private function onAddedToStage(event:Event):void {
      holder = new Sprite();
      holder.alpha = 0.5;
      parent.addChild(holder);
    }

    protected function get items():Vector.<DragableItem> {
      return _items;
    }

    protected function set items(value:Vector.<DragableItem>):void {
      _items = value;
    }
  }
}