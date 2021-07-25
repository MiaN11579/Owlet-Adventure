tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sprite: AnimatedSprite= $AnimatedSprite
onready var label: Label = $Label
onready var label2: Label = $Label2

export var next_scene: PackedScene
export var key_required: = 1
var open: = false 
var player: PhysicsBody2D 

func _on_body_entered(body: Node) -> void:
	player = body
	if PlayerData.key == key_required:
		open = true
		label2.visible = true
	else:
		label.visible = true


func _on_body_exited(body: Node) -> void:
	label.visible = false
	label2.visible = false


func _process(delta: float) -> void:
	if open and Input.is_action_pressed("open-pickup") and overlaps_body(player):
		teleport()

func _get_configuration_warning() -> String:
	return "The next scene property cannot be emty" if not next_scene else ""


func teleport() -> void:
	sprite.play("Open")
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
