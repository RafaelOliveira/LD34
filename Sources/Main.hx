package;

import kha.Scheduler;
import kha.System;

class Main 
{
	public static function main() 
	{
		System.init('LD34', 800, 600, function() 
		{
			var game = new LD34();
			System.notifyOnRender(game.render);
			Scheduler.addTimeTask(game.update, 0, 1 / 60);
		});
	}	
}