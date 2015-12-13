package olie;

class Camera
{
	public var x:Float;
	public var y:Float;
	public var width:Int;
	public var height:Int;
	
	public function new(width:Int, height:Int) 
	{
		x = 0;
		y = 0;
		this.width = width;
		this.height = height;
	}
	
	public function setSize(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
	}
}