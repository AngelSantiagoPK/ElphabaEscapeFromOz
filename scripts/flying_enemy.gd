class_name FlyingEnemy
extends Enemy

@export var max_height: int = -80
@export var min_height: int = 40
@export var projectile_delay: float = 3.0
const PROJECTILE = preload("res://scenes/EnemyProjectile.tscn")
@onready var ufo_projectile_timer: Timer = %UFOProjectileTimer

func _ready() -> void:
	current_hp = hp

func _physics_process(delta: float) -> void:
	velocity += Vector2.LEFT * speed * delta
	velocity = velocity.limit_length(top_speed)
	move_and_slide()

func shoot_ufo_projectile():
	var projectile_direction: Vector2 = Vector2.LEFT
	const FIRE = preload("res://sounds/Game/Fireball.wav")
	hit_audio.stream = FIRE
	hit_audio.play()
	ufo_projectile_timer.wait_time = projectile_delay
	ufo_projectile_timer.start()
	var projectile_instance = PROJECTILE.instantiate()
	projectile_instance.global_position = self.global_position
	projectile_instance.global_position.x -= 15
	projectile_instance.set_direction(projectile_direction)
	get_tree().root.add_child(projectile_instance)

func _on_ufo_projectile_timer_timeout() -> void:
	shoot_ufo_projectile()
