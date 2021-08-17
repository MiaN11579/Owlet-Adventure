extends Control


onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = $PauseOverlay

# Labels
onready var score: Label = $Score
onready var key: Label = $Key
onready var pause_title: Label = $PauseOverlay/Title

# Hearts
onready var one: TextureRect = $HeartContainer/one
onready var two: TextureRect = $HeartContainer/two
onready var three: TextureRect = $HeartContainer/three

var paused: = false setget set_paused


func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_score")
	PlayerData.connect("key_updated", self, "update_key")
	PlayerData.connect("hurt_updated", self, "update_health")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_score()
	update_key()
	update_health()


func _on_PlayerData_player_died() -> void:
	$GameOver.play()
	self.paused = true
	pause_title.text = "You died.\n Try again?"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and pause_title.text != "You died":
		self.paused = not paused
		scene_tree.set_input_as_handled()


func update_score() -> void:
	score.text = "Score : %s" % PlayerData.score


func update_key() -> void:
	key.text = ": %s" % PlayerData.key


func update_health() -> void:
	print(PlayerData.hurt)
	if PlayerData.hurt == 0:
		three.visible = true
	elif PlayerData.hurt == 1:
		three.visible = false
		two.visible = true
	elif PlayerData.hurt == 2:
		three.visible = false
		two.visible = false
		one.visible = true
	elif PlayerData.hurt == 3:
		one.visible = false


func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
