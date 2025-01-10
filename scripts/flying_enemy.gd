class_name FlyingEnemy
extends Enemy

@export var max_height: int = -80
@export var min_height: int = 40

func _ready() -> void:
	current_hp = hp

func _physics_process(delta: float) -> void:
	velocity += Vector2.LEFT * speed * delta
	velocity = velocity.limit_length(top_speed)
	move_and_slide()
