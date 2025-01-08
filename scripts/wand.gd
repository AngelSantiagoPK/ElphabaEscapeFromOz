class_name Wand
extends Node2D

@export var rate_delay: float = 0.25
var can_shoot: bool = true
const PROJECTILE = preload("res://scenes/PlayerProjectile.tscn")
@onready var rate_timer: Timer = %RateTimer
@onready var wand_audio: AudioStreamPlayer2D = %WandAudio

func use_wand():
	if !can_shoot:
		return
	
	can_shoot = false
	rate_timer.wait_time = rate_delay
	rate_timer.start()
	fire_double_projectile()


func fire_single_projectile():
	var v1: Vector2 = Vector2(0.2, 1).normalized()
	var p1 = PROJECTILE.instantiate()
	p1.global_position = self.global_position
	p1.global_position.x += 20
	p1.set_direction(v1)
	get_tree().root.add_child(p1)


func fire_double_projectile():
	var v1: Vector2 = Vector2(0.2, 1).normalized()
	var v2: Vector2 = Vector2(-0.2, 1).normalized()
	var p1 = PROJECTILE.instantiate()
	var p2 = PROJECTILE.instantiate()
	p1.global_position = self.global_position
	p2.global_position = self.global_position
	p1.global_position.x += 20
	p2.global_position.x += 15
	p1.set_direction(v1)
	p2.set_direction(v2)
	get_tree().root.add_child(p1)
	get_tree().root.add_child(p2)


func _on_rate_timer_timeout() -> void:
	can_shoot = true
