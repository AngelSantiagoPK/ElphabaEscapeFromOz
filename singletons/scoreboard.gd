class_name Scoreboard
extends Node

var current_score: int = 0
var top_score: int = 25

func reset_score() -> void:
	current_score = 0

func get_score() -> int:
	return current_score

func set_score(new_score: int) -> void:
	current_score = new_score

func add_score(points: int) -> void:
	current_score += points

func get_top_score() -> int:
	return top_score

func set_top_score(new_score: int) -> void:
	if new_score > top_score:
		top_score = new_score
