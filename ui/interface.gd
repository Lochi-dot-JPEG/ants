extends Control

@onready var panel :PanelContainer= %MenuPanel

func _ready() -> void:
	Input.set_custom_mouse_cursor(Load.mouse)
	panel.mouse_entered.connect(_mouse_on_panel.bind(true))
	panel.mouse_exited.connect(_mouse_on_panel.bind(false))

func _add_items_to_panel(items : Array):
	pass


func _mouse_on_panel(is_on):
	if is_on:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


