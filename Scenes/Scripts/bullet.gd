extends Area2D

@export var speed = 500           # y축 속도
@export var amplitude = 120       # S곡선의 진폭 (가로 이동 폭)
@export var frequency = 5.0       # S곡선의 빈도 (얼마나 빠르게 왔다 갔다 할지)

var _time_passed = 0.0
var _start_x = 0.0

func _physics_process(delta):
	_time_passed += delta
	
	# y축 직선 이동
	position.y -= speed * delta
	
	# x축에 S자 형태로 움직이는 오프셋 적용
	position.x = _start_x + amplitude * sin(_time_passed * frequency)
	
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		# 적에게 명시적으로 "피해 받음"을 요청
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
