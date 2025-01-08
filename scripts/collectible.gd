class_name Collectible
extends Area2D

signal collected

@export var score_value: int = 10
@export var speed: float = 50.0
const POINTS = preload("res://scenes/PointsEarnedDisplay.tscn")

func _physics_process(delta: float) -> void:
	self.position.x -= speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collected.emit()
		destroy()

func destroy() -> void:
	var points = POINTS.instantiate()
	points.position = self.position
	get_tree().root.add_child(points)
	points.display_score(score_value)
	ScoreboardManager.add_score(score_value)
	queue_free()
