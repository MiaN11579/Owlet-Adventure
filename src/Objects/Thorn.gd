extends Area2D

func _on_Thorn_body_entered(body: Node) -> void:
	body.hurt(position.x)
