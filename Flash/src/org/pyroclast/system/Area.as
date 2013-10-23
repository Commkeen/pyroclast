package org.pyroclast.system 
{
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class Area 
	{
		
		public static const NUM_OF_AREAS:int = 5;
		
		public static const VILLAGE:Area = new Area("village", 0, 0xFF0000FF);
		public static const CAVES:Area = new Area("caves", 1, 0xFF006666);
		public static const TEMPLE:Area = new Area("temple", 2, 0xFFFFFF00);
		public static const SURFACE:Area = new Area("surface", 3, 0xFF00FF00);
		public static const LAVA:Area = new Area("lava", 4, 0xFFFF0000);
		
		private var name:String;
		private var index:int;
		private var editorColor:uint;
		
		public function Area(areaName:String, areaIndex:int, areaColor:uint) 
		{
			name = areaName;
			index = areaIndex;
			editorColor = areaColor;
		}
		
		public static function getArea(index:int):Area
		{
			var a:Area = new Area("undefined", -1, 0xFFFFFF);
			switch (index)
			{
				case 0:
					a = VILLAGE;
					break;
				case 1:
					a = CAVES;
					break;
				case 2:
					a = TEMPLE;
					break;
				case 3:
					a = SURFACE;
					break;
				case 4:
					a = LAVA;
					break;
			}
			return a;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getIndex():int
		{
			return index;
		}
		
		public function getEditorColor():uint
		{
			return editorColor;
		}
		
	}

}