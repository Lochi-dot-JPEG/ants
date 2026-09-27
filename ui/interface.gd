extends Control

const ITEM_PANEL = preload("res://ui/item/item.tscn")

@export var items : Dictionary[Load.Items, int] = {Load.Items.BOUNCE: 1, Load.Items.SWING: 1, Load.Items.BOMB: 3}
@export var item_container : Control
@export var dock : Node2D
@export var world_items_parent: Node2D

var selected_item_panel : ItemPanel
var selected_item: Load.Items

@onready var panel : PanelContainer= %MenuPanel
@onready var restart : Button = %Restart
@onready var win_label : Control = %Win
@onready var exit : Button = %Exit
@onready var next_button : Button = %Next
@onready var title_button : Button = %Title

func _ready() -> void:
	#panel.mouse_entered.connect(_mouse_on_panel.bind(true))
	#panel.mouse_exited.connect(_mouse_on_panel.bind(false))
	_add_items_to_panel()
	restart.pressed.connect(_restart)
	exit.pressed.connect(_exit)
	dock.win.connect(_win)
	dock.teststart.connect(_start_test)
	dock.testend.connect(_end_test)
	next_button.pressed.connect(Load._next_level)
	title_button.pressed.connect(_exit)

	%TestOver.pressed.connect(dock._end_test)
	%Play.pressed.connect(Load.run_test.emit)

	Load.add_item.connect(_increase_item)

	win_label.hide()



func _process(_delta: float) -> void:
	if not panel.visible:
		return
	if get_global_mouse_position().y > panel.global_position.y:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _start_test():
	%TestOver.show()
	%Items.hide()


func _end_test():
	%TestOver.hide()
	%Items.show()


func _win() -> void:
	win_label.show()
	panel.hide()

func _shoot_item() -> void:
	if selected_item_panel == null:
		return
	if selected_item_panel.amount <= 0:
		return
	selected_item_panel._Set_Amount(selected_item_panel.amount - 1)
	var new_item = Load.items[selected_item].item_node.instantiate()
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


func _increase_item(item : Load.Items):
	for i in item_container.get_children():
		if i is ItemPanel and i.type == item:
			i._Set_Amount(i.amount+1)


func _select_item(item_node : ItemPanel):
	if selected_item_panel != null:
		selected_item_panel._Set_Highlight(false)
	selected_item_panel = item_node
	selected_item_panel._Set_Highlight(true)
	selected_item = item_node.type


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot_item()

#func _mouse_on_panel(is_on):
#	if is_on:
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	else:
#		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _restart(): 
	get_tree().reload_current_scene()

func _exit(): 
	get_tree().change_scene_to_file(Load.title)
	

