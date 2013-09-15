package org.pyroclast.editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import mx.core.FlexTextField;
	import org.flixel.*;
	import org.pyroclast.system.*;
	
	public class EditorState extends FlxState
	{
		public var assets:AssetLoader;
		
		public var room_size:Point = new Point(640, 480);
		public var room_rowsxcols:Point;
		public var room_cell_size:uint = 32;
		public var tile_cell_size:uint = 16;
		public var world_cell_size:uint = 16;
		
		public var world_grid:FlxGrid;
		public var tileset_grid:FlxGrid;
		public var room_layers:Vector.<FlxGrid>;
		public var room_background:FlxSprite;
		
		public var roomManager:RoomDataManager;
		public var current_room:Point;
		public var current_layer:int = 2;
		public var layer_count:uint = 4;
		public var next_roomid:uint = 0;
		public var layer_text:FlxText;
		public var layer_visibility:int = 0;
		public var layer_visibility_button:FlxButton;
		
		public var current_tile:BitmapData;
		public var current_tile_coords:Point;
		public var current_tile_display:FlxSprite;
		public var current_tileset:int = 0;
		public var tileset_text:FlxText;
		
		public var area_button:FlxSprite;
		public var area_text:FlxText;
		public var area_button_size:uint = 50;
		public var selected_area:uint = 0;
		public var area_color:uint = 0xFF0000FF;
		
		public var mouse_prev:Point;
		public var ctrl_down:Boolean;
		
		public var initialized:Boolean = false;
		
		override public function create():void
		{
			assets = new AssetLoader(load_finished);
			//load_finished();
		}
		
		override public function update():void
		{
			super.update();
			
			if (!initialized) return;
			
			update_grids();
			
			ctrl_down = FlxG.keys.CONTROL;
			if (FlxG.mouse.justPressed())
			{
				mouse_prev = new Point(FlxG.mouse.x, FlxG.mouse.y);
				check_grid_click(FlxG.mouse.x, FlxG.mouse.y);
				checkAreaButtonClick(FlxG.mouse.x, FlxG.mouse.y);
			}
			else if (FlxG.mouse.pressed())
			{
				if (FlxG.mouse.x != mouse_prev.x || FlxG.mouse.y != mouse_prev.y)
				{
					check_grid_click(FlxG.mouse.x, FlxG.mouse.y, true);
					mouse_prev = new Point(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
		}
		
		public function update_grids():void
		{
			// Update all grids' cursors...
			
			world_grid.updateCursor();
			tileset_grid.updateCursor();
			/*for (var i:int = 0; i < room_layers.length; i++)
			{
				room_layers[i].updateCursor();
			}*/
		}
		
		public function check_grid_click(x:int, y:int, drag:Boolean = false):void
		{
			
			// Test all grids for a click at the given coordinates
			// NOTE: If dragging, skip over grids that are not set to allow drag selection!!
			if (!(drag && !world_grid.drag_selectable)) world_grid.handleClick(x, y);
			if (!(drag && !tileset_grid.drag_selectable)) tileset_grid.handleClick(x, y);
			for (var i:int = 0; i < room_layers.length; i++)
			{
				if (room_layers[i].hidden()) continue;
				if (!(drag && !room_layers[i].drag_selectable)) room_layers[i].handleClick(x, y);
			}
		}
		
		
		public function world_clicked(coords:Point):void
		{
			setCurrentRoom(coords.x, coords.y);
		}
		
		public function tileset_clicked(coords:Point):void
		{
			setCurrentTile(coords.x,coords.y);
		}
		
		public function room_clicked(coords:Point):void
		{
			placeTile(coords.x, coords.y, ctrl_down ? true : false);
		}
		
		public function tilesetLeft():void
		{
			scrollTilesets( -1);
		}
		
		public function tilesetRight():void
		{
			scrollTilesets(1);
		}
		
		public function layerLeft():void
		{
			changeLayers( -1);
		}
		
		public function layerRight():void
		{
			changeLayers(1);
		}
		
		public function notify(coords:FlxPoint):void
		{
			
			//test.setCellColor(coords.y, coords.x, ctrl_down ? 0x00000000 : 0xFF0000FF);
			//trace("A grid space was clicked at coordinates: " + coords.x + ", " + coords.y + "!");
		}
		
		public function load_finished():void
		{
			FlxG.bgColor = 0xFF666666;
			
			
			
			world_grid = new FlxGrid(50, 425, 320, 240, world_cell_size);
			world_grid.onClickCallback = world_clicked;
			world_grid.showCursor();
			
			var world_grid_back:FlxSprite = new FlxSprite(world_grid.x, world_grid.y);
			world_grid_back.makeGraphic(world_grid.width, world_grid.height, 0xFF000000, true);
			add(world_grid_back);
			add(world_grid.grid_group);
			
			var world_title_text:FlxText = new FlxText(world_grid.x, world_grid.y - 20, 150, "World Map");
			world_title_text.size = 16;
			add(world_title_text);
			
			
			
			tileset_grid = new FlxGrid(50, 30, 192, 224, tile_cell_size);
			tileset_grid.onClickCallback = tileset_clicked;
			tileset_grid.showCursor();
			
			var tileset_background:FlxSprite = new FlxSprite(tileset_grid.x, tileset_grid.y);
			tileset_background.makeGraphic(tileset_grid.width, tileset_grid.height, 0xFF000000, true);
			add(tileset_background);
			add(tileset_grid.grid_group);
			
			var tile_title_text:FlxText = new FlxText(tileset_grid.x, tileset_grid.y - 20, 150, "Tileset");
			tile_title_text.size = 16;
			add(tile_title_text);
			
			
			
			room_background = new FlxSprite(420, 10);
			room_background.makeGraphic(room_size.x, room_size.y, 0xFF000000);
			add(room_background);
			
			room_layers = new Vector.<FlxGrid>();
			var i:int;
			var j:int;
			for (i = 0; i < layer_count; i++)
			{
				room_layers.push(new FlxGrid(420, 10, room_size.x, room_size.y, room_cell_size, 0x00000000));
				room_layers[i].onClickCallback = room_clicked;
				room_layers[i].drag_selectable = true;
				add(room_layers[i].grid_group);
				if (i != current_layer) room_layers[i].hide();
			}
			
			room_rowsxcols = new Point(room_layers[current_layer].cols_displayed, room_layers[current_layer].rows_displayed);
			
			
			world_data = new Vector.<Vector.<RoomData>>();
			for (i = 0; i < world_grid.rows_displayed; i++)
			{
				world_data.push(new Vector.<RoomData>());
				for (j = 0; j < world_grid.cols_displayed; j++)
				{
					world_data[i].push(null);
				}
			}
			
			setCurrentRoom(uint(world_grid.cols_displayed * .5), uint(world_grid.rows_displayed * .5));
			
			tileset_grid.setTileset(assets.tilesets[current_tileset]);
			current_tile = tileset_grid.getTile(0, 0);
			current_tile_coords = new Point(0, 0);
			updateCurrentTileDisplay();
			
			add(new FlxButton(tileset_grid.x, tileset_grid.y + 240, "<<", tilesetLeft));
			add(new FlxButton(tileset_grid.x + 116, tileset_grid.y + 240, ">>", tilesetRight));
			tileset_text = new FlxText(tileset_grid.x + 92, tileset_grid.y + 238, 50, "" + current_tileset);
			tileset_text.size = 16;
			add(tileset_text);
			
			layer_text = new FlxText(room_layers[current_layer].x, room_layers[current_layer].y + room_layers[current_layer].height + 10, 100, "Layer: " + current_layer)
			layer_text.size = 16;
			add(layer_text);
			add(new FlxButton(room_layers[current_layer].x + 100, room_layers[current_layer].y + room_layers[current_layer].height + 10, "<<", layerLeft));
			add(new FlxButton(room_layers[current_layer].x + 200, room_layers[current_layer].y + room_layers[current_layer].height + 10, ">>", layerRight));
			layer_visibility_button = new FlxButton(room_layers[current_layer].x + 400, room_layers[current_layer].y + room_layers[current_layer].height + 10, "Layer Transparency: OFF", toggleLayerTransparency);
			layer_visibility_button.label = new FlxText(0, 0, 300, "Layer Transparency: OFF");
			layer_visibility_button.scale.x = 2.1;
			layer_visibility_button.labelOffset.x = -layer_visibility_button.width / 2 + 15;
			layer_visibility_button.label.color = 0xFF000000;
			layer_visibility_button.width = layer_visibility_button.width * 2.1;
			add(layer_visibility_button);
			
			area_button = new FlxSprite(world_grid.x, world_grid.y - 80);
			area_button.makeGraphic(area_button_size, area_button_size, area_color, true);
			add(area_button);
			
			area_text = new FlxText(area_button.x, area_button.y - 25, 100, "Area: " + selected_area);
			area_text.size = 16;
			add(area_text);
			
			add(new FlxButton(1150, 600, "SAVE", roomManager.saveAllRoomDataAndManifest));
			add(new FlxButton(1150, 640, "LOAD", roomManager.reloadAll));
			
			
			initialized = true;
			trace("This worked!!!");
		}
		
		public function setCurrentRoom(x:uint, y:uint):void
		{
			if (y < 0 || y > world_data.length) return;
			if (x < 0 || x > world_data[0].length) return;
			
			current_room = new Point(x, y);
			if (world_data[current_room.y][current_room.x])
			{
				if (ctrl_down)
				{
					clearRoomLayers();
					world_grid.setCellColor(current_room.x, current_room.y, 0xFF000000);
					world_data[current_room.y][current_room.x] = null;
				}	
				else
				{
					// FIX THIS TO WORK WITH NEW ROOM DATA
					//room_layers[current_layer].loadRoomData(current_layer, assets, world_data[current_room.y][current_room.x]);
					loadRoomLayers();
					selected_area = world_data[current_room.y][current_room.x].area;
					area_color = world_data[current_room.y][current_room.x].area_color;
					area_button.makeGraphic(area_button_size, area_button_size, world_data[current_room.y][current_room.x].area_color, true);
					area_text.text = "Area: " + selected_area;
				}
			}
			else
			{
				world_data[current_room.y][current_room.x] = new RoomData(nextRoomId(), room_rowsxcols.x, room_rowsxcols.y);
				world_data[current_room.y][current_room.x].area = selected_area;
				world_data[current_room.y][current_room.x].area_color = area_color;
				world_grid.setCellColor(current_room.x, current_room.y, area_color);
				clearRoomLayers();
			}
			
			world_grid.positionCursor(current_room);
		}
		
		public function setCurrentTile(x:uint, y:uint):void
		{
			if (y < 0 || y > tileset_grid.rows_displayed) return;
			if (x < 0 || x > tileset_grid.cols_displayed) return;
			
			current_tile = tileset_grid.getTile(x, y);
			current_tile_coords = current_tile ? new Point(x, y) : null;
			
			// ToDo: Draw the selected tile to a FlxSprite. If it is null, just make the FlxSprite Black
			updateCurrentTileDisplay();
		}
		
		public function placeTile(x:uint, y:uint, remove:Boolean = false):void
		{
			//if (!current_tile) return;
			if (!world_data[current_room.y][current_room.x])
			{
				world_data[current_room.y][current_room.x] = new RoomData(nextRoomId(), room_rowsxcols.x, room_rowsxcols.y);
				world_grid.setCellColor(current_room.x, current_room.y, 0xFF0000FF);
			}
			
			if (!remove && current_tile)
			{
				room_layers[current_layer].setTile(x, y, current_tile);
				RoomData(world_data[current_room.y][current_room.x]).setTile(current_layer, new Point(x, y), tileset_grid.current_tileset.src, new Point(current_tile_coords.x,current_tile_coords.y));
			}
			else
			{
				room_layers[current_layer].setCellColor(x, y, 0x00000000);
				RoomData(world_data[current_room.y][current_room.x]).clearTile(current_layer, new Point(x, y));
			}
		}
		
		public function clearRoomLayers():void
		{
			for (var i:int = 0; i < room_layers.length; i++)
			{
				room_layers[i].clearGrid();
			}
		}
		
		public function updateCurrentTileDisplay():void
		{
			if (!current_tile_display) 
			{
				current_tile_display = new FlxSprite(tileset_grid.x + 270, tileset_grid.y + 10);
				var temp:FlxText = new FlxText(tileset_grid.x + 240, tileset_grid.y - 20, 150, "Selected Tile");
				temp.size = 12;
				add(temp);
				add(current_tile_display);
			}
			
			if (current_tile)
			{
				var scale_factor:Number = room_cell_size/current_tile.width;
				var tile:BitmapData = new BitmapData(room_cell_size, room_cell_size, true, 0x00000000);
				tile.draw(current_tile, new Matrix(scale_factor, 0, 0, scale_factor, 0, 0));
				var container:Bitmap = new Bitmap(tile);
				current_tile_display.loadExtGraphic(container, false, false, room_cell_size, room_cell_size, true);
			}
			else
			{
				current_tile_display.makeGraphic(room_cell_size, room_cell_size, 0xFF000000, true);
			}
		}
		
		public function scrollTilesets(dir:int):void
		{
			dir > 0 ? ++current_tileset : --current_tileset;
			current_tileset = current_tileset >= assets.tilesets.length ? 0 : (current_tileset < 0 ? assets.tilesets.length - 1 : current_tileset);
			
			tileset_grid.setTileset(assets.tilesets[current_tileset]);
			current_tile = tileset_grid.getTile(0, 0);
			current_tile_coords = new Point(0, 0);
			updateCurrentTileDisplay();
			tileset_text.text = "" + current_tileset;
		}
		
		public function changeLayers(dir:int):void
		{
			dir > 0 ? ++current_layer : --current_layer;
			current_layer = current_layer >= layer_count ? 0 : (current_layer < 0 ? layer_count - 1 : current_layer);
			
			setLayerVisibility();
			
			layer_text.text = "Layer: " + current_layer;
			/*
			tileset_grid.setTileset(assets.tilesets[current_tileset]);
			current_tile = tileset_grid.getTile(0, 0);
			current_tile_coords = new Point(0, 0);
			updateCurrentTileDisplay();
			tileset_text.text = "" + current_tileset;
			*/
		}
		public function toggleLayerTransparency():void
		{
			layer_visibility = ++layer_visibility >= 3 ? 0 : layer_visibility;
			
			setLayerVisibility();
			
			layer_visibility_button.label = new FlxText(0, 0, 300, "Layer Transparency: " + (layer_visibility == 0 ? "OFF" : (layer_visibility == 1 ? "PART" : "FULL")));
			layer_visibility_button.label.color = 0xFF000000;
		}
		
		public function setLayerVisibility():void
		{
			for (var i:int = 0; i < layer_count; i++)
			{
				if (layer_visibility == 0)
				{
					i == current_layer ? room_layers[i].show() : room_layers[i].hide();
					room_layers[i].grid_display.alpha = 1;
				}
				else if (layer_visibility == 1)
				{
					room_layers[i].show();
					var diff:int = Math.abs(current_layer - i);
					diff >= 0 && diff <= 2 ? room_layers[i].grid_display.alpha = (1 - diff * .3) : room_layers[i].hide();
				}
				else
				{
					room_layers[i].show();
					room_layers[i].grid_display.alpha = 1;
				}
			}
		}
		
		public function loadRoomLayers():void
		{
			for (var i:int = 0; i < layer_count; i++)
			{
				room_layers[i].loadRoomData(i, assets, world_data[current_room.y][current_room.x]);
			}
		}
		
		public function getTileData(rx:uint, ry:uint, tx:uint, ty:uint):TileData
		{
			return world_data[current_room.y][current_room.x].getTile(current_layer, new Point(tx, ty));
		}
		
		public function nextRoomId():uint
		{
			return ++next_roomid;
		}
		
		public function toggleRoomArea():void
		{
			selected_area = ++selected_area == 3 ? 0 : selected_area;
			switch(selected_area)
			{
				case 0:
					area_color = 0xFF0000FF;
					break;
				case 1:
					area_color = 0xFFFF0000;
					break;
				case 2:
					area_color = 0xFF00FF00;
					break;
			}
			
			world_data[current_room.y][current_room.x].area = selected_area;
			world_data[current_room.y][current_room.x].area_color = area_color;
			world_grid.setCellColor(current_room.x, current_room.y, area_color);
			area_button.makeGraphic(area_button_size, area_button_size, area_color, true);
			area_text.text = "Area: " + selected_area;
		}
		
		public function checkAreaButtonClick(x:int, y:int):void
		{
			if (x < area_button.x || x > area_button.x + area_button_size) return;
			if (y < area_button.y || y > area_button.y + area_button_size) return;
			
			toggleRoomArea();
		}
		
		public function saveAsXML():void
		{
			var xml:XML = <world>
							<assets>
							</assets>
							<rooms>
							</rooms>
						</world>;
			xml.@name = "Matt's World";
			xml.@tilesize = 16;
			xml.@width = room_rowsxcols.x;
			xml.@height = room_rowsxcols.y;
			
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var m:int;
			var xmlassets:XML = xml.assets[0];
			for (i = 0; i < assets.tilesets.length; i++)
			{
				var xmlasset:XML = <asset />;
				xmlasset.@src = assets.tilesets[i].src;
				xmlassets.appendChild(xmlasset);
			}
			
			var xmlrooms:XML = xml.rooms[0];
			for (i = 0; i < world_data.length; i++)
			{
				for (j = 0; j < world_data[i].length; j++)
				{
					var rd:RoomData = world_data[i][j];
					if (!rd) continue;
					var xmlroom:XML = <room>
									</room>;
					xmlroom.@id = "" + rd.room_id;
					xmlroom.@area = rd.area;
					xmlroom.@areacolor = rd.area_color;
					xmlroom.@roomx = j;
					xmlroom.@roomy = i;
					xmlroom.@left = (j != 0 && world_data[i][j - 1]) ? "" + world_data[i][j - 1].room_id : "";
					xmlroom.@up = (i != 0 && world_data[i - 1][j]) ? "" + world_data[i - 1][j].room_id : "";
					xmlroom.@right = (j != world_data[i].length && world_data[i][j + 1]) ? "" + world_data[i][j + 1].room_id : "";
					xmlroom.@down = (i != world_data.length - 1 && world_data[i + 1][j]) ? "" + world_data[i + 1][j].room_id : "";
					for (k = 0; k < rd.layer_data.length; k++)
					{
						var xmllayer:XML = <layer>
											</layer>;
						xmllayer.@number = "" + k;
						var layer:Vector.<Vector.<TileData>> = rd.layer_data[k];
						for (l = 0; l < layer.length; l++)
						{
							for (m = 0; m < layer[l].length; m++)
							{
								var tile:TileData = layer[l][m];
								if (!tile) continue;
								
								var xmltile:XML = <tile />;
								xmltile.@src = tile.src;
								xmltile.@x = m;
								xmltile.@y = l;
								xmltile.@tilex = "" + tile.coords.x;
								xmltile.@tiley = "" + tile.coords.y;
								xmllayer.appendChild(xmltile);
							}
						}
						
						xmlroom.appendChild(xmllayer);
					}
					xmlrooms.appendChild(xmlroom);
				}
			}
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(xml);
			
			var fr:FileReference = new FileReference();
			fr.save(ba, "mattsworld.xml");
		}
		
		public function loadXML():void
		{
			var filepath:String = assets.masterFilePath;
			var xml:XML;
			var loader:URLLoader = new URLLoader();
			
			loader.load(new URLRequest(filepath));
			loader.addEventListener(Event.COMPLETE, loadComplete);
			
			function loadComplete(e:Event):void
			{
				xml = XML(e.target.data);
				onComplete(xml);
			}
			
			function onComplete(xml:XML):void
			{
				var i:int;
				var j:int;
				
				world_data = new Vector.<Vector.<RoomData>>();
				for (i = 0; i < world_grid.rows_displayed; i++)
				{
					world_data.push(new Vector.<RoomData>());
					for (j = 0; j < world_grid.cols_displayed; j++)
					{
						world_data[i].push(null);
						world_grid.setCellColor(j, i, 0xFF000000);
					}
				}
				
				world_grid.clearGrid();
				
				var rooms:XML = xml.rooms[0];
				for each(var room:XML in rooms.room)
				{
					var rd:RoomData = new RoomData(room.@id, xml.@width, xml.@height);
					var roomx:int = room.@roomx;
					var roomy:int = room.@roomy;
					rd.area = room.@area;
					rd.area_color = room.@areacolor;
					
					for each(var layer:XML in room.layer)
					{
						var ln:uint = layer.@number;
						for each(var tile:XML in layer.tile)
						{
							rd.setTile(ln, new Point(tile.@x, tile.@y), tile.@src, new Point(tile.@tilex, tile.@tiley));
						}
					}
					
					world_data[roomy][roomx] = rd;
					world_grid.setCellColor(roomx, roomy, rd.area_color);
				}
				
				for (i = 0; i < world_data.length; i++)
				{
					for (j = 0; j < world_data[i].length; j++)
					{
						if (world_data[i][j]) 
						{
							setCurrentRoom(j, i);
							return;
						}
					}
				}
				
			}
		}
		
		
	}

}