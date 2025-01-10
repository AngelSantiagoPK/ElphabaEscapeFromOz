class_name CreditsMenu
extends Node2D

@onready var menu_audio: AudioStreamPlayer2D = %MenuAudio
@onready var score: Label = %Score

func _ready() -> void:
	display_hi_score()
	
func _on_play_button_pressed() -> void:
	click_button_and_go_to_scene(PathManager._game_world_path)
	
func _on_back_button_pressed() -> void:
	click_button_and_go_to_scene(PathManager._main_menu_path)	

func click_button_and_go_to_scene(scene: String):
	if !scene:
		return
	
	const ACCEPT = preload("res://sounds/Fantasy Sound Library/Wav/Inventory_Open_01.wav")
	menu_audio.stream = ACCEPT
	menu_audio.play()
	LoadManager.load_scene(scene)

func display_hi_score():
	score.text = "HI-SCORE:  " + str(ScoreboardManager.top_score)
