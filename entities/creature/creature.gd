extends CharacterBody2D

const SPEED = 200

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_animate()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_wall():
		velocity.x = -velocity.x
	move_and_slide()

func _move_in_direction(direction : int):
	velocity.x = sign(direction) * SPEED




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
	pass # Replace with function body.
