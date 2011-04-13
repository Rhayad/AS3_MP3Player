package models.comp {

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;

  public class ButtonBase extends MovieClip {

    public static const UP:String = "UP";
    public static const DOWN:String = "DOWN";
    public static const OVER:String = "HOVER";

    public static const BUTTON_HEIGHT:Number = 40;
    public static const BUTTON_WIDTH:Number = 250;

    private static const triggersToStates:Object = {mouseUp: OVER, mouseDown: DOWN, mouseOut: UP, mouseOver: OVER}

    private var status:String;
    private var _disabled:Boolean;

    public var labelField:TextField;

    public function ButtonBase() {
      super();

      disabled = false;
      status = ButtonBase.UP;

      labelField = new TextField();
      labelField.autoSize = TextFieldAutoSize.LEFT;
      labelField.x = 5;
      labelField.y = 10;
      labelField.text = "hallo";

      addChild(labelField);

      addEventListener(MouseEvent.MOUSE_UP, onMouseAction);
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseAction);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseAction);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseAction);

      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    protected function render():void {
      graphics.clear();

      var alphaValue:Number = disabled ? 0.5 : 1.0;
      var color:uint = 0x9900CC;

      if (!disabled) {
        color = (status == ButtonBase.OVER) ? 0xCCCCCC : color;
        color = (status == ButtonBase.DOWN) ? 0x999999 : color;
      }

      graphics.beginFill(color, alphaValue);
      graphics.drawRect(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
      graphics.endFill();
    }

    protected function onMouseAction(event:MouseEvent):void {
      status = triggersToStates[event.type];
      render();
    }

    protected function onAddedToStage(event:Event):void {
      render();
    }

    /* ---- GETTER & SETTER ---- */
    public function get disabled():Boolean {
      return _disabled;
    }

    public function set disabled(value:Boolean):void {
      _disabled = value;
      render();
    }

  }
}