extends Actor


onready var stomp_area: Area2D = $StompArea2D
onready var sprite: AnimatedSprite = $Position2D/Sprite
onready var collision: CollisionShape2D = $Position2D/PlayerDetector/CollisionShape2D
onready var floor_checker: RayCast2D = $Floor_checker
onready var timer: Timer = $Timer
onready var position2d: Position2D = $Position2D
onready var direction: int = 1

export var score: = 100


func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	if is_on_wall() or not floor_checker.is_colliding() and is_on_floor():
		direction = -1
	else:
		direction = 1
	_velocity.x *= direction
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if _velocity.x < 0:
		position2d.scale.x = 1
		floor_checker.position.x = -collision.shape.get_extents().x 
	elif _velocity.x > 0:
		position2d.scale.x = -1
		floor_checker.position.x = collision.shape.get_extents().x 


func _on_StompArea2D_area_entered(area: Area2D) -> void:
	die()


func die() -> void:
	PlayerData.score += score
	_velocity.x = 0
	timer.start()
	sprite.play("Death")
	_dead = true


func _on_Timer_timeout() -> void:
	set_collision_layer_bit(1,false)
	set_collision_mask_bit(0,false)
	stomp_area.set_collision_layer_bit(1,false)
	stomp_area.set_collision_mask_bit(0,false)


func _on_Sprite_animation_finished() -> void:
	if _dead:
		queue_free()


func _on_PlayerDetector_body_entered(body: Node) -> void:
	if not _dead:
		body.hurt(position.x)
