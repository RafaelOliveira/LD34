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
	
	public function render(g:Graphics)
	{
		g.drawScaledSubImage(reg.image, reg.sx, reg.sy,
							reg.width, reg.height,
							entity.x, entity.y,
							reg.width, reg.height);
	}
}