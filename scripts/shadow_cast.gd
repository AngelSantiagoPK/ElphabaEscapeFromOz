class_name ShadowCast
extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		if self.get_parent().visible == true:
			show()
		var pos_y = ray_cast_2d.get_collider().global_position.y
		sprite_2d.global_position = Vector2(global_position.x, pos_y)
	else:
		hide()
