using Godot;
using System;

public partial class DamagedScript : TextureRect
{
	// Called when the node enters the scene tree for the first time.
	[Export]
	CompressedTexture2D[] damagedImages;
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	void OnFoilSwitched(int foil)
	{
		if(foil == 10)
		{
			this.Visible = true;
			this.Texture = damagedImages[0];
		}
		else if (foil > 10 && foil < 13)
		{
			this.Visible = true;
			this.Texture = damagedImages[1];
		}
		else
		{
			this.Visible = false;
		}
		}
}
