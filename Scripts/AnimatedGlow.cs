using Godot;
using System;

public partial class AnimatedGlow : TextureRect
{
	Tween associatedTween;
	[Export]
	float[] assocPositions = {-134, 500};
	[Export]
	float runSpeed = 0.3f;
	[Export]
	float runtimeDelay = 3f;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

		associatedTween = CreateTween();
		associatedTween.TweenProperty(this, "position", new Vector2(assocPositions[1], 0), runSpeed);
		associatedTween.TweenCallback(Callable.From(SetToStart)).SetDelay(runtimeDelay);
		associatedTween.SetLoops();

	}

	void SetToStart() => Position = new Vector2(-134, 0);

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
