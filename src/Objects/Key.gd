extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")


func _on_Key_body_entered(body: Node) -> void:
	picked()


func picked() -> void:
	$CollectSound.play()
	PlayerData.key = 1
	yield ($CollectSound, "finished")
	anim_player.play("fade_out")

