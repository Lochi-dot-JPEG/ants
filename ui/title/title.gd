extends Node

func _ready() -> void:
	Input.set_custom_mouse_cursor(Load.mouse)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%Levels.pressed.connect(_levels)
	%Play.pressed.connect(_play)
	%Back.pressed.connect(_back)
	for level in Load.levels.size():
		var _button = Button.new()
		_button.text = str(level)
		_button.pressed.connect(Load._open_level.bind(level))
		%LevelSelect.add_child(_button)



func _process(delta: float) -> void:
	%Camera2D.position.x += delta * 100

func _play() -> void:
	Load._open_level(0)


func _levels() -> void:
	%Menu.hide()
	%LevelSelect.show()

func _back() -> void:
	%Menu.show()
	%LevelSelect.hide()
