using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

public partial class SceneManager : Node
{
	[Export]
	Label coloredLabel;
	[Export]
	TextEdit labelTitle;
	[Export]
	Color[] colors;
	[Export]
	TextureRect shine;
	[Export]
	Color[] shineColors;

	[Export]
	ShaderMaterial[] artMaterials;
	[Export]
	TextureRect rimTexture;
	[Export]
	ShaderMaterial[] rimColors;
	[Export]
	int baseTextSize = 333;
	[Export]
	TextureRect cardArt;
	[Export]
	ColorPickerButton[] pickers;
	[Export]
	CompressedTexture2D[] cardBacks;
	[Export]
	TextureRect cardBack;
	[Export]
	ShaderMaterial[] cardBackShaders;
	[Export]
	ShaderMaterial[] textShaders;

	TextureRect[] damagedRects;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//Debug.Print($"Colored Label Rect Size: {coloredLabel.Size}");
		SetLabelSize();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	void SetLabelColors(int color)
	{
		if (color == 0)
		{
			coloredLabel.Material = textShaders[0];
			((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorB", colors[color*2]);
			((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorA", colors[(color*2)+1]);
			shine.Visible = false;
			foreach (ColorPickerButton picker in pickers) picker.Disabled = true;
		}
		if (color > 0 && color < 7)
		{
			coloredLabel.Material = textShaders[0];
			//var colorVariable = ((ShaderMaterial)coloredLabel.Material).GetShaderParameter("")
			((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorB", colors[color*2]);
			((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorA", colors[(color*2)+1]);
			shine.Visible = true;
			shine.SelfModulate = shineColors[color];
			foreach (ColorPickerButton picker in pickers) picker.Disabled = true;
		}else if (color == 7)
		{
			shine.Visible = true;
			coloredLabel.Material = textShaders[1];
			foreach (ColorPickerButton picker in pickers) picker.Disabled = false;
		}
		
	}

	void SetLabelSize()
	{
		float newscale = baseTextSize / coloredLabel.Size.X;
		if (newscale < 1)
		{
			coloredLabel.Scale = new Vector2(newscale, 1);
		}
	}

	void SetLabelText()
	{
		string newText = labelTitle.Text;
		coloredLabel.Text = newText;
		if (coloredLabel.Text.Length > 0)
			shine.Visible = true;
		else
			shine.Visible = false;
		SetLabelSize();
	}

	void _on_text_color_item_selected(int color) => SetLabelColors(color);
	void _on_foil_type_item_selected(int color)
	{
		if(color == 0)
		{
			cardArt.Material = null;
		}else if(color < artMaterials.Length)
		{
			if (artMaterials[color] != null)
			{
				cardArt.Material = artMaterials[color];
			}else
			{
				cardArt.Material = null;
			}
		}
		if(color > 3 && color < 7)
			cardBack.Material = cardBackShaders[0];
		else if(color == 3)
			cardBack.Material = cardBackShaders[1];
		else
					cardBack.Material = null;
	}

	void _on_rim_type_item_selected(int color)
	{
		if(color == 0)
		{
			((CanvasItem)rimTexture).Visible = false;
			rimTexture.SetProcess(false);
		}else if (color>0)
		{
			if (rimColors[color] == null)
			{
				Debug.Print("Unimplemented!");
				return;
			}
			((CanvasItem)rimTexture).Visible = true;
			rimTexture.SetProcess(true);
			rimTexture.Material = rimColors[color];
		}
	}

	void OnColorAChanged(Color color)
	{
		((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorA",color);
	}
	void OnColorBChanged(Color color)
	{
		((ShaderMaterial)coloredLabel.Material).SetShaderParameter("colorB",color);
	}

	void OnColorCChanged(Color color)
	{
		shine.SelfModulate = color;
	}

	void OnCardBackSelect(int id)
	{
		cardBack.Texture = cardBacks[id];
	}
}
