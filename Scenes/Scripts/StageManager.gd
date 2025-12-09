extends Node
class_name StageManager
var stage := 1
var enemies_scenes = {
	"bubble": preload("res://Scenes/Enemies/Bubble.tscn"),
	"oil": preload("res://Scenes/Enemies/Oil.tscn"),
	"poop": preload("res://Scenes/Enemies/Poop.tscn")
}

func get_stage_data():
	match stage:
		1:
			return {
				"enemies": {
					"bubble": { "count": 3, "hp": 1, "speed": 30, "bullet_speed": 150, "shoot_delay": Vector2(3,5) },
					"oil":    { "count": 2, "hp": 1, "speed": 28, "bullet_speed": 150, "shoot_delay": Vector2(3,5) },
					"poop":   { "count": 1, "hp": 1, "speed": 25, "bullet_speed": 120, "shoot_delay": Vector2(4,6) },
				}
			}

		2:
			return {
				"enemies": {
					"bubble": { "count": 4, "hp": 2, "speed": 40, "bullet_speed": 200, "shoot_delay": Vector2(2,4) },
					"oil":    { "count": 4, "hp": 2, "speed": 38, "bullet_speed": 180, "shoot_delay": Vector2(2,4) },
					"poop":   { "count": 2, "hp": 2, "speed": 30, "bullet_speed": 180, "shoot_delay": Vector2(3,4) },
				}
			}

		3:
			return {
				"enemies": {
					"bubble": { "count": 6, "hp": 3, "speed": 50, "bullet_speed": 250, "shoot_delay": Vector2(1.5,3) },
					"oil":    { "count": 5, "hp": 3, "speed": 48, "bullet_speed": 230, "shoot_delay": Vector2(1.5,3) },
					"poop":   { "count": 4, "hp": 3, "speed": 40, "bullet_speed": 220, "shoot_delay": Vector2(2,3) },
				}
			}

		4:
			return {
				"enemies": {
					"bubble": { "count": 8, "hp": 4, "speed": 70, "bullet_speed": 300, "shoot_delay": Vector2(1,2) },
					"oil":    { "count": 7, "hp": 4, "speed": 65, "bullet_speed": 280, "shoot_delay": Vector2(1,2) },
					"poop":   { "count": 5, "hp": 5, "speed": 55, "bullet_speed": 260, "shoot_delay": Vector2(1.5,2) },
				}
			}
