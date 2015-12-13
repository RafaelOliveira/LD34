package olie;

import kha.graphics2.Graphics;

class RenderComp extends Component
{
	public var reg:Region;
	
	public function new(region:Region) 
	{
		super();
		
		reg = region;		
	}
	
	public function render(g:Graphics, cx:Float, cy:Float)
	{
		g.drawScaledSubImage(reg.image, reg.sx, reg.sy,
							reg.width, reg.height,
							entity.x - cx, entity.y - cy,
							reg.width, reg.height);
	}
}