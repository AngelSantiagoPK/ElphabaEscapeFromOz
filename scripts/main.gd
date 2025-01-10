class_name Main
extends Node2D

@export var game_speed: float = 100.0
@onready var left_boundary: Area2D = %LeftBoundary
@onready var player: Player = %Player
@onready var score_label: Label = %ScoreLabel
@onready var hi_score_label: Label = %HiScoreLabel
@onready var score_timer: Timer = %ScoreTimer
@onready var wind_emitter: GPUParticles2D = %WindEmitter
@onready var music: AudioStreamPlayer2D = %Music
@onready var spawner: Spawner = %Spawner
@onready var player_icon: TextureRect = %PlayerIcon

func _ready() -> void:
	ScoreboardManager.reset_score()
	player.death.connect(on_player_death)
	update_hi_score_ui()
	wind_emitter.emitting = true
	spawner.stage_completed.connect(on_stage_completed)
	spawner.scroll_speed = game_speed

func _on_left_boundary_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.kill()

func _on_left_boundary_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Laser"):
		area.get_parent().destroy()
	
	if area.is_in_group("Collectible"):
		area.destroy()

func on_player_death() -> void:
	var text: Texture = preload("res://assets/PlayerIconDeath.png")
	player_icon.texture = text
	ScoreboardManager.set_top_score(ScoreboardManager.get_score())
	await time_freeze()
	LoadManager.load_scene(PathManager._credits_path)

func on_stage_completed() -> void:
	game_speed += (game_speed * 0.1)
	spawner.scroll_speed = game_speed

func _on_score_timer_timeout() -> void:
	ScoreboardManager.add_score(1)
	update_score_ui()
	update_hi_score_ui()

func update_score_ui():
	score_label.text = "SCORE: " + str(ScoreboardManager.get_score())

func update_hi_score_ui():
	if ScoreboardManager.get_score() > ScoreboardManager.get_top_score():
		hi_score_label.text = "HI-SCORE: " + str(ScoreboardManager.get_score())
	else:
		hi_score_label.text = "HI-SCORE: " + str(ScoreboardManager.get_top_score())

func time_freeze():
	music.stop()
	Engine.time_scale = 0.06
	await get_tree().create_timer(1.0, true, true, true).timeout
	Engine.time_scale = 1.0
