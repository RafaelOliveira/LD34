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
}