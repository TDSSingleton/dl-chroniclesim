using Godot;
using System;

public partial class PatreonButton : TextureRect
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	void OnIconClick(InputEvent ev)
	{
		if(ev is InputEventMouseButton eventMouseButton && eventMouseButton.ButtonIndex == MouseButton.Left)
			OS.ShellOpen("https://www.patreon.com/c/eldaryon");
	}
}
