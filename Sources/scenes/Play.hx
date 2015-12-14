package scenes;

import kha.Color;
import kha.graphics2.Graphics;
import kha.Image;
import kha.input.Keyboard;
import kha.Scheduler;
import kha.System;
import olie.Atlas;
import olie.Entity;
import olie.Input;
import olie.Olie;
import olie.Region;
import olie.RenderComp;
import olie.Scene;
import tweenx909.TweenX;

class Play extends Scene
{
	inline static var MSG_START1:String = 'make your plant grow higher as possible';
	inline static var MSG_START2:String = 'press Left or Right to choose the next part';
	inline static var MSG_START3:String = 'but look for your time available';
	inline static var MSG_START4:String = 'each time you reach 10m you gain more time';
	
	inline static var MSG_START_AGAIN:String = 'press enter to start again';
	inline static var MSG_PLANT_GROW:String = 'your plant grew';
	
	var bgPanelColor = Color.fromValue(0xff708090);
	var bgRoulleteColor = Color.fromValue(0xff6495ed);
	
	var tempPiece:Piece;
	var firstPiece:Piece;
	var lastPiece:Piece;
	
	var leftRoulette:Roulette;
	var rightRoulette:Roulette;
	
	var bush:Entity;
	var vase:Entity;
	var regGameOver:Region;
	var regTitle:Region;
	var regLevelLine:Region;
	var regBg:Region;
	var regGround:Region;
	var regPanel:Region;
	
	var halfScrWidth:Int;
	var halfScrHeight:Int;
	
	var plantHeight:Float;
	
	// 0: init, 1: play: 2: game over
	var gameState:Int;
	
	var levelLineHeight:Int;
	
	var lastPieceLevel:Int;
	
	var gameTime:Int;
	var gameTimeTimer:Float;
	var msgFinalScore:String;
	
	public function new() 
	{
		super();
		
		halfScrWidth = Std.int(System.pixelWidth / 2);
		halfScrHeight = Std.int((System.pixelHeight - 60) / 2);
		camera.height = System.pixelHeight - 60;
		
		Roulette.setup();
		
		leftRoulette = new Roulette(0);
		rightRoulette = new Roulette(1);
		
		// setup plant's vase
		var regVase = Atlas.get('vase');
		vase = new Entity(Std.int(halfScrWidth - (regVase.width / 2)), 540 - regVase.height);
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
		regGameOver = Atlas.get('game_over');
		regGameOver.x = Std.int(halfScrWidth - (regGameOver.width / 2));
		regGameOver.y = Std.int((System.pixelHeight / 2) - (regGameOver.height / 2) - 40);
		
		regTitle = Atlas.get('title');
		regTitle.x = Std.int(halfScrWidth - (regTitle.width / 2));
		regTitle.y = regGameOver.y - 50;
		
		regLevelLine = Atlas.get('level_line');		
		regLevelLine.y = -60;
		levelLineHeight = 10;
		lastPieceLevel = 10;
		
		regBg = Atlas.get('bg');
		regGround = Atlas.get('ground');
		regPanel = Atlas.get('panel');
		
		tempPiece = new Piece(1);		
		
		plantHeight = lastPiece.y;
		gameState = 0;
		
		gameTime = 60;
		gameTimeTimer = Scheduler.time();
	}
	
	function reset()
	{
		// TODO: remove by level
		removeByType(0, 'piece');
		
		lastPiece = firstPiece;
		plantHeight = lastPiece.y;
		
		regLevelLine.y = -60;
		levelLineHeight = 10;
		
		bush.x = lastPiece.x + (lastPiece.width / 2) - (bush.width / 2);
		bush.y = lastPiece.y - bush.height + 10;
		
		camera.y = 0;
		
		gameState = 1;
		
		leftRoulette.pause(false);
		rightRoulette.pause(false);
		
		gameTime = 60;
	}
	
	override public function update() 
	{
		super.update();
		
		if (gameState == 0 && Input.pressed('enter'))
		{
			gameState = 1;
			leftRoulette.start();
			rightRoulette.start();
		}
		else if (gameState == 1)
		{
			if (Scheduler.time() > (gameTimeTimer + 1))
			{
				gameTimeTask();
				gameTimeTimer = Scheduler.time();
			}
			
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
			
			if (regLevelLine.y > (camera.y + camera.height))
			{
				regLevelLine.y -= 600;
				levelLineHeight += 10;				
			}
		}
		else if (gameState == 2 && Input.pressed('enter'))
			reset();
	}
	
