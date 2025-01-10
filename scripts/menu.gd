class_name Menu
extends Node2D

@onready var start_button: Button = %StartButton
@onready var menu_audio: AudioStreamPlayer2D = %MenuAudio

func _on_start_button_pressed() -> void:
	const ACCEPT = preload("res://sounds/Fantasy Sound Library/Mp3/Spell_02.mp3")
	menu_audio.stream = ACCEPT
	menu_audio.play()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_credits_pressed() -> void:
	const ACCEPT = preload("res://sounds/Fantasy Sound Library/Wav/Inventory_Open_01.wav")
	menu_audio.stream = ACCEPT
	menu_audio.play()
	get_tree().change_scene_to_file("res://scenes/credits_menu.tscn")

func _on_exit_button_pressed() -> void:
	const ACCEPT = preload("res://sounds/Fantasy Sound Library/Wav/Inventory_Open_01.wav")
	menu_audio.stream = ACCEPT
	menu_audio.play()
	get_tree().quit()
