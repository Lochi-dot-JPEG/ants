extends CharacterBody2D


const SPEED = 250.0
const DECELERATION = 1600.0
const ACCELERATION = 800.0
const TURN_ACCELERATION = 2600.0
const JUMP_VELOCITY = -280.0
const BOUNCE_VELOCITY = -500.0

var camera : Camera2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var overlap : Area2D = $OverlapArea

func _ready() -> void:
	camera = Camera2D.new()
	get_node("..").add_child.call_deferred(camera)
	camera.make_current.call_deferred()


func _process(_delta: float) -> void:
	camera.global_position = global_position #camera.global_position.lerp(global_position, delta * 15)
	if abs(velocity.x) > SPEED/4:
		sprite.flip_h = velocity.x > 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		if sign(direction) == sign(velocity.x):
			velocity.x = move_toward(velocity.x, direction * SPEED, delta * ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, delta * TURN_ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, delta* DECELERATION)

	move_and_slide()


func _on_overlap_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("bounce"):
		velocity.y = BOUNCE_VELOCITY
		area.get_node("%Sprite").play("bounce")
		return
