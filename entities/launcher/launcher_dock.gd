class_name LauncherDock
extends Area2D

const SPEED = 150

@export var bounds : CollisionShape2D

var active = true
var launcher_dock: LauncherDock
var camera: Camera2D
var creatures = []

@onready var spawn : Node2D = $CreatureSpawn
@onready var cursor = $LauncherCursor

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	add_to_group("dock")
	cursor.show()
	camera = Camera2D.new()
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	add_child(camera)
	camera.make_current()
	_camera_to_bounds()


func _input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed("test"):
		_test()
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("drag"):
			camera.global_position -= event.relative 
		cursor.global_position = event.global_position + camera.global_position


func _camera_to_bounds() -> void:
	var bounds_rect = bounds.shape.get_rect() 
	var center = bounds.global_position - (bounds_rect.size / 2)
	print(center)
	camera.global_position= center


func _in_bounds(_position) -> bool:
	var bounds_rect = bounds.shape.get_rect() 
	if bounds_rect.has_point(_position):
		return true
	return false


func _clamp_in_bounds(_position :Vector2) -> Vector2:
	var out = Vector2.ZERO
	var bounds_rect = bounds.shape.get_rect()
	var left = bounds_rect.position.x + bounds.global_position.x
	var right = left + bounds_rect.size.x
	var top = bounds_rect.position.y + bounds.global_position.y
	var bottom = top + bounds_rect.size.y
	out.x = clamp(_position.x,left,right)
	out.y = clamp(_position.y,top,bottom)
	return out


func _test() -> void:
	var new_creature = Load.creature.instantiate()
	creatures.append(new_creature)
	get_node("..").add_child(new_creature)
	new_creature.global_position = spawn.global_position
	new_creature._move_in_direction(1)
