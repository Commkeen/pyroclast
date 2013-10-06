package org.pyroclast.game
{
	/**
	 * ...
	 * @author Matthew Everett
	 */
	
	 import flash.display.Bitmap;
	 import flash.geom.Point;
	 import flash.media.Camera;
	 import flash.utils.ByteArray;
	 import org.flixel.*;
	 import org.flixel.system.FlxTile;
	 import org.pyroclast.system.*;
	 
	public class PlayState extends FlxState
	{
		public const NUM_OF_LAYERS:int = 4;
		public const COLLIDING_LAYER:int = 2;
		public var tilemaps:Vector.<FlxTilemap>;
		
		//Groups for depth, in order from back to front
		public var backgroundImageDepth:FlxGroup;
		public var backgroundTerrain1Depth:FlxGroup;
		public var backgroundTerrain2Depth:FlxGroup;
		public var baseTerrainDepth:FlxGroup;
		public var actorDepth:FlxGroup;
		public var effectsDepth:FlxGroup;
		public var foregroundDepth:FlxGroup;
		public var hudDepth:FlxGroup;
		
		public var deathParticleGroup:FlxGroup;
		public var damagingTilesGroup:FlxGroup;
		
		public var player:Player;
		
		public var gemsCounter:FlxText;
		public var gemsCounterTimer:Number;
		public var gemsCounterTimerMax:Number;
		
		public var newAreaText:FlxText;
		public var newAreaTextTimer:Number;
		public var newAreaTextTimerMax:Number;
		public var crystalVisited:Boolean;
		public var slimeVisited:Boolean;
		public var shrineVisited:Boolean;
		
		public var actorArray:Array; //FlxSprite type
		
		public var gemsCollected:Number;
		public var gemsNeeded:Number;
		
		public var world:World; //Roomlist
		public var currentRoom:Room;
		
		public var currentMusic:String;
		
		
		public var bulletsGroup:FlxGroup;
		
		override public function create():void
		{
			world = new World(GameManager.roomDataManager);
			
			actorArray = new Array();
			
			tilemaps = new Vector.<FlxTilemap>();
			
			//Instantiate drawing groups
			backgroundImageDepth = new FlxGroup();
			backgroundTerrain1Depth = new FlxGroup();
			backgroundTerrain2Depth = new FlxGroup();
			baseTerrainDepth = new FlxGroup();
			actorDepth = new FlxGroup();
			effectsDepth = new FlxGroup();
			foregroundDepth = new FlxGroup();
			hudDepth = new FlxGroup();
			
			add(backgroundImageDepth);
			add(backgroundTerrain1Depth);
			add(backgroundTerrain2Depth);
			add(baseTerrainDepth);
			add(actorDepth);
			add(effectsDepth);
			add(foregroundDepth);
			add(hudDepth);
			
			
			deathParticleGroup = new FlxGroup();
			damagingTilesGroup = new FlxGroup();
			bulletsGroup = new FlxGroup();
			
			effectsDepth.add(deathParticleGroup);
			effectsDepth.add(bulletsGroup);
			effectsDepth.add(damagingTilesGroup);
			
			currentMusic = "";
			
			LoadRoom(world.GetRoomFromCoordinates(GameManager.currentRoomCoords.x, GameManager.currentRoomCoords.y));
			
			//TODO
			/*
			newAreaTextTimer = 0;
			newAreaTextTimerMax = 150;
			newAreaText = new FlxText(10, 200, FlxG.width, "The Void");
			newAreaText.setFormat(null, 24, 0xFF0000);
			add(newAreaText);
			newAreaText.alpha = 0;
			crystalVisited = false;
			slimeVisited = false;
			shrineVisited = false;
			*/
			
			//Create player
			player = new Player(this, 140, 40);
			player.init();
			player.saveRoomIndex = currentRoom.roomID;
			player.saveRoomPosition = player.getMidpoint();
			actorDepth.add(player);
			
			FlxG.camera.visible = false;
			var gameCamera:FlxCamera = new FlxCamera(0, 0, 320, 240, 2);
			FlxG.addCamera(gameCamera);
			gameCamera.setBounds(0, 0, 320, 240, true);
			gameCamera.follow(player, FlxCamera.STYLE_PLATFORMER);
			
		}
		
		override public function update():void
		{
	
			super.update();
			
			//If the player presses "P", switch to the editor using this room
			if (FlxG.keys.justPressed("P"))
			{
				GameManager.currentRoom = currentRoom.roomID;
				GameManager.currentRoomCoords = new Point(currentRoom.roomX, currentRoom.roomY);
				GameManager.switchState();
			}
			
			FlxG.camera.follow(player);
	
			FlxG.collide(tilemaps[COLLIDING_LAYER], player);
			FlxG.collide(deathParticleGroup, tilemaps[COLLIDING_LAYER]);
			
			
			var bulletCollide = function(object1:FlxObject, object2:FlxObject)
			{
				var bulletObject:FlxSprite;
				if (object1 is FlxSprite)
					bulletObject = object1 as FlxSprite;
				else if (object2 is FlxSprite)
					bulletObject = object2 as FlxSprite;
				
				if (bulletObject != null)
				{
					bulletObject.kill();
				}
			}
			
			
			FlxG.collide(bulletsGroup, tilemaps[COLLIDING_LAYER], bulletCollide);
			
			//Maintain new area text
			if (newAreaTextTimer > 0)
			{
				newAreaTextTimer--;
			}
			if (newAreaTextTimer <= 0 && newAreaText.alpha > 0)
			{
				newAreaText.alpha -= .02;
			}
			if (newAreaTextTimer > 0 && newAreaText.alpha < 1)
			{
				newAreaText.alpha += .02;
			}
			
			//Get gems
			var i:Number = 0;
			for (i = 0; i < actorArray.length; i++)
			{
				if (actorArray[i] is BootPickup)
				{
					if (player.overlaps(actorArray[i]))
					{
						player.doubleJumpBoots = true;
						(actorArray[i] as BootPickup).kill();
						actorArray[i] = null;
						FlxG.play(Resources.coinSfx, 0.3);
						newAreaText.text = "Double Jump!";
						newAreaTextTimer = newAreaTextTimerMax;
					}
				}
				else if (actorArray[i] is DamageTile)
				{
					if (player.visible && player.velocity.y > 0 && player.overlaps(actorArray[i]))
					{
						player.die();
					}
				}
			}
		}
		
		public function ChangeRoom(direction:String):void
		{
			for each (var tilemap:FlxTilemap in tilemaps)
			{
				tilemap.kill();
			}
			
			damagingTilesGroup.kill();
			
			//Remove everything in actor array
			var i:Number = 0;
			for (i = 0; i < actorArray.length; i++)
			{
				if (actorArray[i] != null)
				{
					remove(actorArray[i]);
				}
			}
			
			//Clear actor array
			actorArray = new Array();
			
			player.solid = FlxObject.NONE;
			
			//Check what room to go to next
			var nextRoomID:Number = null;
			var nextRoomX:Number = currentRoom.roomX;
			var nextRoomY:Number = currentRoom.roomY;
			if (direction == "down")
			{
				nextRoomID = currentRoom.bottomExit;
				nextRoomY++;
			}
			if (direction == "up")
			{
				nextRoomID = currentRoom.topExit;
				nextRoomY--;
			}
			if (direction == "left")
			{
				nextRoomID = currentRoom.leftExit;
				nextRoomX--;
			}
			if (direction == "right")
			{
				nextRoomID = currentRoom.rightExit;
				nextRoomX++;
			}
			
			/*
			if (nextRoomID != 0)
				LoadRoom(world.GetRoomFromID(roomID));
				*/
			//else
			LoadRoom(world.GetRoomFromCoordinates(nextRoomX, nextRoomY));
			
			if (direction == "down")
			{
				player.y = -20;
				
				player.velocity.x = 0;
				if (FlxG.keys.LEFT)
					player.x += 1;
				if (FlxG.keys.RIGHT)
					player.x -= 1;
				
			}
			if (direction == "up")
			{
				player.y = 230;
				
				player.velocity.x = 0;
				if (FlxG.keys.LEFT)
					player.x += 1;
				if (FlxG.keys.RIGHT)
					player.x -= 1;
					
			}
			if (direction == "left")
			{
				player.x = 305;
			}
			if (direction == "right")
			{
				player.x = -10;
			}
			
			player.solid = FlxObject.ANY;
			
		}
		
		public function LoadRoom(room:Room):void
		{
			currentRoom = room;
			
			//Reinit tilemaps
			for (var i:int = 0; i < NUM_OF_LAYERS; i++)
			{
				tilemaps[i] = new FlxTilemap();
			}
			
			//Reinit damaging tiles group
			damagingTilesGroup.revive();
			
			for (var i:int = 0; i < NUM_OF_LAYERS; i++)
			{
				if (room.LayerMaps[i] != null)
				{
					var layerTileset:Class = AssetLoader.getTilesetBySrc(room.LayerTilesets[i]).img;
					
					tilemaps[i].loadMap(room.LayerMaps[i], layerTileset, 16, 16, FlxTilemap.OFF);
				}
			}
		
			
			
			
			if (tilemaps[0].totalTiles > 0)
			{
				FlxG.bgColor = FlxG.BLACK;
				backgroundTerrain1Depth.add(tilemaps[0]);
			}
			else
			{
				FlxG.bgColor = FlxG.WHITE;
			}
			
			if (tilemaps[2].totalTiles > 0)
				foregroundDepth.add(tilemaps[2]);
				
			// TODO
			/*
			//Mark tiles as semipassable
			if (room.foregroundCollidableTileset == Resources.crystalTiles)
			{
				//Jumpthru floors
				foregroundCollidable.setTileProperties(11, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(12, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(20, FlxObject.CEILING);
				
				//Decoration
				foregroundCollidable.setTileProperties(40, FlxObject.NONE);
				foregroundCollidable.setTileProperties(41, FlxObject.NONE);
				foregroundCollidable.setTileProperties(52, FlxObject.NONE);
			}
			if (room.foregroundCollidableTileset == Resources.slimeTiles
				|| room.foregroundCollidableTileset == Resources.shrineTiles)
			{
				//Jumpthru floors
				foregroundCollidable.setTileProperties(11, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(12, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(13, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(19, FlxObject.CEILING);
				foregroundCollidable.setTileProperties(20, FlxObject.CEILING);
				
				//Decoration
				foregroundCollidable.setTileProperties(23, FlxObject.NONE);
				foregroundCollidable.setTileProperties(40, FlxObject.NONE);
				foregroundCollidable.setTileProperties(41, FlxObject.NONE);
				foregroundCollidable.setTileProperties(52, FlxObject.NONE);
			}
			
			//Get gem, force field, danger, boot, and save tiles
			var gemTileIndex:Number = 58;
			var ffTileIndex:Number = 52;
			var bootTileIndex:Number = 57;
			var dangerTileIndex:Number = 48;
			var savePointTileIndex:Number = 51;
			
			
			var i:Number = 0;
			var k:Number = 0;

			for (i = 0; i < foregroundCollidable.width; i++)
			{
				for (k = 0; k < foregroundCollidable.height; k++)
				{
					if (foregroundCollidable.getTile(i, k) == bootTileIndex)
					{
						
						foregroundCollidable.setTile(i, k, 0);
						if (!player.doubleJumpBoots)
						{
							var boot:BootPickup = new BootPickup(i, k);
							actorArray.push(boot);
							add(boot);
						}
						
					}
					else if (foregroundCollidable.getTile(i, k) == savePointTileIndex)
					{
						foregroundCollidable.setTile(i, k, 0);
						player.saveRoomIndex = currentRoom.roomID;
						player.saveRoomPosition = new FlxPoint(i * 16, k * 16);
					}
					else if (foregroundCollidable.getTile(i, k) == dangerTileIndex)
					{
						var damageTile:DamageTile;
						if (room.foregroundCollidableTileset == Resources.crystalTiles)
							damageTile = new DamageTile(i, k, "crystal");
						else
							damageTile = new DamageTile(i, k, "slime");
						actorArray.push(damageTile);
						damagingTilesGroup.add(damageTile);
						foregroundCollidable.setTile(i, k, 0);
					}
				}
			}
			

			
			
			//Play music
			if (room.musicChange != "" && room.musicChange != this.currentMusic)
			{
				this.currentMusic = room.musicChange;
				if (room.musicChange == "Caves")
				{
					//FlxG.music.stop();
					FlxG.playMusic(Resources.crystalMusic, 0.6);
					if (!crystalVisited)
					{
						newAreaText.text = "Crystal Caves";
						newAreaTextTimer = newAreaTextTimerMax;
						crystalVisited = true;
					}
						
				}
				
				if (room.musicChange == "Slime")
				{
					FlxG.playMusic(Resources.slimeMusic, 0.6);
					if (!slimeVisited)
					{
						newAreaText.text = "Slime Labs";
						newAreaTextTimer = newAreaTextTimerMax;
						slimeVisited = true;
					}
				}
				
				if (room.musicChange == "Void")
				{
					FlxG.playMusic(Resources.voidMusic, 0.6);
				}
				
				if (room.musicChange == "Shrine")
				{
					FlxG.playMusic(Resources.shrineMusic, 0.6);
					if (!shrineVisited)
					{
						newAreaText.text = "The Undershrine";
						newAreaTextTimer = newAreaTextTimerMax;
						shrineVisited = true;
					}
				}
			}
			*/
			
		}
		
		//Called by player when dead to reset
		public function OnPlayerDeath():void
		{
			/*
			remove(gemsCounter);
			remove(background);
			remove(foregroundCollidable);
			remove(foregroundNoncollidable);
			forceFieldsGroup.kill();
			forceFieldTextGroup.kill();
			damagingTilesGroup.kill();
			
			portal = null;
			puppy = null;
			
			//Remove everything in actor array
			var i:Number = 0;
			for (i = 0; i < actorArray.length; i++)
			{
				remove(actorArray[i]);
			}
			
			//Clear actor array
			actorArray = new Array();
			
			player.x = player.saveRoomPosition.x;
			player.y = player.saveRoomPosition.y;
			player.revive();
			player.visible = true;
			player.deathResetTimer = -1;
			
			
			LoadRoom(world.GetRoomFromID(player.saveRoomIndex));
			
			add(gemsCounter);
			*/
		}
		
		/**
		 * Called by GameManager when we switch here from the editor.
		 * Loads up the room we were just editing and places the player where we put him.
		 * @param	roomID
		 */
		public function switchFromEditor(roomID:int, playerCoords:Point)
		{
			
		}
		
		
	}

}