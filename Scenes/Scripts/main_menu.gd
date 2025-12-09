extends Control

@onready var start_button: Button = $StartButton
@onready var credit_button: Button = $CreditButton


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
