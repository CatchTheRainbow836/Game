extends Node2D

@export var item: InvItem
@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var animated_sprite = $AnimatedSprite2D
@export var speed := 25.0
@export var run_distance := 100.0

enum State {IDLE, RUN}
var state = State.IDLE
var direction = 1
var target_pos: Vector2
var next_decision_time = 0.0

func _ready():
	_schedule_next_decision()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("give"):
		print("give")
		player.collect(item.duplicate(true))
		
	#If battle is won, 10% chance to get the item
	elif BattleManager.state == 2:
		BattleManager.state = 0
		if randi() % 10 == 0:
			print("Battle won -. giving", item.name)
			#item.health = randf_range(750,1000)
			#item.attack = randf_range(100,300)
			#item.defense = randf_range(0,100)
			#item.speed = randf_range(0,20)
			#item.type = [0,18]
			print(item.health)
			print(item.attack)
			print(item.defense)
			print(item.speed)
			print(item.type)
			player.collect(item)
	
	
	if BattleManager.state != 0:
		animated_sprite.play("idle")
		return
		
	if state == State.RUN:
		animated_sprite.play("run")
		global_position = global_position.move_toward(target_pos, speed * delta)
		animated_sprite.flip_h = (direction > 0)
		print("Running -> pos:", global_position, "target:", target_pos)
		if global_position.distance_to(target_pos) < 1.0:
			state = State.IDLE
	else:
		animated_sprite.play("idle")

		var now = Time.get_ticks_msec() / 1000.0
		if now >= next_decision_time:
			_decide_action()
		

		
func _schedule_next_decision():
	var now = Time.get_ticks_msec() / 1000.0
	next_decision_time = now +randf_range(4.0, 10.0)

func _decide_action():
	_schedule_next_decision()
	if randi() % 2 == 1:
		state = State.RUN
		direction = (randi() % 2) * 2 -1
		target_pos = global_position + Vector2(direction * run_distance, 0)
	else:
		state = State.IDLE
		
	#The types are the following:
	#1: Bug
	#2: Dark
	#3: Dragon
	#4: Electric
	#5: Fairy
	#6: Fighting
	#7: Fire
	#8: Flying
	#9: Ghost
	#10: Grass
	#11: Ground
	#12: Ice
	#13: Normal
	#14: Poison
	#15: Psychic
	#16: Rock
	#17: Steel
	#18: Water
