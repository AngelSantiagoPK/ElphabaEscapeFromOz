class_name Fence
extends Node2D

@export var speed: float = 10.0
@export var top_limit: int = -50
@export var bot_limit: int = 50
@export var max_fence_length: int = 100
@export var min_fence_length: int = 50
var starting_pos: Vector2

const LASER_NODE = preload("res://scenes/laser_node.tscn")
@export var NODES: Array[LaserNode]


@onready var laser_line: Line2D = %LaserLine
@onready var laser_ray: RayCast2D = %LaserRay
@onready var collision_area: Area2D = %CollisionArea

func _ready() -> void:
	starting_pos = Vector2(640/2, 0)
	randomize()
	reposition()

func _physics_process(delta: float) -> void:
	self.position += speed * delta * Vector2.LEFT
	check_laser()
	
func reposition():
	choose_orientation()
	aim_laser_ray()

func choose_orientation() -> void:
	var x1: float = 0
	var y1: float = 0
	var x2: float = 0
	var y2: float = 0
	var rand_y: int = randi_range(bot_limit, top_limit)
	var rand_length: int = randi_range(min_fence_length, max_fence_length)
	
	var variation: int = randi_range(0,2)
	match variation:
		0:
			# vertical fence
			x1 = starting_pos.x
			y1 = rand_y
			x2 = starting_pos.x
			y2 = rand_y + rand_length
		1:
			# horizontal fence
			x1 = starting_pos.x
			y1 = rand_y
			x2 = starting_pos.x + rand_length
			y2 = rand_y
		2:
			# diagonal fence
			x1 = starting_pos.x
			y1 = rand_y
			rand_y = randi_range(bot_limit, top_limit)
			x2 = starting_pos.x + rand_length
			y2 = rand_y

	NODES[0].global_position = Vector2(x1, y1)
	NODES[1].global_position = Vector2(x2, y2)
	collision_area.global_position = Vector2(x2 + max_fence_length, 0)
	NODES[0].look_at(NODES[1].laser_gun.global_position)
	NODES[1].look_at(NODES[0].laser_gun.global_position)

func _draw() -> void:
	laser_line.clear_points()
	laser_line.add_point(NODES[0].laser_gun.global_position - self.global_position)
	laser_line.add_point(NODES[1].laser_gun.global_position - self.global_position)

func aim_laser_ray():
	laser_ray.global_position = NODES[0].laser_gun.global_position
	laser_ray.look_at(NODES[1].laser_gun.global_position)
	
func check_laser() -> void: 
	laser_ray.force_raycast_update()
	if laser_ray.is_colliding():
		var collision = laser_ray.get_collider()
		if collision.is_in_group("Player"):
			collision.on_death()

func destroy():
	queue_free()
