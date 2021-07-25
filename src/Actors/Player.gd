extends Actor


export var stomp_impulse: = 1000.0
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var stomp_detector: Area2D = $StompDetector
onready var enemy_detector: Area2D = $EnemyDetector
var climb: = false
const JUMPFORCE: = 1000


func _on_StompDetector_area_entered(area: Area2D) -> void:
	$StompSound.play()
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


func _on_hurt_animation_finished() -> void:
	if _hurt:
		_hurt = false


func _on_dead_animation_finished() -> void:
	if _dead:
		PlayerData.death += 1
		queue_free()


func _physics_process(delta: float) -> void:
	# Set animation
	if not _dead and not _hurt:
		if PlayerData.ladder and is_on_floor():
			climb = true
		if climb:
			gravity = 0
			if Input.is_action_pressed("climb_up"):
				_velocity.y = -400
				sprite.play("Climb")
			elif Input.is_action_pressed("climb_down"):
				_velocity.y = 400
				sprite.play("Climb")
			elif not is_on_floor():
				_velocity.y = 0
				speed.x = 0
				sprite.playing = false
			else: 
				sprite.play("Idle")
		else:
			gravity = 3500
			speed.x = 500
			speed.y = 1400
			if Input.is_action_just_pressed("jump"):
				$JumpSound.play()
			if Input.is_action_pressed("jump") and Input.is_action_pressed("move_right"):
				sprite.play("Jump")
				sprite.flip_h = false
			elif Input.is_action_pressed("jump") and Input.is_action_pressed("move_left"):
				sprite.play("Jump")
				sprite.flip_h = true
			elif Input.is_action_pressed("jump"):
				sprite.play("Jump")
			elif Input.is_action_pressed("run") and Input.is_action_pressed("move_right"):
				sprite.play("Run")
				speed.x = 800
				sprite.flip_h = false
			elif Input.is_action_pressed("run") and Input.is_action_pressed("move_left"):
				sprite.play("Run")
				speed.x = 800
				sprite.flip_h = true
			elif Input.is_action_pressed("move_right"):
				sprite.play("Walk")
				sprite.flip_h = false
			elif Input.is_action_pressed("move_left"):
				sprite.play("Walk")
				sprite.flip_h = true
			else:
				sprite.play("Idle")
		
	
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 and not _hurt else Vector2.ZERO
	var alteredVelocity  = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)
	if (alteredVelocity.y == 0) and (_velocity.y < 0) and is_on_floor():
		alteredVelocity.y = _velocity.y
	_velocity = alteredVelocity


func get_direction() -> Vector2:
	var a: int = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var b: int
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		b = -Input.get_action_strength("jump")
	else:
		b = 0.0
	return Vector2(a,b)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	if not _hurt:
		velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)


func hurt(var posx) -> void:
	$HurtSound.play()
	_hurt = true
	PlayerData.hurt += 1
	if PlayerData.hurt > 2:
		die()
	_velocity.y = -800
	if position.x < posx:
		_velocity.x = -400
	else:
		_velocity.x = 400
	if not _dead:
		sprite.play("Hurt")


func die() -> void:
	$DeadSound.play()
	set_collision_layer_bit(1,false)
	enemy_detector.set_collision_mask_bit(1,false)
	enemy_detector.set_collision_mask_bit(4,false)
	stomp_detector.set_collision_layer_bit(0,false)
	stomp_detector.set_collision_mask_bit(1,false)
	sprite.play("Death")
	_dead = true
