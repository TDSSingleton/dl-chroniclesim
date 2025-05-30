using Godot;
using System;
using System.Diagnostics;

public partial class ImageFileDialog : FileDialog
{
	[Export]
	TextureRect imageTexture;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	void OnFileSelected(string path)
	{
		this.Visible = false;
		Debug.Print($"File Selected: {path}");
		var image = Image.LoadFromFile(path);
		imageTexture.Texture = ImageTexture.CreateFromImage(image);
	}
}
