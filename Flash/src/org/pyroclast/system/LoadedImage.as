package org.pyroclast.system
{
	
	import flash.display.Bitmap;
	
	public class LoadedImage
	{
		public var src:String;
		public var img:Class;
		
		public function LoadedImage(data:Class,srcfile:String)
		{
			img = data;
			src = srcfile;
		}
		
	}
	
}