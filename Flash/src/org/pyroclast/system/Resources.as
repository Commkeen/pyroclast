package org.pyroclast.system
{
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class Resources 
	{
		//Menus
		[Embed(source = "../../../../Assets/The Escape Title Screen.png")]
		public static var titleScreenBg:Class;
		
		[Embed(source = "../../../../Assets/The Escape End Screen.png")]
		public static var endScreenBg:Class;
		
		
		//Sprites
		[Embed(source = "../../../../Assets/playerSpritesheet.png")]
		public static var playerSpritesheet:Class;
		
		[Embed(source = "../../../../Assets/gemSprite.png")]
		public static var gemSprite:Class;
		
		[Embed(source = "../../../../Assets/slimeSprite.png")]
		public static var slimeSprite:Class;
		
		[Embed(source = "../../../../Assets/spikeSprite.png")]
		public static var spikeSprite:Class;
		
		[Embed(source = "../../../../Assets/shoeSprite.PNG")]
		public static var shoeSprite:Class;
		
		[Embed(source = "../../../../Assets/forcefieldSprite.png")]
		public static var forcefieldSprite:Class;
		
		[Embed(source = "../../../../Assets/doorSprite.png")]
		public static var doorSprite:Class;
		
		[Embed(source = "../../../../Assets/Bullet.png")]
		public static var bulletSprite:Class;
		
		
		//Tilesets
		[Embed(source = "../../../../Assets/tilesets/doodles.png")]
		public static var doodlesTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/grass.png")]
		public static var grassTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/crystalCaves.png")]
		public static var crystalCavesTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/lavaCaves.png")]
		public static var lavaCavesTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/objects.png")]
		public static var objectsTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/surface.png")]
		public static var surfaceTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/temple.png")]
		public static var templeTileset:Class;
		
		[Embed(source = "../../../../Assets/tilesets/village.png")]
		public static var villageTileset:Class;
		
		
		
		//Sound
		[Embed(source="../../../../Assets/Pickup_Coin.mp3")]
		public static var coinSfx:Class;
		
		
		//Music
		[Embed(source="../../../../Assets/405244_Desert_theme_thing_recompressed.mp3")]
		public static var crystalMusic:Class;
		
		[Embed(source="../../../../Assets/529691_Critical-Hit.mp3")]
		public static var slimeMusic:Class;
		
		[Embed(source = "../../../../Assets/508391_Corrupted.mp3")]
		public static var voidMusic:Class;
		
		[Embed(source = "../../../../Assets/530225_Sweet-Potato-Roll.mp3")]
		public static var shrineMusic:Class;
	}

}