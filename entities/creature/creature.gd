extends CharacterBody2D

const SPEED = 200
const DECELERATION = 1600.0
const ACCELERATION = 300.0
const TURN_ACCELERATION = 2600.0
const BOUNCE_VELOCITY = -300.0

@onready var sprite = $AnimatedSprite2D
var aim_direction = 1

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_animate()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_wall():
		velocity.x = -velocity.x
	if aim_direction == 0:
		velocity.x = move_toward(velocity.x, 0, delta* DECELERATION)
	else:
		if sign(aim_direction) == sign(velocity.x):
			velocity.x = move_toward(velocity.x, aim_direction * SPEED, delta * ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, aim_direction * SPEED, delta * TURN_ACCELERATION)
	move_and_slide()


func _move_in_direction(direction : int):
	aim_direction = sign(direction)


func _animate() -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	if is_on_floor():
		if abs(velocity.x) > 3:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		sprite.play("air")
		sprite.frame = 0 if velocity.y > 0 else 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bounce"):
		velocity.y = BOUNCE_VELOCITY
		velocity.x /= 5
		area.get_node("%Sprite").play("bounce")
		return
