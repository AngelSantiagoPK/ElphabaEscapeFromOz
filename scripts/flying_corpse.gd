class_name FlyingMonkeyCorpse
extends Node2D

@export var speed: float = 30.0
var direction: Vector2 = Vector2.UP
@onready var ufo_crash_fx: GPUParticles2D = %UFOCrashFX
@onready var death_animator: AnimationPlayer = %DeathAnimator

func _ready() -> void:
	ufo_crash_fx.restart()
	ufo_crash_fx.emitting = true
	death_animator.play("death")
	await death_animator.animation_finished
	queue_free()

func _physics_process(delta: float) -> void:
	self.position += speed * Vector2(-1, 1) * delta
