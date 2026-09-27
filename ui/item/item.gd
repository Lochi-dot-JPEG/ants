class_name ItemPanel
extends VBoxContainer

@export var button : Button

var type : Load.Items = Load.Items.BOUNCE
var amount := 0

func _Set_Highlight(highlighted : bool) -> void:
	button.button_pressed = highlighted

func _Set_Type(_type : Load.Items) -> void:
	type = _type
	_Update_Text()

func _Set_Amount(new_amount : int) -> void:
	amount = new_amount
	_Update_Text()

func _Update_Text() -> void:
	button.text = Load.items[type].name + ": " + str(amount)

func _Set_Text(text) -> void:
	$Button.text = text

func _Set_Texture(texture) -> void:
	$TextureRect.texture = texture

