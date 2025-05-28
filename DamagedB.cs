using Godot;
using System;

public partial class DamagedB : TextureRect
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	void OnFoilSwitch(int foil)
	{
		if(foil == 12)
			this.Visible = true;
		else
			this.Visible = false;
	}
}
