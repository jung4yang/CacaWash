extends Control

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var max_hp := 3

func set_hp(hp):
	sprite.frame = max_hp - hp
