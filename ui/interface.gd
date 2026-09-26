extends Control

@onready var panel :PanelContainer= %MenuPanel

@export var items : Dictionary[Load.Items, int] = {Load.Items.BOUNCE: 1, Load.Items.SWING: 1}
@export var item_container : Control

const ITEM_PANEL = preload("res://ui/item/item.tscn")

func _ready() -> void:
	Input.set_custom_mouse_cursor(Load.mouse)
	panel.mouse_entered.connect(_mouse_on_panel.bind(true))
	panel.mouse_exited.connect(_mouse_on_panel.bind(false))
	_add_items_to_panel()


func _add_items_to_panel():
	for i in item_container.get_children():
		i.queue_free()
	for key in items.keys():
		var new_item :ItemPanel = ITEM_PANEL.instantiate()
		var item_info = Load.items[key]
		var quantity = items[key]
		new_item._Set_Text(item_info.name + ": " + str(quantity))
		new_item._Set_Texture(item_info.texture)
		item_container.add_child(new_item)



func _mouse_on_panel(is_on):
	if is_on:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


