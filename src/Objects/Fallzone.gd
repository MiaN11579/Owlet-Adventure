extends Area2D


func _on_Fallzone_body_entered(body: Node) -> void:
	if body.name == 'Player':
		body.die()
