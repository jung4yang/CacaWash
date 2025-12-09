extends CharacterBody2D

var bullet = preload("res://Scenes/Bullet.tscn")
@export var speed = 300
@export var hp = 3
@onready var hp_ui = $"../UI/Control/VBoxContainer/Hp"


func die():
	get_tree().change_scene_to_file("res://Scenes/Gameover.tscn")
	queue_free()
	print("die")
	
func take_damage(amount := 1):
	hp -= amount
	if hp < 0:
		hp = 0
	
	hp_ui.set_hp(hp)

	if hp == 0:
		die()


func _process(delta):
	var screensize = get_viewport_rect().size
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# 총알 발사 (bullet 액션 키 현재 마우스 왼쪽 버튼)
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	# 1. 좌우 입력 감지 (-1: 왼쪽, 1: 오른쪽, 0: 입력 없음)
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		# 입력이 있으면 해당 방향으로 속도 설정
		velocity.x = direction * speed
	else:
		# 입력이 없으면 부드럽게 멈춤 (즉시 멈추려면 velocity.x = 0 으로 변경 가능)
		velocity.x = move_toward(velocity.x, 0, speed * delta)


	# 2. Y축(위아래) 움직임 완벽 차단
	velocity.y = 0
	
	# 3. 이동 실행
	move_and_slide()


	
func shoot():
	# 총알 발사
	var bulletInstance = bullet.instantiate()
	bulletInstance.global_position = global_position + Vector2(0, -30)
	# 총알의 S자 이동 시작점 설정
	bulletInstance._start_x = bulletInstance.position.x
	get_tree().current_scene.add_child(bulletInstance)
