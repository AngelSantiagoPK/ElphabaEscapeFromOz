class_name Enemy
extends CharacterBody2D

signal killed

var gravity: float = 98.0
var current_hp: int
@export var score_value: int = 25
@export var hp: int = 3
@export var speed: float = 30.0
@export var top_speed: float = 50.0
@onready var animator: AnimationPlayer = %Animator
@onready var hit_animator: AnimationPlayer = %HitAnimator
@onready var hit_audio: AudioStreamPlayer2D = %HitAudio
@onready var enemy_collision: Area2D = %EnemyCollision
var POINTS = preload("res://scenes/PointsEarnedDisplay.tscn")

func _ready() -> void:
	current_hp = hp
	animator.play("walk")

func _physics_process(delta: float) -> void:
	velocity += Vector2.DOWN * gravity * delta
	velocity += Vector2.LEFT * speed * delta
	velocity = velocity.limit_length(top_speed)
	move_and_slide()

func hit():
	# Sound and Effects
	var rand_pitch: float = randf_range(0.8, 1.2)
	hit_audio.pitch_scale = rand_pitch
	hit_animator.play("hit")
	hit_audio.play()
	
	# Logic
	current_hp -= 1
	if current_hp <= 0:
		killed.emit()
		kill()

func kill():
	var points = POINTS.instantiate()
	points.position = self.position
	get_tree().root.add_child(points)
	points.display_score(score_value)
	ScoreboardManager.add_score(score_value)
	queue_free()

func _on_enemy_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hit_audio.play()
		body.on_death()
