package olie;

import kha.Assets;
import kha.Blob;

class Atlas
{	
	static var regions:Map<String, Region>;
	
	public static function setup() 
	{
		regions = new Map<String, Region>();
		
		var raw:Blob = Assets.blobs.resources_json;
		var data = haxe.Json.parse(raw.toString());
		
		var img = Assets.images.atlas;
		
		var frames = cast(data.frames, Array<Dynamic>);
		
		for (item in frames)
		{
			var reg = new Region(img, item.frame.x, item.frame.y, item.frame.w, item.frame.h);
			regions.set(item.filename, reg);
		}		
	}
	
	public static function get(name:String):Region
	{
		return regions.get(name);
	}
}