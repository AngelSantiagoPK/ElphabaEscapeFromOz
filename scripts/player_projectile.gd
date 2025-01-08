class_name PlayerProjectile
extends CharacterBody2D

var gravity: float = 0.0
var direction: Vector2 = Vector2.RIGHT
@export var acceleration: float = 300.0
@export var top_speed: float = 1000.0
@export var lifetime: float = 3.0
@onready var lifetime_timer: Timer = %LifetimeTimer
@onready var sprite_2d: Sprite2D = %Sprite2D
const PROJECTILE_FX = preload("res://scenes/ProjectileEffect.tscn")

func _ready() -> void:
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	lifetime_timer.timeout.connect(func(): queue_free())

func set_direction(bullet_direction: Vector2):
	self.direction = bullet_direction

func _physics_process(delta: float) -> void:
	sprite_2d.rotation_degrees -= 359 * delta
	self.look_at(velocity)
	velocity += gravity * Vector2.DOWN * delta
	velocity += direction * acceleration * delta
	velocity = velocity.limit_length(top_speed)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile") || body.is_in_group("Player"):
		return
	
	if body.is_in_group("Enemy"):
		body.hit()
	
	var projectile_fx = PROJECTILE_FX.instantiate()
	projectile_fx.position = self.position
	get_tree().root.add_child(projectile_fx)
	queue_free()


func _on_animation_timer_timeout() -> void:
	if sprite_2d.frame > 2:
		sprite_2d.frame = 0
	else:
		sprite_2d.frame += 1
