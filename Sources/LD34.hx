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
	var initialized: Bool = false;

	public function new() 
	{	
		Assets.loadEverything(loadingFinished);		
	}
	
	private function loadingFinished():Void 
	{
		initialized = true;
		
		backbuffer = Image.createRenderTarget(800, 600);
		g = backbuffer.g2;
		g.font = Assets.fonts.HelvetiPixel;		
	
		Olie.setup();
		Olie.scene = new Play();		
	}
	
	public function update()
	{	
		if (!initialized)
			return;
			
		Olie.update();
	}

	public function render(framebuffer:Framebuffer):Void 
	{
		if (!initialized)
			return;
		
		//framebuffer.g2.imageScaleQuality = ImageScaleQuality.High;
		
		// clear our backbuffer using graphics2
		g.begin(Color.fromValue(0xff00bfff));
		Olie.scene.render(g);
		g.end();

		// draw our backbuffer onto the active framebuffer
		framebuffer.g2.begin();		
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}
}