class_name PointsEarnedDisplay
extends Node2D

@onready var points_fx: GPUParticles2D = %PointsFx
@onready var animator: AnimationPlayer = %Animator
@onready var score_label: Label = %ScoreLabel
@onready var audio_stream: AudioStreamPlayer2D = %AudioStream

func _ready() -> void:
	audio_stream.play()
	animator.play("fade-in-out")
	points_fx.restart()
	points_fx.emitting = true
	await animator.animation_finished
	queue_free()

func display_score(score: int) -> void:
	score_label.text = "+"+str(score)
