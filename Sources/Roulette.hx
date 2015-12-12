package;

import kha.Scheduler;
import olie.Atlas;
import olie.Entity;
import olie.Region;
import olie.RenderComp;

class Roulette extends Entity
{	
	static var pieces:Array<Region>;
	
	public var id:Int;
	
	public function new(pos:Int) 
	{
		// left
		if (pos == 0)
			super(335, 540);
		// right
		else
			super(405, 540);
			
		id = getNewId();	
			
		var reg = Atlas.get('piece$id');
		setRender(new RenderComp(reg));
	}
	
	public static function setup()
	{
		pieces = new Array<Region>();
		for (i in 0...6)
			pieces.push(Atlas.get('piece${i + 1}'));
	}
	
	public inline function start()
	{
		Scheduler.addTimeTask(switchPiece, 0, 1);
	}
	
	inline function switchPiece()
	{
		id = getNewId();		
		renderComp.reg = pieces[id - 1];
	}
	
	function getNewId()
	{
		return Std.int(Math.random() * pieces.length) + 1;
	}
}