extends CharacterBody2D

signal win(creature)

enum State {WALKING, SWINGING, FINISHED}

const SPEED = 200
const DECELERATION = 1600.0
const ACCELERATION = 300.0
const TURN_ACCELERATION = 2600.0
const BOUNCE_VELOCITY = -400.0
const SWING_LAUNCH = Vector2(400, -200)
const SWING_LENGTH = 0.7

var aim_direction = 1
var state : State = State.WALKING
var swing_time := 0.0
var swing_origin : Vector2

@onready var sprite = $AnimatedSprite2D
@onready var particles = $GPUParticles2D

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	particles.emitting = state == State.WALKING && aim_direction != 0
	_animate()


func _physics_process(delta: float) -> void:
	match state:
		State.FINISHED:
			aim_direction = 0
			_run_physics_process(delta)
		State.WALKING:
			_run_physics_process(delta)
		State.SWINGING:
			_swing_physics_process(delta)


func _run_physics_process(delta : float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_wall():
		aim_direction =  sign(get_wall_normal().x)
	if aim_direction == 0:
		velocity.x = move_toward(velocity.x, 0, delta * DECELERATION)
	else:
		if sign(aim_direction) == sign(velocity.x):
			velocity.x = move_toward(velocity.x, aim_direction * SPEED, delta * ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, aim_direction * SPEED, delta * TURN_ACCELERATION)
	move_and_slide()


func _swing_physics_process(delta : float) -> void:
	swing_time += delta
	if swing_time > SWING_LENGTH:
		Sound._play_sound("swing",-5)
		state = State.WALKING
		velocity.x = SWING_LAUNCH.x * aim_direction 
		velocity.y = SWING_LAUNCH.y


func _move_in_direction(direction : int):
	aim_direction = sign(direction)


func _animate() -> void:
	if state == State.SWINGING:
		sprite.play("swing")
		var rot = 0
		if aim_direction > 0:
			rot = TAU/4 +cos(-swing_time * 12) * 1.5
		else:
			rot = TAU/4 -cos(-swing_time * 12) * 1.5
		global_position = swing_origin + Vector2(cos(rot), sin(rot)) * 15
		rotation = rot - PI/2
		return
	rotation = 0
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
	if state == State.SWINGING:
		return
	if area.is_in_group("bounce"):
		velocity.y = BOUNCE_VELOCITY
		velocity.x /= 5
		area.get_node("%Sprite").play("bounce")
		Sound._play_sound("bounce",0)
		return

	if area.is_in_group("swing"):
		state = State.SWINGING
		velocity.x = 0
		velocity.y = 0
		swing_time = 0
		swing_origin = area.global_position
	if area.is_in_group("goal"):
		win.emit()
	if area.is_in_group("out"):
		queue_free()
