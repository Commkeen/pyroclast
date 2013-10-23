package org.pyroclast.system
{
	import flash.utils.Dictionary;
	import flash.display.Bitmap;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.Loader;
	import flash.display.BitmapData;
	
	public class  AssetLoader
	{
		public static const ASSET_DIR:String = "../assets/";
		public static const TILESET_DIR:String = "tilesets/";
		
		public static var tilesets:Vector.<LoadedImage>;
		
		public static var total_assets:uint = 1;
		public static var loaded_assets:uint = 0;
		
		public static var onFullyLoaded:Function;
		
		public static var masterFilePath:String; 						// Just because it sounds cool
		
		public static function init(callback:Function = null)
		{
			onFullyLoaded = callback;
			trace("got here!!");
			loadXML(ASSET_DIR + "masterFilePath.xml", setMasterFilePath);
			
			tilesets = new Vector.<LoadedImage>();
			tilesets[0] = new LoadedImage(Resources.doodlesTileset, "doodles.png");
			tilesets[1] = new LoadedImage(Resources.grassTileset, "grass.png");
			tilesets[2] = new LoadedImage(Resources.villageTileset, "village.png");
			tilesets[3] = new LoadedImage(Resources.crystalCavesTileset, "crystalCaves.png");
			tilesets[4] = new LoadedImage(Resources.templeTileset, "temple.png");
			tilesets[5] = new LoadedImage(Resources.surfaceTileset, "surface.png");
			tilesets[6] = new LoadedImage(Resources.lavaCavesTileset, "lavaCaves.png");
			onFullyLoaded();
			
			function setMasterFilePath(xml:XML):void
			{
				masterFilePath = xml.@src;
				trace(masterFilePath);
			}
		}
		
		public static function loadXML(file:String, onComplete:Function):void
		{
			var xml:XML;
			var loader:URLLoader = new URLLoader();
			
			loader.load(new URLRequest(file));
			loader.addEventListener(Event.COMPLETE, loadComplete);
			function loadComplete(e:Event):void 
			{
				xml = new XML(e.target.data);
				onComplete(xml);
			}
		}
		
		public static function loadTilesets(xml:XML):void
		{
			
			
			//var loaders:Array = new Array();
			
			/*
			for each(var image:XML in xml.image)
			{
				var loader:SpecialLoader = new SpecialLoader();
				var src:String = image.attribute("src");
				//trace("Source Found! : " + src);
				
				loader.data.push(src);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImage);
				loader.load(new URLRequest(ASSET_DIR + TILESET_DIR + src));
				loaders.push(loader);
				++total_assets;
			}
			
			function loadImage(e:Event):void
			{
				trace(e.target.loader.data[0]);
				var completedImage:LoadedImage = new LoadedImage(Bitmap(e.target.content), e.target.loader.data[0]);
				tilesets.push(completedImage);
				countLoadedAsset();
			}
			*/
		}
		
		public static function countLoadedAsset():void
		{
			++loaded_assets;
			if (onFullyLoaded && loaded_assets == total_assets)
			{
				onFullyLoaded();
			}
		}
		
		public static function getTilesetBySrc(src:String):LoadedImage
		{
			if (!tilesets) return null;
			
			//trace("src received: " + src);
			for (var i:int = 0; i < tilesets.length; i++)
			{
				//trace("Checking src: " + src + " against src: " + tilesets[i].src);
				if (tilesets[i].src == src)
					return tilesets[i];
			}
			
			return null;
		}
	}
	
}