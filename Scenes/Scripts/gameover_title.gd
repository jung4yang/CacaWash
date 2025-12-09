extends TextureRect

# 깜박임 간격 (초 단위)
@export var blink_interval: float = 0.5

# _ready() 함수에서 타이머를 설정하고 시작
func _ready():
	# Scene Tree에 Timer 노드를 추가 (스크립트에서 동적으로 생성해도 됨)
	var timer = Timer.new()
	add_child(timer)
	
	# 타이머 시간 설정
	timer.wait_time = blink_interval
	# 반복 설정
	timer.autostart = true
	timer.one_shot = false
	
	# timeout 시그널을 연결
	timer.timeout.connect(_on_timer_timeout)
	
	# 타이머 시작
	timer.start()

# 타이머가 끝날 때마다 호출되는 함수
func _on_timer_timeout():
	# visible 상태를 토글합니다 (보임 <-> 안 보임)
	visible = not visible
