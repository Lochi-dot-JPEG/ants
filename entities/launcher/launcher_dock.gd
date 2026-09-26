class_name LauncherDock
extends Area2D

@export var bounds : CollisionShape2D
@onready var cursor = $LauncherCursor

var active = true
var launcher_dock : LauncherDock

const SPEED = 150

func _ready() -> void:
	add_to_group("dock")
	cursor.hide()


func _dock(player: CharacterBody2D) -> void:
	cursor.show()
	player._freeze()
	active = true

func _undock(player: CharacterBody2D) -> void:
	cursor.hide()
	player._unfreeze()
	active = false

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


func _physics_process(delta: float) -> void:
	if not active:
		return
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	cursor.global_position = _clamp_in_bounds(cursor.global_position + direction * delta * SPEED)
