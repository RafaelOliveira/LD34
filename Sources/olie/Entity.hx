package olie;

import kha.graphics2.Graphics;

class Entity
{
	public var x:Float;
	public var y:Float;
	
	var comps:Array<Component>;
	var renderComp:RenderComp;
	
	public var render:Graphics->Void;
	
	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
		
		comps = new Array<Component>();
	}
	
	inline public function addComp(comp:Component)
	{
		comp.entity = this;
		comps.push(comp);
	}
	
	public function setRender(renderComp:RenderComp, canUpdate:Bool = false)
	{
		this.renderComp = renderComp;
		renderComp.entity = this;
		
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