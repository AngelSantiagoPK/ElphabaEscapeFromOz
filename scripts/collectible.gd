class_name Collectible
extends Area2D

signal collected

@export var score_value: int = 10
@export var speed: float = 50.0
const POINTS = preload("res://scenes/PointsEarnedDisplay.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.stop()
	var rand_time: int = randi_range(1, 2)
	await get_tree().create_timer(rand_time).timeout
	animated_sprite_2d.play("default")
	
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
