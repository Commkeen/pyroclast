package org.pyroclast.game
{
	/**
	 * ...
	 * @author Matthew Everett
	 */
	
	 import flash.display.Bitmap;
	 import flash.utils.ByteArray;
	 import org.flixel.*;
	 import org.flixel.system.FlxTile;
	 import org.pyroclast.system.*;
	 
	public class StartMenuState extends FlxState
	{
		
		override public function create():void
		{
			var background:FlxSprite = new FlxSprite(0, 0);
			background.loadGraphic(Resources.titleScreenBg);
			add(background);
			FlxG.playMusic(Resources.voidMusic, 0.3);
			
			var instructions1:FlxText = new FlxText(0, 180, FlxG.width, "Arrow Keys to move");
			var instructions2:FlxText = new FlxText(0, 190, FlxG.width, "Spacebar to jump");
			var instructions3:FlxText = new FlxText(0, 220, FlxG.width, "Press Spacebar to Begin");
			
			instructions1.setFormat(null, 8, 0xFFFFFF, "center");
			instructions2.setFormat(null, 8, 0xFFFFFF, "center");
			instructions3.setFormat(null, 8, 0xFFFFFF, "center");
			
			add(instructions1);
			add(instructions2);
			add(instructions3);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				GameManager.startGame();
			}
		}
		
	}

}