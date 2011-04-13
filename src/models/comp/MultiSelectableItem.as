package models.comp {

  import flash.events.Event;
  import flash.events.MouseEvent;

  public class MultiSelectableItem extends ToggleButtonBase {

    private static var _items:Vector.<MultiSelectableItem> = new Vector.<MultiSelectableItem>();

    private var _group:String = "default";

    public function MultiSelectableItem() {
      super();
	  _items.push(this);
    }

    protected override function onMouseAction(event:MouseEvent):void {

      if (event.type == "mouseUp") {
        if (!event.ctrlKey) {
          if (unselectAll(group, this)) {

            // If other items have been unselected, this item should be selcted 
            // anyway. This for selected is changed to false, so it will be toggled
            // to true in the super method.
            selected = false;
          }
        }
      }

      super.onMouseAction(event);
    }

    private static function unselectAll(group:String, exception:MultiSelectableItem = null):Boolean {

      var action:Boolean = false;
      for (var i:uint = 0; i < _items.length; i++) {
        if (_items[i] == exception)
          continue;

        if (_items[i].selected && _items[i].group == group) {
          action = true;
          _items[i].selected = false;
        }
      }

      // Returns wether any other items had to be unselected or not.
      return action;
    }

    protected override function onAddedToStage(event:Event):void {
      super.onAddedToStage(event);

      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    protected function onRemovedFromStage(event:Event):void {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    public function get group():String {
      return _group;
    }

    public function set group(value:String):void {
      _group = value;
    }

    protected function get items():Vector.<MultiSelectableItem> {
      return _items;
    }

  }
}