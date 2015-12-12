package olie;

import kha.graphics2.Graphics;

class Scene
{
	var entities:Array<Entity>;	
	
	public function new() 
	{
		entities = new Array<Entity>();
	}
	
	public function add(entity:Entity)
	{
		entities.push(entity);
	}
	
	public function update()
	{
		for (entity in entities)
			entity.update();
	}
	
	public function render(g:Graphics)
	{
		for (entity in entities)
		{
			if (entity.render != null)
				entity.render(g);
		}
	}	
}