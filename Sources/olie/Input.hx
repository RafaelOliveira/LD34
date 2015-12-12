package olie;

import kha.input.Keyboard;
import kha.Key;

class Input
{
	static var keysHeld:Map<String, Bool>;
	static var keysPressed:Map<String, Bool>;
	
	public static function setup()
	{
		keysHeld = new Map<String, Bool>();
		keysPressed = new Map<String, Bool>();
		
		var keyboard = Keyboard.get();
		keyboard.notify(keyDown, keyUp);
	}
	
	static function keyDown(key:Key, char:String)
	{
		if (key == Key.CHAR)
		{
			keysHeld.set(char, true);
			keysPressed.set(char, true);
		}
		else
		{
			keysHeld.set(key.getName().toLowerCase(), true);
			keysPressed.set(key.getName().toLowerCase(), true);
		}
	}
	
	static function keyUp(key:Key, char:String)
	{
		if (key == Key.CHAR)
			keysHeld.set(char, false);
		else
			keysHeld.set(key.getName().toLowerCase(), false);
	}
	
	public static function update()
	{		
		for (key in keysPressed.keys())
			keysPressed.remove(key);
	}
	
	inline public static function check(key:String)
	{
		return keysHeld.get(key);
	}
	
	inline public static function pressed(key:String)
	{
		return keysPressed.exists(key);		
	}
}