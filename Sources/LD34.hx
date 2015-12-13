package;

import kha.Assets;
import kha.graphics2.Graphics;
import kha.graphics2.ImageScaleQuality;
import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;
import olie.Olie;
import scenes.Play;

class LD34 
{	
	var backbuffer:Image;
	var g:Graphics;		

	public function new() 
	{	
		Assets.loadEverything(loadingFinished);		
	}
	
	private function loadingFinished():Void 
	{
		backbuffer = Image.createRenderTarget(800, 600);
		g = backbuffer.g2;
	
		Olie.setup();
		Olie.scene = new Play();
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}
	
	public function update()
	{		
		Olie.update();
	}

	public function render(framebuffer:Framebuffer):Void 
	{
		framebuffer.g2.imageScaleQuality = ImageScaleQuality.High;
		
		// clear our backbuffer using graphics2
		g.begin(Color.White);
		Olie.scene.render(g);
		g.end();

		// draw our backbuffer onto the active framebuffer
		framebuffer.g2.begin();		
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}
}