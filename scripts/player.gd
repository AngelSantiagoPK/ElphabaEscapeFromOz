class_name Player
extends CharacterBody2D

signal death

@export var jump_force: float = 196.0
@export var top_speed: float = 120.00
var gravity: float = 98.0
@onready var player_px: GPUParticles2D = %PlayerPX
@onready var flight_audio: AudioStreamPlayer2D = %FlightAudio
@onready var player_audio: AudioStreamPlayer2D = %PlayerAudio
@onready var fly_animator: AnimationPlayer = %FlyAnimator
@onready var wand: Wand = %Wand

func _physics_process(delta: float) -> void:
	# Add gravity every frame
	velocity += Vector2.DOWN * gravity * delta
	
	# Get player input
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.UP * jump_force * delta
		fly_animations()
	else:
		fall_animations()
	
	# Move player up and down only
	velocity.x = 0
	velocity = velocity.limit_length(top_speed)
	move_and_slide()


func on_death() -> void:
	const DEAD = preload("res://sounds/Fantasy Sound Library/Wav/Trap_00.wav")
	player_audio.stream = DEAD
	player_audio.play()
	death.emit()

func fly_animations():
	fly_animator.play('rise')
	wand.use_wand()
	player_px.emitting = true
	flight_audio.play()

func fall_animations():
	fly_animator.play('fall')
	player_px.emitting = false
	flight_audio.stop()
