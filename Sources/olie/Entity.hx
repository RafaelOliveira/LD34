package olie;

import kha.graphics2.Graphics;

class Entity
{
	public var x:Float;
	public var y:Float;
	public var width:Int;
	public var height:Int;
	
	public var fixedCamX:Bool = false;
	public var fixedCamY:Bool = false;
	
	public var visible:Bool;
	public var type:String;
	
	var comps:Array<Component>;
	var renderComp:RenderComp;
	
	public var render:Graphics->Float->Float->Void;
	
	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
		width = 0;
		height = 0;
		visible = true;
		
		comps = new Array<Component>();
	}
	
	inline public function addComp(comp:Component)
	{
		comp.entity = this;
		comps.push(comp);
	}
	
	public function checkBoxCollision(other:Entity, plusX:Float = 0, plusY:Float = 0):Bool
	{
		var a:Bool;
		var b:Bool;
		
		if ((x + plusX) < other.x) a = other.x < (x + plusX) + width;
		else a = (x + plusX) < other.x + other.width;
		if ((y + plusY) < other.y) b = other.y < (y + plusY) + height;
		else b = (y + plusY) < other.y + other.height;
		return a && b;
	}
	
	public function setRender(renderComp:RenderComp, canUpdate:Bool = false)
	{
		this.renderComp = renderComp;
		renderComp.entity = this;
		
		width = renderComp.reg.width;
		height = renderComp.reg.height;
		
		render = renderComp.render;
		
		if (canUpdate)
			comps.push(renderComp);
	}
	
	public function update()
	{
		for (comp in comps)
			comp.update();
	}
}