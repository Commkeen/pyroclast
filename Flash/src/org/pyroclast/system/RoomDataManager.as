package org.pyroclast.system 
{
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Matthew Everett
	 */
	public class RoomDataManager 
	{
		
		private var room_data:Vector.<RoomData>;
		private var manifestPath:String;
		private var idCounter:uint;
		
		public const WORLD_WIDTH:int = 10000;
		public const WORLD_HEIGHT:int = 10000;
		
		public function RoomDataManager(manifestPath:String) 
		{
			this.manifestPath = manifestPath;
			loadManifest();
		}
		
		/**
		 * Gets the RoomData object for the room with the given ID.
		 * If none exists, a blank room is created, added to our list of room data and returned.
		 * 
		 * @param	roomID	The ID to search for.
		 * @return	The RoomData for the given ID.
		 */
		public function getRoomDataFromID(roomID:int):RoomData
		{
			for (var i:int = 0; i < room_data.length; i++)
			{
				if (room_data[i].room_id == roomID)
					return room_data[i];
			}
			
			//If we get down here, there's no room there so we'll make a blank room and add it
			//TODO
			
			var newRoom:RoomData = new RoomData(roomID, 1000, 1000); //TODO: Figure out coordinates a better way somehow?
			initNewRoom(newRoom);
			room_data.push(newRoom);
			
			return newRoom;
		}
		
		/**
		 * Gets the RoomData object for the room with the given coordinates.
		 * If none exists, a blank room is created, added to our list of room data and returned.
		 * 
		 * @param	x	The X coordinate of the room to search for.
		 * @param	y	The Y coordinate of the room to search for.
		 * @return	The RoomData for the given coordinates.
		 */
		public function getRoomDataFromCoordinates(x:int, y:int):RoomData
		{
			for (var i:int = 0; i < room_data.length; i++)
			{
				if (room_data[i].roomX == x && room_data[i].roomY == y)
					return room_data[i];
			}
			
			//If we get down here, there's no room there so we'll make a blank room and add it
			//TODO
			
			var newRoom:RoomData = new RoomData(idCounter++, x, y);
			initNewRoom(newRoom);
			room_data.push(newRoom);
			
			return newRoom;
		}
		
		public function reloadAll():void
		{
			loadManifest();
		}
		
		public function saveAllRoomDataAndManifest():void
		{
			var xml:XML = <world>
							<assets>
							</assets>
							<rooms>
							</rooms>
						</world>;
			xml.@name = "Matt's World";
			xml.@tilesize = 16;
			xml.@width = 20; //TODO
			xml.@height = 15; //TODO
			
			var i:int;
			var xmlassets:XML = xml.assets[0];
			for (i = 0; i < AssetLoader.tilesets.length; i++)
			{
				var xmlasset:XML = <asset />;
				xmlasset.@src = AssetLoader.tilesets[i].src;
				xmlassets.appendChild(xmlasset);
			}
			
			var xmlrooms:XML = xml.rooms[0];
			for (i = 0; i < room_data.length; i++)
			{
				var xmlRoom:XML = room_data[i].toXML();
				xmlrooms.appendChild(xmlRoom);
			}
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(xml);
			
			var fr:FileReference = new FileReference();
			fr.save(ba, "mattsworld.xml");
		}
		
		private function initNewRoom(room:RoomData)
		{
			var i:int;
			//Empty array for starting tilesets
			var arr:Array = new Array();
			for (i = 0; i < room.width * room.height; i++)
			{
				arr[i] = 0;
			}
			
			for (i = 0; i < 5; i++)
			{
				room.layer_tilesets[i] = AssetLoader.tilesets[0].src;
				room.layer_data[i] = arr.slice();
			}
			
			room.empty = true;
		}
		
		private function loadManifest():void
		{
			room_data = new Vector.<RoomData>();
			idCounter = 0;
			
			var xml:XML;
			var loader:URLLoader = new URLLoader();
			
			loader.load(new URLRequest(manifestPath));
			loader.addEventListener(Event.COMPLETE, loadComplete);
			
			function loadComplete(e:Event):void
			{
				xml = XML(e.target.data);
				onComplete(xml);
			}
			
			function onComplete(xml:XML):void
			{
				for each(var room:XML in xml.rooms.room)
				{
					//Increment id assignment counter
					if (room.@id > idCounter)
						idCounter = room.@id + 1;
					
					var newRoom:RoomData = new RoomData(room.@id, room.@roomx, room.@roomy);
					newRoom.loadFromXML(room);
					room_data.push(newRoom);
				}
				
				
			}
		}
		
	}

}