extends Button

func _on_button_up() -> void:
	PlayerData.score = 0
	PlayerData.hurt = 0
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_down() -> void:
	$Click.play()
