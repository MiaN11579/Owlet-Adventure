extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

export var score: = 100
var picked: = false

func _on_Heart_body_entered(body: Node) -> void:
	if PlayerData.hurt > 0:
		picked()
		picked = true


func picked() -> void:
	if picked == false:
		$CollectSound.play()
		PlayerData.hurt -= 1
		yield ($CollectSound, "finished")
		anim_player.play("fade_out")
