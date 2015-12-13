package olie;

import kha.graphics2.Graphics;
import kha.System;

class Scene
{
	var entities:Array<Array<Entity>>;
	public var camera:Camera;
	
	public function new() 
	{
		entities = new Array<Array<Entity>>();
		camera = new Camera(System.pixelWidth, System.pixelHeight);
	}
	
	public function add(entity:Entity, level:Int = 0)
	{
		if (entities[level] == null)
			entities[level] = new Array<Entity>();
		
		entities[level].push(entity);
	}
	
	public function removeByType(level:Int, type:String)
	{
		for (entity in entities[level])
		{
			if (entity.type == type)			
				entities[level].remove(entity);			
		}
	}
	
	public function getEntities(level:Int):Array<Entity>
	{
		return entities[level];
	}
	
	public function getEntitiesByType(level:Int, type:String):Array<Entity>
	{
		var listEntities = new Array<Entity>();
		
		for (entity in entities[level])
		{
			if (entity.type == type)
				listEntities.push(entity);
		}
		
		return listEntities;
	}
	
	public function update()
	{
		for (i in 0...entities.length)
		{
			for (entity in entities[i])
				entity.update();
		}
	}
	
	public function render(g:Graphics)
	{
		for (i in 0...entities.length)
		{
			for (entity in entities[i])
			{
				if (entity.render != null && entity.visible)			
					entity.render(g, entity.fixedCamX ? 0 : camera.x, entity.fixedCamY ? 0 : camera.y);
			}	
		}		
	}	
}