package org.pyroclast.system 
{
	
	import flash.geom.Point;
	import org.pyroclast.editor.EditorState;
	import org.pyroclast.game.PlayState;
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class GameManager
	{
		
		public static var roomDataManager:RoomDataManager;
		public static var currentRoom:int;
		public static var currentRoomCoords:Point;
		public static var playerCoords:Point;
		
		private static var playState:PlayState;
		private static var editorState:EditorState;
		
		private static var inEditor:Boolean;
		
		public function GameManager() 
		{
			
		}
		
		public function start()
		{
			
			AssetLoader.init(onLoadComplete);
			
		}
		
		public static function onLoadComplete()
		{
			roomDataManager = new RoomDataManager("../assets/mattsworld.xml");
			
			currentRoom = 100;
			currentRoomCoords = new Point(10, 10);
			playerCoords = new Point(100, 100);
			
			playState = new PlayState();
			editorState = new EditorState();
			editorState.roomManager = roomDataManager;
			
			inEditor = false;
		}
		
		public static function startGame()
		{
			FlxG.switchState(playState);
		}
		
		public static function switchState()
		{
			if (inEditor)
			{
				inEditor = false;
				FlxG.mouse.hide();
				playState = new PlayState();
				FlxG.switchState(playState);
				playState.switchFromEditor(currentRoom, playerCoords);
			}
			else
			{
				inEditor = true;
				FlxG.mouse.show();
				editorState = new EditorState();
				FlxG.switchState(editorState);
				editorState.switchFromGame(currentRoom);
			}
		}
		
	}

}