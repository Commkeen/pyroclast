package org.pyroclast.editor
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.pyroclast.system.*;
	
	public class FlxGrid
	{
		private var grid:FlxTilemap;						// This is the FlxSprite to which the grid bitmap data will be drawn
		private var grid_holder:FlxGroup; //Holds the grid in the overall grid_group FlxGroup, since we will be creating the grid anew a fair amount of the time...
		public var overlay:FlxSprite;							// This will be the grid overlay for drawing lines
		public var grid_group:FlxGroup;							// The group that contains all of the objects in this grid....for ease of adding to the playstate
		public var current_tileset:LoadedImage;					// The tileset currently associated with this grid
		public var tileset_dimensions:Point;					// The dimensions of the current tileset (in number of tiles)
		//public var tile_coords:Vector.<Vector.<Point>>;			// An array storing the coordinates from which each tile's bitmap was extracted (coordinates represent how many horizontal and vertical tiles the tile is offset by)
		public var cursor:GridCursor;							// The cursor used to highlight a selected cell
		
		public var x:int;
		public var y:int;
		public var screenX:int;
		public var screenY:int;
		public var width:uint;
		public var height:uint;
		public var cell_size:uint;								// All cells will be cell_size x cell_size pixels...let's keep em' squares
		public var rows_displayed:uint;							// Both the number of rows visible at a time as well as the initial number of rows created
		public var cols_displayed:uint;							// Both the number of columns visible at a time as well as the initial number of columns created
		
		public var drag_selectable:Boolean = false;				// Can the user select cells just by clicking and dragging?
		public var scrollable:Boolean = false;					// Can the user scroll within the grid?
		public var xoffset:int = 0;
		public var yoffset:int = 0;
		
		public var onClickCallback:Function;					// What happens when this frame is clicked
		
		public function FlxGrid(X:int, Y:int, w:uint, h:uint, cs:uint, bg_color:uint = 0xFF000000)
		{
			x = screenX = X;
			y = screenY = Y;
			cell_size = cs;
			width = w - (w % cell_size) + 1;
			height = h - (h % cell_size) + 1;
			
			cols_displayed = uint(width / cell_size);
			rows_displayed = uint(height / cell_size);
			//trace(cols_displayed + ", " + rows_displayed);
			
			setupGrid(bg_color);
		}
		
		public function handleClick(mx:uint,my:uint):void
		{
			if (hidden()) return;
			//trace(mx + ", " + my + ", " + x + ", " + y + ", " + (x + width) + ", " + (y + height));
			if (mx < x || mx >= x + width - 1) return;
			if (my < y || my >= y + height - 1) return;
			
			var xindex:uint = uint(uint(mx - x) / cell_size) + xoffset;
			var yindex:uint = uint(uint(my - y) / cell_size) + yoffset;
			
			if (xindex < 0 || xindex >= cols_displayed) return;
			if (yindex < 0 || yindex >= rows_displayed) return;
			//if (!grid[yindex][xindex].visible) return;
			
			if (this.onClickCallback)
				onClickCallback(new Point(xindex, yindex));
				
			cursor.setPosition(x + xindex * cell_size, y + yindex * cell_size);
		}
		
		
		
		public function setupGrid(bg_color:uint):void
		{
			grid = new FlxTilemap();
			grid.loadMap("0,0,0,0,0,0,0,0", AssetLoader.tilesets[0].img, 16, 16);
			grid_holder = new FlxGroup();
			grid_group = new FlxGroup();
			
			grid_holder.add(grid);
			grid_group.add(grid_holder);
			
			overlay = new FlxSprite(x, y);
			overlay.width = width;
			overlay.height = height;
			overlay.origin = new FlxPoint(0, 0);
			overlay.makeGraphic(width, height, 0x00000000, true);
			
			var i:int; 
			for (i = 0; i < rows_displayed+1; i++)
			{
				var vpos:int = cell_size * i;
				overlay.drawLine(0, vpos, width, vpos, 0xFFFFFFFF, 1);
			}
			for (i = 0; i < cols_displayed+1; i++)
			{
				var hpos:int = cell_size * i;
				overlay.drawLine(hpos, 0, hpos, height, 0xFFFFFFFF, 1);
			}
			grid_group.add(overlay);
			
			cursor = new GridCursor(cell_size, cell_size);
			cursor.setPosition(x, y);
			grid_group.add(cursor.cursor);
		}
		
		// ToDo: Modify this function to take in the resolution of the tiles in the tileset. This will then be used to decide whether and how much 
		// the tileset is upscaled to match the resolution of the grid cells.
		
		/**
		 * Sets this FlxGrid to display the tileset passed to it.
		 * @param	image
		 */
		public function loadTilesetOnGrid(image:LoadedImage):void
		{
			//Set up a tilemap
			var arr:Array = new Array();
			for (var i:int = 0; i < rows_displayed * cols_displayed; i++)
			{
				arr.push(i);
			}
			grid_holder.remove(grid);
			grid = new FlxTilemap();
			grid.loadMap(FlxTilemap.arrayToCSV(arr, cols_displayed), image.img, 16, 16, FlxTilemap.OFF, 0, 0);
			grid_holder.add(grid);
			grid.x = x;
			grid.y = y;
			current_tileset = image;
			
			tileset_dimensions = new Point(Math.round(width / cell_size), Math.round(height / cell_size));
		}
		
		/*
		public function redisplayGrid():void
		{
			var container:Bitmap = new Bitmap(grid);
			grid_display.loadExtGraphic(container, false, false, grid.width, grid.height, true);
		}
		*/
		
		
		public function setCellColor(j:uint, i:uint, color:uint):void
		{
			
		}
		
		public function clearGrid():void
		{
			//trace("Grid Cleared!");
			for (var i:int = 0; i < grid.totalTiles; i++)
			{
				grid.setTileByIndex(i, 0);
			}
		}
		
		public function loadLayerOnGrid(layer:uint, data:RoomData):void
		{
			clearGrid();
			
			var tile_data:Array = data.layer_data[layer];
			if (data.layer_tilesets[layer] == null || data.layer_tilesets[layer] == "")
			{
				data.layer_tilesets[layer] = AssetLoader.tilesets[0].src;
			}
			var tileset_image:Class = AssetLoader.getTilesetBySrc(data.layer_tilesets[layer]).img;
			grid_holder.remove(grid);
			grid = new FlxTilemap();
			grid.loadMap(FlxTilemap.arrayToCSV(tile_data, data.width), tileset_image as Class, 16, 16);
			grid_holder.add(grid);
			grid.x = x;
			grid.y = y;
		}
		
		
		public function setTileIndexAtPosition(pos:Point, index:int):void
		{
			grid.setTile(pos.x, pos.y, index);
		}
		
		public function getTileIndexAtPosition(pos:Point):int
		{
			return grid.getTile(pos.x, pos.y);
		}
		
		/*****************************************************
		 * 	
		 * 					Cursor Fuctions
		 * 
		 ****************************************************/
		 public function updateCursor():void
		{
			cursor.update();
		}
		
		public function positionCursor(p:Point):void
		{
			cursor.setPosition(x + p.x*cell_size,y + p.y*cell_size);
		}
		
		public function showCursor():void
		{
			cursor.activate(true);
			cursor.setPosition(x, y);
		}
		
		public function hideCursor():void
		{
			cursor.activate(false);
		}
		
		public function cursorActive():Boolean
		{
			return cursor.active();
		}
		
		
		/*****************************************************
		 * 	
		 * 					Visibility Fuctions
		 * 
		 ****************************************************/
		public function show():void
		{
			grid_group.visible = true;
		}
		
		public function hide():void
		{
			grid_group.visible = false;
		}
		
		public function hidden():Boolean
		{
			return !grid_group.visible;
		}
		
		public function toggleGridlines():void
		{
			overlay.visible = !overlay.visible;
		}
		
		
		//TODO: Both of these functions need to be adjusted for zooming and scale and stuff
		public function getRelativeMousePosition(absoluteMousePosition:Point):Point
		{
			var relativePosition:Point = new Point(absoluteMousePosition.x - screenX, absoluteMousePosition.y - screenY);
			return relativePosition;
		}
		
		public function getHighlightedGridCoordinates(absoluteMousePosition:Point):Point
		{
			var relativePosition:Point = getRelativeMousePosition(absoluteMousePosition);
			return new Point(relativePosition.x / 16, relativePosition.y / 16);
		}
	}
	
}