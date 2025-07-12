# BattleManager.gd
extends Node
signal request_party_select

# 0 = roaming, 1 = engaged, 2 = win
var state : int = 0
var player: CharacterBody2D
var party: Array[InvItem] = []
var engaged_enemies: Array = []
var enemy_data_list: Array = []
func _unhandled_input(ev):
	if ev.is_action_pressed("battle_win"):
		_give_random_enemy_item()
		print("Debug: Gave random enemy item")

func _ready():
	
	connect("request_party_select", Callable(self, "_on_request_party_select"))
	_check_enemy_items()

func _on_request_party_select():
	if state == 1 and not get_tree().root.has_node("PartySelect"):
		var partyselect = preload("res://Scenes/fixed_party_select.tscn").instantiate()
		partyselect.name = "PartySelect"
		var canvas_layer = get_tree().get_current_scene().get_node("CanvasLayer")
		canvas_layer.add_child(partyselect)
		#get_tree().root.add_child(partyselect)
		print("PartySelect")

	
func _process(_delta):
	if state != 1:
		var partyselect = get_tree().root.get_node_or_null("PartySelect")

		if partyselect:
			partyselect.queue_free()

func extract_enemy_data(enemy:BaseEnemy) -> Dictionary:
	var inv_item := enemy.randomized_item
	return {
		"name": inv_item.name,
		"item": inv_item,
		"node": enemy,
		"stats": {
			"health": inv_item.health,
			"attack": inv_item.attack,
			"defense": inv_item.defense,
			"speed": inv_item.speed,
			"type": inv_item.type
		}
	}

func engage_enemy_group(enemies:Array):
	print("→ Engaging enemy group:", enemies)
	print("→ Engaged enemies:", engaged_enemies, "\nenemy_data_list nodes:", enemy_data_list.map(func(d): return d["node"]))
	print("engage_enemy_group got", enemies.size(), "enemies")
	engaged_enemies = enemies
	enemy_data_list = []
	for enemy in enemies:
		var data = extract_enemy_data(enemy)
		print("Data extracted - node: ", data["node"], " valid: ", is_instance_valid(data["node"]))
		enemy_data_list.append(data)
	state = 1
	emit_signal("request_party_select")
	
	
func _check_enemy_items():
	print("=== Checking enemy scenes for item assignment ===")
	var enemy_paths = [
		"res://Scenes/ant_enemy.tscn",
		"res://Scenes/bat.tscn",
		"res://Scenes/bear.tscn",
		"res://Assets/bettle_enemy.tscn",
		"res://Scenes/dino.tscn",
		"res://Scenes/Dog_enemy.tscn",
		"res://Scenes/eagle.tscn",
		"res://Scenes/ghost.tscn",
		"res://Scenes/bird.tscn",
		"res://Scenes/frog.tscn",
		"res://Scenes/gator.tscn",
		"res://Scenes/grasshopper.tscn",
		"res://Scenes/bossdragon.tscn",
		"res://Scenes/lizzard.tscn",
		"res://Scenes/snake.tscn",
		"res://Scenes/opossum.tscn",
		"res://Scenes/owl.tscn",
		"res://Scenes/pig.tscn",
		"res://Scenes/slimer.tscn",
		"res://Scenes/dragon.tscn",
		"res://Scenes/froggy.tscn",
		"res://Scenes/mushroom.tscn",
		"res://Scenes/vulture.tscn",
		"res://Scenes/winterfox.tscn",
		"res://Scenes/yeti.tscn"
	]

	print("--- Enemy Scene Sanity Check ---")
	for path in enemy_paths:
		var packed = ResourceLoader.load(path)
		if not packed or not packed is PackedScene:
			push_error("❌ Not a PackedScene: %s" % path)
			continue

		var enemy = packed.instantiate()
		
		print("Created inv_item with moves:", enemy.moves)
		
		if not enemy is BaseEnemy:
			push_error("❌ Does not extend BaseEnemy: %s" % path)
			continue
		var has_item_prop := true
		var item_val

		if enemy.has_meta("item"):
			item_val = enemy.get("item")
		else:

			item_val = enemy.get("item") if true else null
		if item_val == null:
			push_error("❌ `item` is null in: %s" % path)
		else:
			print("✔ OK: %s (item = %s)" % [path, item_val])
	print("--- End Sanity Check ---")

func _give_random_enemy_item():
	if engaged_enemies.size() > 0:
		var random_enemy = engaged_enemies[randi()% engaged_enemies.size()]
		if is_instance_valid(random_enemy) and random_enemy.has_method("_drop_loot"):
			var temp_enemy = random_enemy.duplicate()
			temp_enemy.player = player
			temp_enemy._drop_loot()
			temp_enemy.queue_free()
		else:
			print("Temp enemy invalid")
			var temp_enemy = BaseEnemy.new()
			temp_enemy.item = preload("res://Inventory/Items/bettle.tres")
			temp_enemy.player = player
			temp_enemy._ready()
			temp_enemy._drop_loot()
			temp_enemy.queue_free()
