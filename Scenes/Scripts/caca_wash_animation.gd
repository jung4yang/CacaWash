extends TextureRect

@export var amplitude: float = 0.05   # 5% 확대
@export var period: float = 1.2       # 한 사이클 시간(초)
@export var base_scale: Vector2 = Vector2.ONE  # 기본 크기

var _time: float = 0.0

func _ready():
	set_process(true)
	scale = base_scale
	
	# 중앙 정렬: pivot을 텍스처 중심으로 설정
	pivot_offset = size / 2.0

func _process(delta: float) -> void:
	if get_tree().paused:
		return
	
	_time += delta
	var s := 1.0 + amplitude * sin(2.0 * PI * _time / period)
	scale = base_scale * s
