package models
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class CenterTextField extends TextField
	{		
		public function CenterTextField(cWidth:int, cHeight:int, cYPosition:int, cStageWidth:int, cText:String)
		{
			super();
			
			//Setup properties of the textfield on stage
			this.type = TextFieldType.INPUT;
			this.multiline = true;
			this.border = false;
			this.wordWrap = true;
			this.width = cWidth;
			this.height = cHeight;
			this.x = (cStageWidth - this.width) / 2;
			this.y = cYPosition;
			this.text = cText;
		}
	}
}