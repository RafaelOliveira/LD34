package scenes;

import kha.Color;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import olie.Input;
import olie.Scene;

class Play extends Scene
{
	var bgPanelColor = Color.fromValue(0xff778899);
	var bgRoulleteColor = Color.fromValue(0xff6495ed);
	
	var tempPiece:Piece;
	var lastPiece:Piece;
	
	var leftRoulette:Roulette;
	var rightRoulette:Roulette;
	
	public function new() 
	{
		super();
		
		Roulette.setup();
		
		leftRoulette = new Roulette(0);
		rightRoulette = new Roulette(1);
		
		add(leftRoulette);
		add(rightRoulette);
		
		lastPiece = new Piece(2, Face.Top);
		lastPiece.tx = 6;
		lastPiece.ty = 8;
		add(lastPiece);
		
		tempPiece = new Piece(1);
		
		leftRoulette.start();
		rightRoulette.start();		
	}
	
	override public function update() 
	{
		super.update();
		
		if (Input.pressed('left'))
		{
			tempPiece.changeFreePiece(leftRoulette.id);
			if (lastPiece.addPiece(tempPiece))
			{
				lastPiece = tempPiece;
				tempPiece = new Piece(1);
			}
				
		}
		else if (Input.pressed('right'))
		{
			tempPiece.changeFreePiece(rightRoulette.id);
			if (lastPiece.addPiece(tempPiece))
			{
				lastPiece = tempPiece;
				tempPiece = new Piece(1);
			}
		}
	}
	
	override public function render(g:Graphics) 
	{
		g.color = bgPanelColor;
		g.fillRect(0, 540, 800, 60);
		
		g.color = bgRoulleteColor;
		g.fillRect(335, 540, 60, 60);
		g.fillRect(405, 540, 60, 60);
		
		g.color = Color.White;
		
		super.render(g);
	}
}