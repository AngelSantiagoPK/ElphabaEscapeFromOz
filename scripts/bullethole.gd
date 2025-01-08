class_name ProjectileEffect
extends Node2D

@onready var bullet_fx: GPUParticles2D = %BulletFX

func _ready() -> void:
	bullet_fx.restart()
	bullet_fx.emitting = true
	await bullet_fx.finished
	queue_free()
