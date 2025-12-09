extends Node
class_name EnemySpawner
@onready var backgrounds: Node2D = $"../Backgrounds"

# StageManager 참조
@onready var stage_manager = get_parent().get_node("StageManager")

#  GameClear 씬 파일 경로를 미리 로드합니다.
const GAME_CLEAR_SCENE = preload("res://Scenes/Gameover.tscn")

signal oneemykilled
signal on_next_stage

# 현재 생성된 적들 추적
var active_enemies = []
var max_enemy
func _ready():
	# 게임 시작시 첫 스테이지 적 생성
	spawn_stage_enemies()

func spawn_stage_enemies():
	# 스테이지 데이터 가져오기
	var stage_data = stage_manager.get_stage_data()
	
	print("Spawning Stage ", stage_manager.stage, " enemies")
	
	# 안전 장치: stage_data가 유효한지 확인합니다. (StageManager에서 기본값을 반환하도록 수정했다면 안전합니다)
	if stage_data.is_empty() or stage_data.enemies.is_empty():
		print("ERROR: No stage data found or no enemies defined for stage ", stage_manager.stage)
		return
	
	var total_enemy = 0
	# 각 적 타입별로 생성
	for enemy_type in stage_data.enemies:
		var enemy_info = stage_data.enemies[enemy_type]
		
		# count만큼 적 생성
		for i in range(enemy_info.count):
			# Note: U+00A0 오류가 발생하지 않도록 이 줄의 공백을 재확인하세요.
			await get_tree().create_timer(0.3).timeout 
			spawn_enemy(enemy_type, enemy_info)
			total_enemy += 1
		max_enemy = total_enemy

func spawn_enemy(type: String, stats: Dictionary):
	# ... (기존 spawn_enemy 함수 로직은 동일) ...
	var enemy_scene = stage_manager.enemies_scenes[type]
	var enemy = enemy_scene.instantiate()
	
	# 랜덤 위치 (화면 위쪽)
	var viewport_width = get_viewport().get_visible_rect().size.x
	var spawn_x = randf_range(50, viewport_width - 50)
	enemy.position = Vector2(spawn_x, -50)
	
	# 스탯 적용
	if enemy.has_method("set_stats"):
		enemy.set_stats(stats)
	
	# 적이 죽었을 때 신호 연결
	if not enemy.is_connected("died", _on_enemy_died):
		# 'enemy' 인수를 바인딩하여 어떤 적이 죽었는지 알 수 있게 합니다.
		enemy.connect("died", _on_enemy_died.bind(enemy))
	
	# 씬에 추가
	get_parent().add_child(enemy)
	active_enemies.append(enemy)

func _on_enemy_died(enemy):
	# 죽은 적 목록에서 제거
	active_enemies.erase(enemy)
	
	oneemykilled.emit()
	print("Enemy died. Remaining: ", active_enemies.size())
	
	# 모든 적을 처치했으면
	if active_enemies.size() == 0:
		await get_tree().create_timer(2.0).timeout
		next_stage()

# next_stage 함수
func next_stage():
	on_next_stage.emit()
	# 현재 스테이지가 4라면 게임 클리어 씬으로 전환
	if stage_manager.stage == 4:
		print("Stage 4 Cleared! Moving to GameClear Scene.")
		get_tree().change_scene_to_packed(GAME_CLEAR_SCENE)
		return
	
	# 4 스테이지 이전이라면 다음 스테이지로 이동
	stage_manager.stage += 1
	print("Moving to Stage ", stage_manager.stage)
	
	
	backgrounds.change_stage(stage_manager.stage)

	
	# StageManager가 배경을 설정하도록 load_stage 호출 (StageManager에 이 함수가 정의되어 있어야 합니다.)
	if stage_manager.has_method("load_stage"):
		stage_manager.load_stage(stage_manager.stage)
		
	spawn_stage_enemies()
