package;

import olie.Atlas;
import olie.Entity;
import olie.Olie;
import olie.RenderComp;

class Piece extends Entity
{
	public var id:Int;
	public var face1:Face;
	public var face2:Face;
	
	/** Available face */
	public var avFace:Face;
	
	public var tx(get, set):Int;
	public var ty(get, set):Int;
	
	public function new(id:Int, avFace:Face = null)
	{
		super();
		
		this.id = id;
		this.avFace = avFace;
		setupFaces();
		setRender(new RenderComp(Atlas.get('piece$id')));
	}
	
	function setupFaces()
	{
		switch(id)
		{
			case 1:
				face1 = Face.Left;
				face2 = Face.Right;
			case 2:
				face1 = Face.Top;
				face2 = Face.Bottom;
			case 3:
				face1 = Face.Bottom;
				face2 = Face.Right;
			case 4:
				face1 = Face.Left;
				face2 = Face.Bottom;
			case 5:
				face1 = Face.Top;
				face2 = Face.Right;
			case 6:
				face1 = Face.Left;
				face2 = Face.Top;
		}
	}
	
	function get_tx():Int 
	{
		return Std.int((x - 10) / 60);
	}
	
	function set_tx(value:Int):Int 
	{
		x = (value * 60) + 10;
		
		return value;
	}
	
	function get_ty():Int 
	{
		return Std.int(y / 60);
	}
	
	function set_ty(value:Int):Int 
	{
		y = value * 60;
		
		return value;
	}	
	
	public function addPiece(another:Piece):Bool
	{
		switch(avFace)
		{
			case Face.Top:
				if (another.face1 == Face.Bottom || another.face2 == Face.Bottom)
				{
					Olie.scene.add(another);
					another.x = x;
					another.y = y - 60;
					
					if (another.face1 == Face.Bottom)
						another.avFace = another.face2;
					else
						another.avFace = another.face1;
					
					return true;
				}
			case Face.Bottom:
				if (another.face1 == Face.Top || another.face2 == Face.Top)
				{
					Olie.scene.add(another);
					another.x = x;
					another.y = y + 60;
					
					if (another.face1 == Face.Top)
						another.avFace = another.face2;
					else
						another.avFace = another.face1;
						
					return true;
				}
			case Face.Left:
				if (another.face1 == Face.Right || another.face2 == Face.Right)
				{
					Olie.scene.add(another);
					another.x = x - 60;
					another.y = y;
					
					if (another.face1 == Face.Right)
						another.avFace = another.face2;
					else
						another.avFace = another.face1;
						
					return true;
				}
			case Face.Right:
				if (another.face1 == Face.Left || another.face2 == Face.Left)
				{
					Olie.scene.add(another);
					another.x = x + 60;
					another.y = y;
					
					if (another.face1 == Face.Left)
						another.avFace = another.face2;
					else
						another.avFace = another.face1;
					
					return true;
				}
		}
		
		return false;
	}
	
	public function changeFreePiece(newId:Int)
	{
		id = newId;
		avFace = null;
		setupFaces();
		renderComp.reg = Atlas.get('piece$id');
	}
}