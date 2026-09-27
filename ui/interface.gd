extends Control

@onready var panel :PanelContainer= %MenuPanel

@export var items : Dictionary[Load.Items, int] = {Load.Items.BOUNCE: 1, Load.Items.SWING: 1}
@export var item_container : Control
@export var dock : Node2D
@export var world_items_parent: Node2D


var selected_item_panel : ItemPanel
var selected_item: Load.Items

const ITEM_PANEL = preload("res://ui/item/item.tscn")

func _ready() -> void:
	Input.set_custom_mouse_cursor(Load.mouse)
	panel.mouse_entered.connect(_mouse_on_panel.bind(true))
	panel.mouse_exited.connect(_mouse_on_panel.bind(false))
	_add_items_to_panel()

func _shoot_item() -> void:
	var new_item = Load.items[selected_item].item_node.instantiate()
	print("shoots")
	world_items_parent.add_child(new_item)
	new_item.global_position = dock.cursor.global_position


func _add_items_to_panel():
	for i in item_container.get_children():
		i.queue_free()
	var first_item = null
	for key in items.keys():
		var new_item :ItemPanel = ITEM_PANEL.instantiate()
		var item_info = Load.items[key]
		var quantity = items[key]
		new_item._Set_Type(key)
		new_item._Set_Amount(quantity)
		new_item._Set_Texture(item_info.texture)
		new_item.button.pressed.connect(_select_item.bind(new_item))
		item_container.add_child(new_item)
		if first_item == null:
			first_item = new_item


func _select_item(item_node : ItemPanel):
	if selected_item_panel != null:
		selected_item_panel._Set_Highlight(false)
	selected_item_panel = item_node
	selected_item_panel._Set_Highlight(true)
	selected_item = item_node.type


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot_item()

func _mouse_on_panel(is_on):
	if is_on:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


