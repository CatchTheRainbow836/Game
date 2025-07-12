extends CharacterBody2D
@export var player_path: NodePath
@export var follow_speed := 5.0 
@export var bob_radius := 16.0 
@export var bob_interval := 1.0
@onready var _timer := $Timer
@onready var _animation  := $AnimatedSprite2D
var _player: Node2D
var _target_offset := Vector2.ZERO

func _ready():
	_player = get_node(player_path)
	assert(_player, "Please assign Player Path")
	_timer.wait_time = bob_interval
	_timer.one_shot = false
	_timer.start()
	_pick_new_offset()
	_animation.play("run")
	
func _physics_process(delta):
	var desired = _player.global_position + _target_offset
	var next_pos = global_position.lerp(desired, follow_speed * delta)
	velocity = (next_pos - global_position) / delta
	move_and_slide()
	if _animation.animation != "run":
		_animation.play("run")

func _on_Timer_timeout():
	_pick_new_offset()

func _pick_new_offset():
	var dir = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	_target_offset = dir * randf_range(0, bob_radius)

func _process(delta: float) -> void:
	if global_position.x < _player.global_position.x:
		_animation.flip_h = true
	else:
		_animation.flip_h = false
