extends Area2D



func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		PlayerData.ladder = true
		print(PlayerData.ladder)


func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		PlayerData.ladder = false
		body.climb = false
		print(PlayerData.ladder)
