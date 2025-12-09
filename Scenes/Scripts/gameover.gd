extends Control

@onready var restart_button: Button = $RestartButton


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
