extends CharacterBody2D

# StageManager에서 설정될 변수들
var move_speed = 30
var health = 3
var max_hp = 3
var bullet_speed = 120
var shoot_delay_min = 4.0
var shoot_delay_max = 6.0

var shootingcount = 0.0
var bullet = preload("res://Scenes/Enemies/at_poop.tscn")
var direction = Vector2.ZERO
var direction_timer = 0.0
var shooting_delay = 0.0

#  화면 경계 제한을 위한 변수 추가
var screen_size = Vector2.ZERO
var collision_shape_node # CollisionShape2D 노드를 저장할 변수

# 죽었을 때 신호
signal died

func _ready():
	shootingcount = randf_range(0, 10)
	shooting_delay = randf_range(shoot_delay_min, shoot_delay_max)
	_change_direction()
	
	#  1. 화면 크기 가져오기
	screen_size = get_viewport_rect().size
	
	#  2. CollisionShape2D 노드 참조
	# 몬스터 씬의 자식 노드 이름이 'CollisionShape2D'여야 합니다.
	collision_shape_node = $CollisionShape2D 

func _physics_process(delta):
	velocity = direction * move_speed
	move_and_slide()
	
	#  3. 화면 경계 검사 및 위치 조정 로직
	if collision_shape_node and collision_shape_node.shape:
		# 몬스터의 크기 절반 (경계 처리용)
		var half_width = collision_shape_node.shape.get_rect().size.x / 2.0
		var half_height = collision_shape_node.shape.get_rect().size.y / 2.0
		
		var old_position = global_position
		var new_position = global_position
		
		# 위치를 clamp 함수를 사용하여 화면 경계 내로 제한
		new_position.x = clamp(new_position.x, half_width, screen_size.x - half_width)
		new_position.y = clamp(new_position.y, half_height, screen_size.y - half_height)
		
		if old_position != new_position:
			# 경계에 닿았을 때 방향 반전
			if old_position.x != new_position.x:
				direction.x *= -1
			if old_position.y != new_position.y:
				direction.y *= -1
			
			# 위치를 경계로 강제 설정
			global_position = new_position
			
			# 방향 전환 타이머 초기화 (새로운 방향을 찾기 위함)
			direction_timer = 0
	#  화면 경계 로직 끝
	
	# 방향을 일정 시간마다 바꾼다
	direction_timer -= delta
	if direction_timer <= 0:
		_change_direction()
	
	shootingcount += delta
	if shootingcount >= shooting_delay:
		shoot()
		shootingcount = 0
		shooting_delay = randf_range(shoot_delay_min, shoot_delay_max)

func _change_direction():
	# -1 ~ 1 사이의 임의의 방향 설정 후 정규화
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# 0.5초~2초마다 방향 전환
	direction_timer = randf_range(0.5, 2.0)

func shoot():
	var firedbullet = bullet.instantiate()
	firedbullet.global_position = global_position
	
	# bullet_speed 설정
	if "speed" in firedbullet:
		firedbullet.speed = bullet_speed
	
	get_tree().current_scene.call_deferred("add_child", firedbullet)

func take_damage():
	health -= 1
	if health <= 0:
		die()

func die():
	print("Poop 처치")
	
	# 점수 추가
	var score = get_tree().current_scene.get_node_or_null("UI/Control/VBoxContainer/Score")
	if score:
		score.add_score(10)
	
	# died 신호 발생
	emit_signal("died")
	
	queue_free()

# StageManager에서 스탯 설정
func set_stats(stats: Dictionary):
	max_hp = stats.hp
	health = stats.hp
	move_speed = stats.speed
	bullet_speed = stats.bullet_speed
	shoot_delay_min = stats.shoot_delay.x
	shoot_delay_max = stats.shoot_delay.y
