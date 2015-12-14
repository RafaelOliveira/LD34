package olie;

class Olie
{
	public static var scene:Scene;
	
	inline public static function setup()
	{
		Input.setup();
		Atlas.setup();
	}
	
	inline public static function update()
	{
		scene.update();
		Input.update();
	}
	
	public static function checkBoxCollision(x1:Float, y1:Float, w1:Int, h1:Int, x2:Float, y2:Float, w2:Int, h2:Int)
	{
		var a:Bool;
		var b:Bool;
		
		if (x1 < x2) a = x2 < x1 + w1;
		else a = x1 < x2 + w2;
		if (y1 < y2) b = y2 < y1 + h1;
		else b = y1 < y2 + h2;
		return a && b;
	}
}