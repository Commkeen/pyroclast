package org.pyroclast.game
{
	
	import org.pyroclast.system.*;
	import org.flixel.FlxTilemap;
	
	/**
	 * The World is a collection of Rooms.
	 * It loads rooms into memory as the player visits them,
	 * and keeps old rooms loaded in an array so that any changes the player made
	 * will stay intact in those rooms.
	 * @author Matthew Everett
	 */
	public class World 
	{
		
		private var loadedRooms:Array;
		private var roomDataManager:RoomDataManager;
		
		public function World(roomDataManager:RoomDataManager) 
		{
			loadedRooms = new Array();
			this.roomDataManager = roomDataManager;
		}
		
		public function GetRoomFromID(roomID:Number):Room
		{
			var r:Room = null;
			var roomFound:Boolean = false;
			var i:Number = 0;
			for (i = 0; i < loadedRooms.length; i++)
			{
				if ((loadedRooms[i] as Room).roomID == roomID)
				{
					r = (loadedRooms[i] as Room);
					return r;
				}
			}
			
			//If we don't have the room loaded yet, load it now
			r = createRoomFromData(roomDataManager.getRoomDataFromID(roomID));
			loadedRooms.push(r);
			return r;
		}
		
		public function GetRoomFromCoordinates(roomX:int, roomY:int):Room
		{
			var r:Room = null;
			var roomFound:Boolean = false;
			var i:Number = 0;
			for (i = 0; i < loadedRooms.length; i++)
			{
				if ((loadedRooms[i] as Room).roomX == roomX && (loadedRooms[i] as Room).roomY == roomY)
				{
					r = (loadedRooms[i] as Room);
					return r;
				}
			}
			
			//If we don't have the room loaded yet, load it now
			r = createRoomFromData(roomDataManager.getRoomDataFromCoordinates(roomX, roomY));
			loadedRooms.push(r);
			return r;
		}
		
		private function createRoomFromData(data:RoomData):Room
		{
			var room:Room = new Room();
			
			room.roomID = data.room_id;
			room.roomX = data.roomX;
			room.roomY = data.roomY;
			
			
			//TODO
			
			for (var i:int = 0; i < data.layer_tilesets.length; i++)
			{
				room.LayerTilesets[i] = data.layer_tilesets[i];
				
				
			}
			
			for (var i:int = 0; i < data.layer_data.length; i++)
			{
				room.LayerMaps[i] = FlxTilemap.arrayToCSV(data.layer_data[i], data.width);
			}
			
			return room;
		}
		
	}

}