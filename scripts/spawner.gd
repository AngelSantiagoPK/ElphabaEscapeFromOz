class_name Spawner
extends Node2D

#  VARIABLES
var LEVELS = {
	0: { 
		"name": "Start",
		"collectible_time": 10.0,
		"enemy_time": 10.0,
		"flying_enemy_time": 10.0,
		"fence_time": 10.0,
		"win_score": 25,
		},
	1: {
		"name": "Level 1",
		"collectible_time": 1.0,
		"enemy_time": 8.0,
		"flying_enemy_time": 8.0,
		"fence_time": 8.0,
		"win_score": 100,
	},
	2: {
		"name": "Crazy Mode",
		"collectible_time": 1.5,
		"enemy_time": 99.0,
		"flying_enemy_time": 99.0,
		"fence_time": 3.0,
		"win_score": 300,
	},
	3: {
		"name": "Level 2",
		"collectible_time": 2.0,
		"enemy_time": 3.0,
		"flying_enemy_time": 5.0,
		"fence_time": 999.0,
		"win_score": 500,
	},
}

var current_level: int = 0
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
	# TODO: Play the mode based on a dicitonary
	# TODO: Find a level that matches the current_level
	var level = LEVELS[current_level]
	# TODO: update the timers based on the level data
	collectible_timer.wait_time = level["collectible_time"]
	enemy_timer.wait_time = level["enemy_time"]
	flying_enemy_timer.wait_time = level["flying_enemy_time"]
	fence_timer.wait_time = level["fence_time"]
	# TODO: start the timers
	start_all_timers()

func next_stage() -> void:
	update_mode_by_index(current_level + 1)

func update_mode_by_index(idx: int) -> void:
	# TODO: Check if index is a valid key in dicitonary
	if LEVELS.keys().has(idx):
		# TODO: If it is, set current_level  to index
		current_level = idx
		# TODO: Change timers to match the level
		play_mode()

func update_mode_by_name(name: String) -> void:
	# TODO: Check if any of the levels have a name that matches
	for level in LEVELS:
		if LEVELS[level]["name"] == name:
			current_level = level
			# TODO: Change timers to match the level
			play_mode()
			return
	
func check_stage_cleared() -> void:
	var score: int = ScoreboardManager.get_score()
	if score > LEVELS[current_level].win_score:
		next_stage()
	

# Spawn Functions
func spawn_collectible() -> void:
	var collectible_instance: Collectible = COLLECTIBLE.instantiate()
	var player_position: Vector2 = get_parent().get_tree().get_first_node_in_group("Player").global_position
	collectible_instance.global_position = Vector2(view_size.x, player_position.y)
	get_tree().root.add_child(collectible_instance)

func spawn_enemy() -> void:
	var enemy_instance: Enemy = ENEMY.instantiate()
	enemy_instance.global_position = Vector2(view_size.x, 30)
	get_tree().root.add_child(enemy_instance)

func spawn_flying_enemy() -> void:
	var enemy_instance: Enemy = FLYING_ENEMY.instantiate()
	var player_position: Vector2 = get_parent().get_tree().get_first_node_in_group("Player").global_position
	enemy_instance.global_position = Vector2(view_size.x, player_position.y)
	get_tree().root.add_child(enemy_instance)

func spawn_fence() -> void:
	var fence_instance: Fence = FENCE.instantiate()
	get_tree().root.add_child(fence_instance)


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