	function gameTimeTask()
	{
		gameTime -= 1;
		
		if (gameTime == 0)
			callGameOver();
	}
	
	function addPiece()
	{
		if (lastPiece.addPiece(tempPiece))
		{
			lastPiece = tempPiece;
			
			if (lastPiece.y < plantHeight)
				plantHeight = lastPiece.y;
				
			if (lastPiece.y < regLevelLine.y && lastPieceLevel == levelLineHeight)
			{
				gameTime += 30;
				lastPieceLevel += 10;
			}			
			
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
			{
				TweenX.to(camera, { y: plantHeight - halfScrHeight }, 0.5);
				//camera.y = plantHeight - halfScrHeight;
			}
				
			tempPiece = new Piece(1);
				
			if (checkCollision())
				callGameOver();			
		}
	}
	
	function checkCollision():Bool
	{		
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
		
		if ((lastPiece.x + x) < camera.x || (lastPiece.x + lastPiece.width + x) > (camera.x + camera.width) || (lastPiece.y + lastPiece.height + y) > (camera.y + camera.height))					
			return true;		
		
		var entities = getEntities(0);
		
		for (entity in entities)
		{
			if (lastPiece.checkBoxCollision(entity, x, y))
			{
				trace('colisao por peca');
				return true;
			}
		}		
		
		return false;
	}
	
	function callGameOver()
	{
		gameState = 2;
		leftRoulette.pause(true);
		rightRoulette.pause(true);
		
		msgFinalScore = '$MSG_PLANT_GROW ${(vase.y - plantHeight) / 60}m';
	}
	
	override public function render(g:Graphics) 
	{
		renderBg(g);
		
		// draw the pieces		
		super.render(g);
		
		for (i in 0...8)
			g.drawScaledSubImage(regGround.image, regGround.sx, regGround.sy, regGround.width, regGround.height, 
								i * 100, 530 - camera.y, regGround.width, regGround.height); 
		
		// draw the level lines
		renderRegion(g, regLevelLine, true);
		g.color = Color.Black;
		g.fontSize = 20;
		g.drawString('${levelLineHeight}m', System.pixelWidth - g.font.width(20, '${levelLineHeight}m') - 5, regLevelLine.y + 5 - camera.y);
		
		// draw the bottom panel
		g.color = Color.White;		
		for (i in 0...10)
			g.drawScaledSubImage(regPanel.image, regPanel.sx, regPanel.sy, regPanel.width, regPanel.height, 
								i * 80, 540, regPanel.width, regPanel.height); 
		
		// draw the roulettes bg
		g.color = Color.fromValue(0xffb0c4de);
		g.fillRect(335, 540, 60, 60);
		g.fillRect(405, 540, 60, 60);
				
		// draw the roulettes
		g.color = Color.White;
		
		leftRoulette.render(g, 0, 0);		
		rightRoulette.render(g, 0, 0);
		
		g.fontSize = 40;
		g.drawString('$gameTime', System.pixelWidth - g.font.width(40, '$gameTime') - 10, 551);		
		
		if (gameState == 0)
		{
			g.color = Color.White;
			renderRegion(g, regTitle);
			
			g.color = Color.Black;
			g.fontSize = 22;
			g.drawString(MSG_START1, halfScrWidth - g.font.width(22, MSG_START1) / 2, regTitle.y + regTitle.height + 10);
			g.drawString(MSG_START2, halfScrWidth - g.font.width(22, MSG_START2) / 2, regTitle.y + regTitle.height + 30);
			g.drawString(MSG_START3, halfScrWidth - g.font.width(22, MSG_START3) / 2, regTitle.y + regTitle.height + 50);
			g.drawString(MSG_START4, halfScrWidth - g.font.width(22, MSG_START4) / 2, regTitle.y + regTitle.height + 70);
		}
		else if (gameState == 2)
		{
			g.color = Color.White;
			renderRegion(g, regGameOver);
			
			g.color = Color.Black;
			g.fontSize = 40;
			g.drawString(msgFinalScore, halfScrWidth - g.font.width(40, msgFinalScore) / 2, regGameOver.y + regGameOver.height + 10);
			g.drawString(MSG_START_AGAIN, halfScrWidth - g.font.width(40, MSG_START_AGAIN) / 2, regGameOver.y + regGameOver.height + 50);			
		}
		
		g.color = Color.White;
	}
	
	function renderBg(g:Graphics)
	{
		g.drawScaledSubImage(regBg.image, regBg.sx, regBg.sy, regBg.width, regBg.height, 
							regBg.x, regBg.y - camera.y, 800, regBg.height);
	}
}