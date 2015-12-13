package scenes;

import kha.Color;
import kha.graphics2.Graphics;
import kha.Image;
import kha.input.Keyboard;
import kha.System;
import olie.Atlas;
import olie.Entity;
import olie.Input;
import olie.RenderComp;
import olie.Scene;

class Play extends Scene
{
	var bgPanelColor = Color.fromValue(0xff778899);
	var bgRoulleteColor = Color.fromValue(0xff6495ed);
	
	var tempPiece:Piece;
	var firstPiece:Piece;
	var lastPiece:Piece;
	
	var leftRoulette:Roulette;
	var rightRoulette:Roulette;
	
	var bush:Entity;
	var gameOverMsg:Entity;
	
	var halfScrHeight:Int;
	
	var plantHeight:Float;
	
	var isGameover:Bool;
	
	public function new() 
	{
		super();
		
		halfScrHeight = Std.int((System.pixelHeight - 60) / 2);
		camera.height = System.pixelHeight - 60;
		
		Roulette.setup();
		
		leftRoulette = new Roulette(0);
		rightRoulette = new Roulette(1);
		
		// setup plant's vase
		var regVase = Atlas.get('vase');
		var vase = new Entity(Std.int((System.pixelWidth / 2) - (regVase.width / 2)), 540 - regVase.height);
		vase.setRender(new RenderComp(regVase));
		add(vase);
		
		lastPiece = new Piece(2, Face.Top, true);
		lastPiece.x = (System.pixelWidth / 2) - 30;
		lastPiece.y = vase.y - 60;
		firstPiece = lastPiece;
		add(lastPiece);
		
		// setup bush
		var regBush = Atlas.get('bush');
		bush = new Entity(lastPiece.x + (lastPiece.width / 2) - (regBush.width / 2), lastPiece.y - regBush.height + 10);
		bush.setRender(new RenderComp(regBush));
		add(bush, 1);
		
		// setup game over msg
		var regGameOver = Atlas.get('game_over');
		gameOverMsg = new Entity(Std.int((System.pixelWidth / 2) - (regGameOver.width / 2)), Std.int((System.pixelHeight / 2) - (regGameOver.height / 2)));
		gameOverMsg.setRender(new RenderComp(regGameOver));
		gameOverMsg.visible = false;
		add(gameOverMsg, 1);
		
		tempPiece = new Piece(1);
		
		leftRoulette.start();
		rightRoulette.start();
		
		plantHeight = lastPiece.y;
		isGameover = false;
	}
	
	function reset()
	{		
		removeByType(0, 'piece');
		lastPiece = firstPiece;
		
		bush.x = lastPiece.x + (lastPiece.width / 2) - (bush.width / 2);
		bush.y = lastPiece.y - bush.height + 10;
		
		camera.y = 0;
		
		gameOverMsg.visible = false;
		isGameover = false;
		
		leftRoulette.pause(false);
		rightRoulette.pause(false);
	}
	
	override public function update() 
	{
		super.update();
		
		if (!isGameover)
		{
			if (Input.pressed('left'))
			{
				tempPiece.changeFreePiece(leftRoulette.id);
				addPiece();				
			}
			else if (Input.pressed('right'))
			{
				tempPiece.changeFreePiece(rightRoulette.id);
				addPiece();
			}
		}
		else if (Input.pressed('enter'))
			reset();
	}
	
	function addPiece()
	{
		if (lastPiece.addPiece(tempPiece))
		{
			lastPiece = tempPiece;
			
			if (lastPiece.y < plantHeight)
				plantHeight = lastPiece.y;
			
			switch(lastPiece.avFace)
			{
				case Face.Top:
					bush.x = lastPiece.x + (lastPiece.width / 2) - (bush.width / 2);
					bush.y = lastPiece.y - bush.height + 10;
				case Face.Bottom:
					bush.x = lastPiece.x + (lastPiece.width / 2) - (bush.width / 2);
					bush.y = lastPiece.y + lastPiece.height - 10;
				case Face.Left:
					bush.x = lastPiece.x - bush.width + 10;
					bush.y = lastPiece.y + (lastPiece.height / 2) - (bush.height / 2);
				case Face.Right:
					bush.x = lastPiece.x + lastPiece.width - 10;
					bush.y = lastPiece.y + (lastPiece.height / 2) - (bush.height / 2);
			}
			
			if (plantHeight < halfScrHeight)
				camera.y = plantHeight - halfScrHeight;
				
			tempPiece = new Piece(1);
				
			if (checkCollision())
			{
				isGameover = true;
				gameOverMsg.visible = true;
				leftRoulette.pause(true);
				rightRoulette.pause(true);
			}
		}
	}
	
	function checkCollision():Bool
	{
		if ((lastPiece.x - 60) < camera.x || (lastPiece.x + lastPiece.width + 60) > (camera.x + camera.width) || (lastPiece.y + lastPiece.height + 60) > (camera.y + camera.height))
		{			
			return true;
		}
		else
		{		
			var entities = getEntities(0);
			var x:Float = 0;
			var y:Float = 0;
			
			switch(lastPiece.avFace)
			{
				case Face.Top:
					y = -60; 				
				case Face.Bottom:
					y = 60;				
				case Face.Left:
					x = -60;				
				case Face.Right:
					x = 60;				
			}
			
			for (entity in entities)
			{
				if (lastPiece.checkBoxCollision(entity, x, y))
					return true;				
			}
		}
		
		return false;
	}
	
	override public function render(g:Graphics) 
	{
		// draw the pieces
		g.color = Color.White;
		super.render(g);
		
		// draw the bottom panel
		g.color = bgPanelColor;
		g.fillRect(0, 540, 800, 60);
		
		// draw the roulettes bg
		g.color = bgRoulleteColor;
		g.fillRect(335, 540, 60, 60);
		g.fillRect(405, 540, 60, 60);
				
		// draw the roulettes
		g.color = Color.White;
		leftRoulette.render(g, 0, 0);
		rightRoulette.render(g, 0, 0);		
	}
}