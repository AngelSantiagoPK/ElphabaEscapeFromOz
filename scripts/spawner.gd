class_name Spawner
extends Node2D

#  VARIABLES
@export var scroll_speed: int = 60
@export var STAGES: Array[StageConfig] = []
@export var SHAPES: Array[CollectibleShapeConfig] = []
var current_stage: int = 0
var current_shape: int = 0
const COLLECTIBLE = preload("res://scenes/Collectible.tscn")
const ENEMY = preload("res://scenes/Enemy.tscn")
const FLYING_ENEMY = preload("res://scenes/FlyingEnemy.tscn")
const FENCE = preload("res://scenes/Fence.tscn")
var view_size: Vector2 = Vector2(640, 360)

# REFERENCES
@onready var collectible_timer: Timer = %CollectibleTimer
@onready var enemy_timer: Timer = %EnemyTimer
@onready var flying_enemy_timer: Timer = %FlyingEnemyTimer
@onready var fence_timer: Timer = %FenceTimer
@onready var stage_timer: Timer = %StageTimer

func _ready() -> void:
	play_mode()


# Stage Progression Functions
func play_mode() -> void:
	# TODO: Play the mode based on a Resource
	# TODO: Find a level that matches the current_level
	var stage: StageConfig = STAGES[current_stage]
	# TODO: update the timers based on the level data
	collectible_timer.wait_time = stage.collectible_time
	enemy_timer.wait_time = stage.enemy_time
	flying_enemy_timer.wait_time = stage.flying_enemy_time
	fence_timer.wait_time = stage.fence_time
	# TODO: start the timers
	start_all_timers()

func next_stage() -> void:
	update_mode_by_index(current_stage + 1)

func update_mode_by_index(idx: int) -> void:
	# Check if index is a valid key in dicitonary
	if STAGES.size() > idx:
		# If it is, set current_level  to index
		current_stage = idx
		# Change timers to match the level
		play_mode()

func update_mode_by_name(name: String) -> void:
	# Check if any of the stages have a name that matches requested stage
	for i in STAGES.size():
		if STAGES[i].name == name:
			current_stage = i
			# Change timers to match the level
			play_mode()
			return
	
func check_stage_cleared() -> void:
	var score: int = ScoreboardManager.get_score()
	if score > STAGES[current_stage].win_score:
		next_stage()
	

# Spawn Functions
func spawn_collectible() -> void:
	var rand_int: int = randi_range(-5,1)
	var y_spawn: float = rand_int * 20

	for i in SHAPES[current_shape].ROWS.size():
		var split_row: Array[String]
		var row: String = SHAPES[current_shape].ROWS[i]

		for x in row.split(""):
			split_row.append(x)

		for j in split_row.size():
			if split_row[j] == "1":
				var col_instance: Collectible = COLLECTIBLE.instantiate()
				col_instance.global_position = Vector2(view_size.x + (16 * j), y_spawn + (16 * i))
				add_child(col_instance)
	
	# Change to a different shape or go back to start if we are out of bounds
	if SHAPES.size() <= current_shape + 1:
		current_shape = 0
		return
	
	current_shape += 1

func spawn_enemy() -> void:
	var enemy_instance: Enemy = ENEMY.instantiate()
	enemy_instance.global_position = Vector2(view_size.x, 30)
	add_child(enemy_instance)

func spawn_flying_enemy() -> void:
	var enemy_instance: Enemy = FLYING_ENEMY.instantiate()
	var rand_int: int = randi_range(-5,1)
	var y_spawn: float = rand_int * 20
	enemy_instance.global_position = Vector2(view_size.x, y_spawn)
	add_child(enemy_instance)

func spawn_fence() -> void:
	var fence_instance: Fence = FENCE.instantiate()
	add_child(fence_instance)


# Timer Functions
func start_all_timers() -> void:
	collectible_timer.start()
	enemy_timer.start()
	flying_enemy_timer.start()
	fence_timer.start()

func _on_collectible_timer_timeout() -> void:
	spawn_collectible()

func _on_enemy_timer_timeout() -> void:
	spawn_enemy()

func _on_flying_enemy_timer_timeout() -> void:
	spawn_flying_enemy()

func _on_fence_timer_timeout() -> void:
	spawn_fence()

func _on_stage_timer_timeout() -> void:
	check_stage_cleared()
