package  
{
	/**
	 * ...
	 * @author Matthew Everett
	 */
	
	 import org.flixel.*;
	 import org.pyroclast.system.*;
	 import org.pyroclast.game.*;
	[SWF(width="1280", height="700", backgroundColor="#000000")] //Set the size and color of the Flash file
	 
	public class FebGame extends FlxGame
	{
		
		
		public function FebGame()
		{
			super(1280, 700, StartMenuState, 1);
			//forceDebugger = true;
			//FlxG.debug = true;
			//FlxG.visualDebug = true;
			var manager:GameManager = new GameManager();
			
			manager.start();
		}
		
	}

}