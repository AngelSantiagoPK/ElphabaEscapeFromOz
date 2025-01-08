extends ParallaxLayer

@export var speed: float = 10.0

func _physics_process(delta: float) -> void:
	self.motion_offset.x -= speed * delta
	self.motion_mirroring = Vector2(640, 0)
