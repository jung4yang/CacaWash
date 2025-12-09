extends Area2D

@export var speed = 300

func _ready():
	# 시그널 연결
	connect("area_entered", Callable(self, "_on_area_entered"))
	
func _physics_process(delta):
	position.y += speed * delta

func _on_area_entered(area):
	if area.name == "Hitbox":
		print("플레이어와 충돌!")
		area.get_parent().take_damage(1)
		queue_free()
