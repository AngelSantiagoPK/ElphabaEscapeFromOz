class_name EnemyProjectile
extends CharacterBody2D

var gravity: float = 0.0
var direction: Vector2 = Vector2.LEFT
@export var acceleration: float = 300.0
@export var top_speed: float = 1000.0
@export var lifetime: float = 3.0
@onready var lifetime_timer: Timer = %LifetimeTimer
@onready var sprite: AnimatedSprite2D = %Sprite
const PROJECTILE_FX = preload("res://scenes/ProjectileEffect.tscn")

func _ready() -> void:
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	lifetime_timer.timeout.connect(func(): queue_free())

func set_direction(bullet_direction: Vector2) -> void:
	self.direction = bullet_direction

func set_top_speed(speed: float) -> void:
	self.top_speed = speed

func _physics_process(delta: float) -> void:
	velocity += direction * acceleration * delta
	velocity = velocity.limit_length(top_speed)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile") || body.is_in_group("Enemy"):
		return
	
	if body.is_in_group("Player"):
		body.on_death()
	
	var projectile_fx = PROJECTILE_FX.instantiate()
	projectile_fx.position = self.position
	get_tree().root.add_child(projectile_fx)
	queue_free()
