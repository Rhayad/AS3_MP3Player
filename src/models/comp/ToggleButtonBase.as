package models.comp {

  import models.events.ButtonEvent;

  import flash.events.Event;
  import flash.events.MouseEvent;

  public class ToggleButtonBase extends ButtonBase {

    private var _selected:Boolean;

    public function ToggleButtonBase() {
      super();
      selected = false;
    }

    override protected function render():void {
      super.render();

      if (selected) {
        graphics.lineStyle(2, 0x333333);
        graphics.drawRect(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
      }
    }

    protected override function onMouseAction(event:MouseEvent):void {

      if (event.type == "mouseUp") {
        selected = !selected;
      }

      super.onMouseAction(event);
    }

    public function get selected():Boolean {
      return _selected;
    }

    public function set selected(value:Boolean):void {
      _selected = value;
      render();
    }

  }
}