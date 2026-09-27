extends Control

func _ready() -> void:
	%Levels.pressed.connect(_levels)
	%Play.pressed.connect(_play)

func _process(delta: float) -> void:
	%Camera2D.position.x += delta * 100

func _play() -> void:
	Load._open_level(0)


func _levels() -> void:
	pass

# TODO
