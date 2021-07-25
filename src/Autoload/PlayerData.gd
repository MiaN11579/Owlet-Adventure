extends Node

signal score_updated
signal player_died
signal hurt_updated
signal key_updated

var score: = 0 setget set_score
var death: = 0 setget set_death
var hurt: = 0 setget set_hurt
var key: = 0 setget set_key
var ladder: = false setget set_ladder


func reset() -> void:
	score = 0
	death = 0
	hurt = 0


func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")


func set_death(value: int) -> void:
	death = value
	emit_signal("player_died")


func set_hurt(value: int) -> void:
	hurt = value
	emit_signal("hurt_updated")


func set_key(value: int) -> void:
	key = value
	emit_signal("key_updated")


func set_ladder(value: bool) -> void:
	ladder = value
