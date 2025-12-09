# Backgrounds.gd 스크립트 (Backgrounds 노드에 연결)
extends Node2D

@onready var texture_rect = $Background_Texture
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var stage_manager: StageManager = $"../StageManager"
@onready var enemy_spawner: EnemySpawner = $"../EnemySpawner"


func _ready() -> void:
	var random_number = randf_range(1, 3)
	print(random_number)
	timer.wait_time = random_number
	timer.timeout.connect(_ontimeout)
	#timer.start()
	enemy_spawner.oneemykilled.connect(on_enemy_killed)
	enemy_spawner.on_next_stage.connect(on_new_stage)

#func _process(delta: float) -> void:
	#var max_enemy = enemy_spawner.max_enemy
	#var current_enemy = enemy_spawner.active_enemies.size()
	#if current_enemy == 0 and max_enemy != null:
		#animated_sprite_2d.frame = 2
	#if max_enemy == current_enemy:
		#animated_sprite_2d.frame = 0

func _ontimeout():
	change_background()

var textures_to_use = []

func change_background():
	animated_sprite_2d.play()

func change_stage(stage_number):
	change_background()
	animated_sprite_2d.play("stage" + str(stage_number))
	animated_sprite_2d.stop()
	
func on_new_stage():
	animated_sprite_2d.frame = 0

func on_enemy_killed():
	var current_enemy = enemy_spawner.active_enemies.size()
	var max_enemy = enemy_spawner.max_enemy
	if current_enemy / max_enemy < 0.5:
		animated_sprite_2d.frame = 1
	if current_enemy == 0:
		animated_sprite_2d.frame = 2
	print(current_enemy)
	print(current_enemy/max_enemy)
	print(max_enemy)
