extends Node2D
class_name BaseEnemy

@export var item: InvItem
@export var speed := 25.0
@export var run_distance := 100.0
var randomized_item: InvItem
var moves: Array = [
	{"name": "Tackle","power":50,"type":13},
	{"name": "Headbutt","power":60,"type":13}
]

# Injected by your SpawnNode1
var spawner: SpawnNode1

var status_effects = {}

enum State { IDLE, RUN }
var state = State.IDLE
var next_decision_time = 0.0
var direction = 1
var target_pos = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = BattleManager.player

func _ready() -> void:

	if not spawner:
		if not is_inside_tree():
			#push_error("Enemy %s is not in scene tree at ready!" % name)
			queue_free()
			return
		var tree = get_tree()
		if tree == null:
			push_error("Enemy %s: get_tree() returned null!" % name)
			queue_free()
			return
		
		push_warning("Enemy %s has no spawner at ready — waiting one frame." % name)
		await tree.process_frame
		if not is_inside_tree() or not is_instance_valid(self):
			push_error("Enemy %s was removed during process_frame wait" % name)
			return
		if not spawner:
			push_error("Enemy %s STILL has no spawner!" % name)
			queue_free()
			return
	
	if item:
		randomized_item = _give_unique_item()
		print("ENEMY FINAL ITEM:", randomized_item.name, 
			randomized_item.health, randomized_item.attack,
			randomized_item.defense, randomized_item.speed, 
			randomized_item.type)
	elif item == null:
		push_error("BaseEnemy.item is NULL for %s!" % name)
	else:
		push_error("NO BASE ITEM SET ON ENEMY: %s" % name)

	sprite.play("idle")
	_schedule_next()

func _process(delta: float) -> void:
	# 1) Handle global “battle won” event (state = 2)
	if BattleManager.state == 2:
		BattleManager.state = 0
		_drop_loot()
		spawner.ready_for_battle = true
		spawner.timer.start()
		queue_free()
		return

	# 2) If we’re in an active battle (state = 1), stay idle
	if BattleManager.state == 1:
		sprite.play("idle")
		return

	# 3) Check if it’s time to pick a new action
	var now_sec = Time.get_ticks_msec() / 1000.0
	if now_sec >= next_decision_time:
		_schedule_next()

	# 4) Act once based on the current state
	if state == State.RUN:
		sprite.play("run")
		global_position = global_position.move_toward(target_pos, speed * delta)
		sprite.flip_h = direction > 0
		if global_position.distance_to(target_pos) < 1.0:
			state = State.IDLE
	else:
		sprite.play("idle")

func _schedule_next() -> void:
	# schedule next decision in 4–10 seconds
	next_decision_time = (Time.get_ticks_msec() / 1000.0) + randf_range(4.0, 10.0)

	if randi() % 2 == 1:
		state = State.RUN
		direction = (randi() % 2) * 2 - 1   # either -1 or +1
		target_pos = global_position + Vector2(direction * run_distance, 0)
	else:
		state = State.IDLE

func _give_unique_item() -> InvItem:
	var ui = item.duplicate(true) as InvItem
	var ts = str(Time.get_ticks_msec())
	ui.name = "%s_%s" % [item.name, ts]
	_randomize_stats(ui)
	print("Randomized stats:", ui.health, ui.attack, ui.defense, ui.speed, ui.type)
	# …set other random stats if you like…
	ui.max_health = ui.health
	return ui

func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(750,1000)
	ui.attack  = randi_range(100,300)
	ui.defense = randi_range(20,50)
	ui.speed   = randi_range(15,20)

func _drop_loot() -> void:
	#change this later
	if randi() % 10 == 0:
		var u = _give_unique_item()
		player.collect(u)

func apply_status(status_name: String) -> void:
	if status_name in status_effects:
		print("[%s] %s is already affected by %s!" % [name, randomized_item.name, status_name])
		return
	print("[%s] %s is now afflicted with %s!" % [name, randomized_item.name, status_name])
	match status_name:
		"poison":
			status_effects[status_name] = {
			"damage_per_turn": randomized_item.max_health * 0.1,
				"duration": 3
			}
			
		"burn":
			status_effects[status_name] = {
				"damage_per_turn": randomized_item.max_health * 0.08,
				"duration": 4,
				"attack_debuff": 0.7
			}
			
		"paralysis":
			status_effects[status_name] = {
				"speed_debuff": 0.5,
				"miss_chance": 0.3,
				"duration": 3
			}
			
		"freeze":
			status_effects[status_name] = {
				"skip_turn_chance": 0.7,
				"duration": 2
			}
			
		"sleep":
			status_effects[status_name] = {
				"skip_turns": 2,
				"duration": 2
			}
			
		"confusion":
			status_effects[status_name] = {
				"self_damage_chance": 0.4,
				"self_damage_percent": 0.1,
				"duration": 3
			}
			
		"attack_buff", "defense_buff", "speed_buff":
			var stat = status_name.split("_")[0]
			status_effects[status_name] = {
				"stat": stat,
				"multiplier": 1.5,
				"duration": 4
			}
			
		"attack_down", "defense_down", "speed_down":
			var stat = status_name.split("_")[0]
			status_effects[status_name] = {
				"stat": stat,
				"multiplier": 0.7,
				"duration": 3
			}
			
		_:
			print("Unknown status effect: ", status_name)
			return
			
	_create_status_icon(status_name)

func process_status_effects() -> void:
	var to_remove = []
	for status in status_effects:
		var effect = status_effects[status]
		effect.duration -= 1
		
		match status:
			"poison", "burn":
				var damage = effect.damage_per_turn
				randomized_item.health = max(0, randomized_item.health - damage)
				print("[%s] %s takes %d damage from %s!" % [name, randomized_item.name, damage, status])
			"paralysis":
				if randf() < effect.miss_chance:
					print("[%s] %s is paralyzed and can't move!" % [name, randomized_item.name])
			"freeze":
				if randf() < effect.skip_turn_chance:
					print("[%s] %s is frozen solid!" % [name, randomized_item.name])
			"sleep":
				if effect.skip_turns > 0:
					print("[%s] %s is fast asleep!" % [name, randomized_item.name])
					effect.skip_turns -= 1
			"confusion":
				if randf() < effect.self_damage_chance:
					var damage = randomized_item.max_health * effect.self_damage_percent
					randomized_item.health = max(0, randomized_item.health - damage)
					print("[%s] %s hurt itself in confusion! (%d damage)" % [name, randomized_item.name, damage])
			"attack_buff", "defense_buff", "speed_buff", "attack_down", "defense_down", "speed_down":
				pass
		if effect.duration <= 0:
			to_remove.append(status)
			print("[%s] %s's %s wore off!" % [name, randomized_item.name, status])
	for status in to_remove:
		status_effects.erase(status)
func _create_status_icon(status_name: String) -> void:
	pass
