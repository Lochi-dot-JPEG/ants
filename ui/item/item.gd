class_name ItemPanel
extends VBoxContainer

@export var button : Button

func _Set_Text(text) -> void:
	$Button.text = text

func _Set_Texture(texture) -> void:
	$TextureRect.texture = texture

