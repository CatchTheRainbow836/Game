extends Control
var TYPE_NAMES := {
	1: "Bug",
	2: "Dark",
	3: "Dragon",
	4: "Electric",
	5: "Fairy",
	6: "Fighting",
	7: "Fire",
	8: "Flying",
	9: "Ghost",
	11: "Ground",
	12: "Ice",
	13: "Normal",
	14: "Poison",
	15: "Psychic",
	16: "Rock",
	17: "Steel",
	18: "Water"
}

const BugEffect = preload("res://BugEffects.tscn")
const DarkEffect = preload("res://DarkEffects.tscn")
const DragonEffect = preload("res://DragonEffects.tscn")
const ElectricEffect = preload("res://ElectricEffects.tscn")
const FairyEffect = preload("res://FairyEffects.tscn")
const FightingEffect = preload("res://FightingEffects.tscn")
const FireEffect = preload("res://FireEffects.tscn")
const FlyingEffect = preload("res://FlyingEffects.tscn")
const GhostEffect = preload("res://GhostEffects.tscn")
const GroundEffect = preload("res://GroundEffects.tscn")
const IceEffect = preload("res://IceEffects.tscn")
const NormalEffect = preload("res://NormalEffects.tscn")
const PoisonEffect = preload("res://PoisonEffects.tscn")
const PsychicEffect = preload("res://PsychicEffects.tscn")
const RockEffect = preload("res://RockEffects.tscn")
const SteelEffect = preload("res://SteelEffects.tscn")
const WaterEffect = preload("res://WaterEffects.tscn")

enum BattleState { READY_FOR_TURN, PLAYER_DECIDING, PROCESSING_MOVE, CHECK_END, BATTLE_OVER}
var _battle_state = BattleState.READY_FOR_TURN
var _processing_actor : Dictionary
var _processing_target

const MAX_SPRITE_SIZE_PARTICIPANTS := Vector2(168,168)
const MAX_SPRITE_SIZE_TIMELINE := Vector2(80,80)

const HEALTHBAR_SIZE = Vector2(80,8)
const HEALTHBAR_MARGIN = 100

var _current_actor : Dictionary= {}
var _selected_move : Dictionary = {}
var _participations := []
var _turn_queue := []
const CHARGE_THRESHOLD := 100
const MAX_SLOTS := 6
@onready var attack_btn = $UI/Option/Attack
@onready var move_list = $UI/Option/MoveList
@onready var target_list = $UI/Option/TargetList
@onready var ui_layer: CanvasLayer = $UI
var message_label : Label
func fit_to_max(sprite: Sprite2D, max_size: Vector2) -> void:
	if not sprite.texture:
		return
	var tex_size = sprite.texture.get_size()
	var scale_factor = min(max_size.x / tex_size.x, max_size.y / tex_size.y)
	sprite.scale = Vector2(scale_factor, scale_factor)

func fit_to_max_timeline(sprite: TextureRect, max_size: Vector2) -> void:
	sprite.scale = Vector2.ONE
	if not sprite.texture:
		return
	var tex_size = sprite.texture.get_size()
	var scale_factor = min(max_size.x / tex_size.x, max_size.y / tex_size.y)
	sprite.scale = Vector2(scale_factor, scale_factor)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("▶︎ attack_btn reference: ", attack_btn)
	print("▶︎ attack_btn.visible:   ", attack_btn.visible)
	print("▶︎ attack_btn.disabled:  ", attack_btn.disabled)
	print("▶︎ attack_btn.mouse_filter:", attack_btn.mouse_filter)
	_populate_player_sprites()
	_populate_enemy_sprites()
	_populate_timeline()
	_create_health_bars()
	attack_btn.hide()
	if not attack_btn.is_connected("pressed", Callable(self, "_on_attack_pressed")):
		attack_btn.connect("pressed", Callable(self, "_on_attack_pressed"))
	move_list.visible = false
	target_list.visible = false
	#get_tree().paused = true

	if not ui_layer.has_node("MessageLabel"):
		var msg = Label.new()
		msg.name = "MessageLabel"
		msg.text = ""
		msg.anchor_left=0.0
		msg.anchor_top=0.0
		msg.anchor_right=1.0
		msg.anchor_bottom=0.0
		msg.visible = true
		ui_layer.add_child(msg)
	message_label = ui_layer.get_node("MessageLabel") as Label
	_init_participants()
	
	_update_all_huds()
func _create_health_bars():
	var red_texture = _create_red_texture()
	for i in range(BattleManager.party.size()):
		var hud = _create_health_bar(red_texture)
		hud.name = "HUD_Player%d" % (i+1)
		ui_layer.add_child(hud)
	for i in range(BattleManager.enemy_data_list.size()):
		var hud = _create_health_bar(red_texture)
		hud.name = "HUD_Enemy%d" % (i+1)
		ui_layer.add_child(hud)

func _create_health_bar(texture: Texture2D) -> Control:
	var container = Control.new()
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bar = TextureProgressBar.new()
	bar.name = "HealthBar"
	bar.texture_progress = texture
	bar.fill_mode = TextureProgressBar.FILL_LEFT_TO_RIGHT
	bar.custom_minimum_size = HEALTHBAR_SIZE
	bar.size = HEALTHBAR_SIZE
	
	var label = Label.new()
	label.name = "HealthLabel"
	label.text = "0/0"
	label.add_theme_font_size_override("font_size", 12)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(0,HEALTHBAR_SIZE.y + 2)
	label.custom_minimum_size = Vector2(HEALTHBAR_SIZE.x, 20)
	
	container.add_child(bar)
	container.add_child(label)
	return container
	
func _create_red_texture() -> Texture2D:
	var image = Image.create(1,1,false,Image.FORMAT_RGBA8)
	image.fill(Color(1,0,0,1))
	return ImageTexture.create_from_image(image)
func _populate_player_sprites():
	var party := BattleManager.party
	for i in party.size():
		var inv_item : InvItem = party[i]
		var path = "Players/Player%d" % (i+1)
		if not has_node(path):
			push_error("Could not find player slot at '%s'"% path)
			
		var slot = get_node(path) as Sprite2D
		slot.texture = inv_item.texture
		fit_to_max(slot,MAX_SPRITE_SIZE_PARTICIPANTS)
		slot.centered = true
		#slot.offset = Vector2(0, -slot.texture.get_height() / 2 * slot.scale.y)
		slot.top_level = true
		


		
func _populate_enemy_sprites():
	var data_list = BattleManager.enemy_data_list
	for i in range(data_list.size()):
		var data = data_list[i]
		var inv_item = data["item"] as InvItem
		
		var path = "Enemies/Enemy%d" % (i+1)
		if not has_node(path):
			push_error("Could not find enemy slot at '%s'" % path)
			continue
			
		var slot = get_node(path) as Sprite2D
		slot.texture = inv_item.texture
		fit_to_max(slot,MAX_SPRITE_SIZE_PARTICIPANTS)
		slot.centered = true
		#slot.offset = Vector2(0, -slot.texture.get_height() / 2 * slot.scale.y)
		slot.top_level = true
		

func _populate_timeline():
	var participants = []
	var player_count := BattleManager.party.size()
	var enemy_count := BattleManager.enemy_data_list.size()
	
	for i in range(player_count):
		var inv_item = BattleManager.party[i]
		var sprite_path = "Players/Player%d" % (i+1)
		var sprite_node = get_node(sprite_path) as Sprite2D
		participants.append({
			"node": sprite_node,
			"speed": inv_item.speed,
			"inv_item": inv_item
		})
		
	for i in range(enemy_count):
		var inv_item = BattleManager.enemy_data_list[i]["item"]
		var sprite_path = "Enemies/Enemy%d" % (i+1)
		var sprite_node = get_node(sprite_path) as Sprite2D
		participants.append({
			"node": sprite_node,
			"speed": inv_item.speed,
			"inv_item": inv_item
		})
	participants.sort_custom(_compare_speed)
	
	for idx in range(participants.size()):
		var timeline_slot_path = "UI/Timeline/TimelineSlot%d/TextureRect" % (idx+1)
		if not has_node(timeline_slot_path):
			push_error("Missing timeline slot: %s" % timeline_slot_path)
			continue
		var texture_rect = get_node(timeline_slot_path) as TextureRect
		texture_rect.texture = participants[idx]["inv_item"].texture
		#texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		#texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		texture_rect.expand_mode = TextureRect.SIZE_EXPAND_FILL
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		fit_to_max_timeline(texture_rect,MAX_SPRITE_SIZE_TIMELINE)
		texture_rect.pivot_offset = texture_rect.size * 0.5

func _compare_speed(a,b):
	return b["speed"] - a ["speed"]

func _on_attack_pressed():
	attack_btn.hide()
	var player_index = 0
	_current_actor = {
		"node": get_node("Players/Player%d" % (player_index+1)) as Sprite2D,
		"inv_item": BattleManager.party[player_index]
	}
	_show_move_list()
	
	print("children:", move_list.get_child_count())
	for child in move_list.get_children():
		print("  –", child, "rect:", (child as Control).size)
	
	_battle_state = BattleState.PLAYER_DECIDING

func _show_move_list():
	print("DEBUG: _show_move_list called")
	print("  current_actor:", _current_actor)
	print("  current_actor.inv_item:", _current_actor.inv_item)
	print("  type(inv_item):", typeof(_current_actor.inv_item))
	print("  inv_item has moves?:", _current_actor.inv_item.has_method("get_moves") or _current_actor.inv_item.has_meta("moves"))
	for c in move_list.get_children():
		c.queue_free()
	var hdr = Label.new()
	hdr.text = "Choose move for %s (HP:%d)" % [
		_current_actor.inv_item.name,
		_current_actor.inv_item.health
	]
	move_list.add_child(hdr)
	print("DEBUG: inv_item has properties: ", _current_actor.inv_item.get_property_list())
	if _current_actor.inv_item.moves:
		print("  moves list has %s moves" % _current_actor.inv_item.moves.size())
		print("DEBUG: inv_item has properties: ", _current_actor.inv_item.get_property_list())
		for move in _current_actor.inv_item.moves:
			print("Creating new button (button.new())")
			var b = Button.new()
			b.text = "%s (pwr %s)" % [move.name,move.power]
			b.connect("pressed", _on_move_selected.bind(move))
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.custom_minimum_size = Vector2(0,40)
			move_list.add_child(b)
	else:
		print("  ERROR: inv_item.moves is empty or null")
	move_list.visible = true

func _on_move_selected(move: Dictionary):
	_selected_move = move
	move_list.visible = false
	_show_target_list()


func _show_target_list():
	
	for c in target_list.get_children():
		c.queue_free()
	print("--- VALIDATING ENEMIES --- BattleUI.gd")
	print("--- SHOW_TARGET_LIST: enemy_data_list has %d entries ---" % BattleManager.enemy_data_list.size())
	for i in range(BattleManager.enemy_data_list.size()):
		print("  data[%d] keys:" % i, BattleManager.enemy_data_list[i].keys())
		var enemy = BattleManager.enemy_data_list[i]
		print("  Valid Node: %s" % is_instance_valid(enemy.node))
		print("  Health: %s" % enemy.stats.health if enemy.get("stats") else "NO STATS")
		#print("  Keys: %s" % enemy.keys())
		print("Enemy %d:" % i)
	var hdr = Label.new()
	hdr.text = "Pick a target"
	target_list.add_child(hdr)
	
	for idx in range(BattleManager.enemy_data_list.size()):
		var enemy_data = BattleManager.enemy_data_list[idx]
		var enemy_node = enemy_data["node"]
		if not is_instance_valid(enemy_node):
			print("Skipping invalid enemy at index ", idx)
			continue
		var b = Button.new()
		var inv = enemy_data["item"] as InvItem
		
		if inv.health <= 0:
			continue
		b.text = "%s (HP:%d Spd:%d Atk:%d Def:%d)" % [
			inv.name,
			inv.health,
			inv.speed,
			inv.attack,
			inv.defense
		]
		b.set_meta("target_index", idx)
		b.connect("pressed", Callable(self, "_on_target_selected").bind(b))
		target_list.add_child(b)
	target_list.visible = true

func _on_target_selected(button: Button) -> void:
	var idx = button.get_meta("target_index")
	
	var enemy_data = BattleManager.enemy_data_list[idx]
	var inv_item = enemy_data["item"] as InvItem
	var enemy_node = enemy_data["node"]
	if not is_instance_valid(enemy_node):
		push_error("Tried to select invalid enemy at index %d" % idx)
		target_list.visible = false
		return
	target_list.visible = false
	_processing_target = enemy_node
	
	move_list.visible = false
	if _selected_move.has("status") and randi() % 100 < _selected_move.status_chance:
		_show_message("%s was afflicted with %s!" % [enemy_node.randomized_item.name, _selected_move.status])
		
	_battle_state = BattleState.PROCESSING_MOVE
	_execute_move()

func _enemy_take_turn():
	if _processing_actor["node"] is BaseEnemy:
		_processing_actor["node"].process_status_effects()
	var moves = _processing_actor.inv_item.moves
	if moves and moves.size() > 0:
		_selected_move = moves[randi() % moves.size()]
	else:
		print("using fallback moves")
		_selected_move = {"name": "Tackle", "power": 50, "type": 13, "accuracy": 100}
		
	var live_players = []
	for p in _participations:
		if p["is_player"] and p["inv_item"].health > 0:
			live_players.append(p["node"])
	if live_players.size() > 0:
		_processing_target = live_players[randi() % live_players.size()]
		_execute_move()
	else:
		print("no players left")
		_battle_state = BattleState.CHECK_END
func _execute_move():
	if not is_instance_valid(_processing_target):
		_show_message("Target is no longer valid!")
		_battle_state = BattleState.CHECK_END
		return
	
	#var start_pos = _processing_actor["node"].get_screen_transform().origin
	#var end_pos = _processing_target.get_screen_transform().origin
	
	var start_pos = get_debug_position(_processing_actor["node"])
	var end_pos = get_debug_position(_processing_target)
	
	#if _processing_actor["node"] and is_instance_valid(_processing_actor["node"]):
		#start_pos = _processing_actor["node"].global_position
	
	#if _processing_target is BaseEnemy or Sprite2D:
		#end_pos = _processing_target.global_position
	#else:
		#push_error("Invalid target type: ", _processing_target)
		#_battle_state = BattleState.CHECK_END
		#return
		
	#if not _selected_move or not _selected_move.has("type"):
		#push_error("Selected move is invalid: ", _selected_move)
		#_battle_state = BattleState.CHECK_END
		#return
	if start_pos != Vector2.ZERO and end_pos != Vector2.ZERO:
		
		var start_marker = _create_debug_marker(start_pos,Color.RED)
		var end_marker = _create_debug_marker(end_pos, Color.GREEN)
		add_child(start_marker)
		add_child(end_marker)
		
		print("Particle Start Position: ", start_pos)
		print("Particle End Position: ", end_pos)
		print("Actor Node: ", _processing_actor["node"].name if _processing_actor["node"] else "null")
		print("Target Node: ", _processing_target.name if _processing_target else "null")
		
		
		
		var effect_scene : PackedScene
		match _selected_move.type:
			1: effect_scene = BugEffect
			2: effect_scene = DarkEffect
			3: effect_scene = DragonEffect
			4: effect_scene = ElectricEffect
			5: effect_scene = FairyEffect
			6: effect_scene = FightingEffect
			7: effect_scene = FireEffect
			8: effect_scene = FlyingEffect
			9: effect_scene = GhostEffect
			11: effect_scene = GroundEffect
			12: effect_scene = IceEffect
			13: effect_scene = NormalEffect
			14: effect_scene = PoisonEffect
			15: effect_scene = PsychicEffect
			16: effect_scene = RockEffect
			17: effect_scene = SteelEffect
			18: effect_scene = WaterEffect
		if effect_scene:
			var fx = effect_scene.instantiate() as CPUParticles2D
			add_child(fx)
			fx.global_position = start_pos
			fx.lifetime = 3
			fx.explosiveness = 0
			fx.one_shot = false
			fx.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
			#change this as well
			fx.emission_sphere_radius = 20
			fx.amount = 3000
			
			await get_tree().process_frame
			
			var material = fx.get("process_material")
			if material:
				#change the material.set for sizes
				material.set("scale_min", 25)
				material.set("scale_max", 40)
				var gradient = Gradient.new()
				gradient.colour_ramp.add_point(0.0, Color(1,1,1,1))
				gradient.color_ramp.add_point(0.66, Color(1,1,1,1))
				gradient.color_ramp.add_point(1.0, Color(1,1,1,0))
				material.set("color_ramp", gradient)
			fx.emitting = true
			
			
			var tween = create_tween()
			tween.tween_property(fx, "global_position", end_pos, 2)
			tween.tween_interval(1.0)
			tween.tween_callback(Callable(fx, "queue_free"))
			await tween.finished
	
	
	if _processing_actor["is_player"]:
		_deal_damage_to_enemy(_processing_actor.inv_item, _selected_move, _processing_target)
	else:
		if _processing_target is Sprite2D:
			for p in _participations:
				if p["node"] == _processing_target and p["is_player"]:
					_deal_damage_to_player(_processing_actor.inv_item, _selected_move, p["inv_item"])
					break
		else:
			push_error("Invalid target type for enemy attack: ", _processing_target)
	_battle_state = BattleState.CHECK_END

func get_debug_position(node):
	var debug_spot = node.get_node_or_null("DebugSpot")
	return debug_spot.global_position if debug_spot else node.global_position
	

func _handle_end_of_move():
	_participations = _participations.filter(func(p): return p.inv_item.health > 0)
	_turn_queue = _turn_queue.filter(func(p): return p.inv_item.health > 0)
	var any_enemies_left = _participations.any(func(p): return not p.is_player)
	var any_players_left = _participations.any(func(p): return p.is_player)
	if not any_enemies_left:
		BattleManager.state = 2 
		_battle_state = BattleState.BATTLE_OVER
		get_tree().paused = false
		_grant_item_drops()
	elif not any_players_left:
		BattleManager.state = -1
		_battle_state = BattleState.BATTLE_OVER
		get_tree().paused = false
	else:
		_battle_state = BattleState.READY_FOR_TURN
		if _turn_queue.size() == 0:
			_refill_turn_queue()

func _refill_turn_queue():
	_turn_queue.clear()
	for p in _participations:
		if p.inv_item.health > 0:
			p.charge = clamp(p.charge, 0, CHARGE_THRESHOLD - 1)

	
func _deal_damage(attacker: InvItem, move: Dictionary, defender: BaseEnemy):
	if randi() % 100>= move.accuracy:
		_show_message("%s’s %s missed!" % [attacker.name, move.name])
		return
	var base = attacker.attack + move.power - defender.randomized_item.defense
	var dmg = max(1,base)
	
	if move.type in attacker.type:
		dmg = int(dmg * 1.5)
	
	var eff = _type_effectiveness(move.type, defender.randomized_item.type)
	dmg = int (dmg * eff)
	
	defender.randomized_item.health = max(0,defender.randomized_item.health - dmg)
	print("%s used %s → %s took %d damage! (×%.1f)" %
		[attacker.name, move.name, defender.randomized_item.name, dmg, eff])
	
	var enemy_index = -1
	for i in range(BattleManager.enemy_data_list.size()):
		if BattleManager.enemy_data_list[i]["node"] == defender:
			enemy_index = i
			break
	if enemy_index >= 0:
		var hud_path = "$UI/HUD_Enemy%d" % (enemy_index + 1)
		if has_node(hud_path):
			var hud = get_node(hud_path) as Control
			var bar = hud.get_node("HealthBar") as TextureProgressBar
			var label = hud.get_node("HealthLabel") as Label
			
			bar.value = defender.randomized_item.health
			bar.max_value = defender.randomized_item.max_health
			label.text = "%d / %d" % [bar.value, bar.max_value]
			
	
	if defender.randomized_item.health <= 0:
		_handle_defeated_enemy(defender)
	if move.has("status") and randi() % 100 < move.status_chance:
		defender.apply_status(move.status)
	
	if _turn_queue.size() > 0:
		var front = _turn_queue[0]
		if front.has("inv_item") and _processing_actor.has("inv_item"):
			if front["inv_item"] == _processing_actor["inv_item"]:
				_turn_queue.pop_front()
	_update_timeline_ui()
	_update_all_huds()

func _deal_damage_to_player(attacker: InvItem, move: Dictionary, defender_inv: InvItem):
	if randi()%100 >= move.accuracy:
		_show_message("%s's %s missed!" % [attacker.name, move.name])
		return
	
	var base = attacker.attack + move.power - defender_inv.defense
	var dmg = max(1,base)
	
	if move.type in attacker.type:
		dmg = int(dmg * 1.5)
	
	var eff = _type_effectiveness(move.type, defender_inv.type)
	dmg = int(dmg*eff)
	
	defender_inv.health = max(0,defender_inv.health - dmg)
	print("%s used %s -> %s took %d damage! (x%.1f)" % [attacker.name, move.name, defender_inv.name, dmg, eff])
	if defender_inv.health <=0:
		_handle_defeated_player(defender_inv)
	var player_index = BattleManager.party.find(defender_inv)
	if player_index >= 0:
		var hud_path = "UI/HUD_Player%d" % (player_index+1)
		if has_node(hud_path):
			var hud = get_node(hud_path)
			var bar = hud.get_node("HealthBar") as TextureProgressBar
			var label = hud.get_node("HealthLabel") as Label
			
			bar.value = defender_inv.health
			bar.max_value = defender_inv.max_health
			label.text = "%d / %d" % [bar.value, bar.max_value]
	if move.has("status") and randi() % 100 < move.status_chance:
		pass
	if _turn_queue.size() > 0:
		var front = _turn_queue[0]
		if front.has("inv_item") and _processing_actor.has("inv_item"):
			if front["inv_item"] == _processing_actor["inv_item"]:
				_turn_queue.pop_front()
	_update_timeline_ui()
	_update_all_huds()

func _deal_damage_to_enemy(attacker: InvItem, move: Dictionary, defender: BaseEnemy):
	if not is_instance_valid(defender):
		_show_message("The enemy is already defeated!")
		return
	if randi()%100 >= move.accuracy:
		_show_message("%s's %s missed!" % [attacker.name, move.name])
		return
	
	var base = attacker.attack + move.power - defender.randomized_item.defense
	var dmg = max(1,base)
	
	if move.type in attacker.type:
		dmg = int(dmg * 1.5)
	
	var eff = _type_effectiveness(move.type, defender.randomized_item.type)
	dmg = int(dmg*eff)
	
	defender.randomized_item.health = max(0,defender.randomized_item.health - dmg)
	print("%s used %s -> %s took %d damage! (x%.1f)" % [attacker.name, move.name, defender.randomized_item.name, dmg, eff])
	var enemy_index = 1
	for i in range(BattleManager.enemy_data_list.size()):
		if BattleManager.enemy_data_list[i]["node"] == defender:
			enemy_index = i
			break
	if enemy_index >= 0:
		var hud_path = "UI/HUD_Enemy%d" % (enemy_index + 1)
		if has_node(hud_path):
			var hud = get_node(hud_path) as Control
			var bar = hud.get_node("HealthBar") as TextureProgressBar
			var label = hud.get_node("HealthLabel") as Label
			
			bar.value = defender.randomized_item.health
			bar.max_value = defender.randomized_item.max_health
			label.text = "%d / %d" % [bar.value, bar.max_value]
	if defender.randomized_item.health <= 0:
		_handle_defeated_enemy(defender)
	if move.has("status") and randi() % 100 < move.status_chance:
		defender.apply_status(move.status)
	if _turn_queue.size() > 0:
		var front = _turn_queue[0]
		if front.has("inv_item") and _processing_actor.has("inv_item"):
			if front["inv_item"] == _processing_actor["inv_item"]:
				_turn_queue.pop_front()
	_update_timeline_ui()
	_update_all_huds()
func _handle_defeated_player(inv: InvItem):
	var player_index = BattleManager.party.find(inv)
	if player_index < 0:
		return
	var player_path = "Players/Player%d" % (player_index+1)
	if has_node(player_path):
		var player_sprite = get_node(player_path)
		player_sprite.queue_free()
	var hud_path = "UI/HUD_Player%d" % (player_index+1)
	if has_node(hud_path):
		var hud = get_node(hud_path)
		hud.queue_free()
func _handle_defeated_enemy(defender: BaseEnemy):
	defender.queue_free()
	var manager = BattleManager
	var idx = -1
	for i in range(manager.enemy_data_list.size()):
		if manager.enemy_data_list[i]["node"] == defender:
			idx = i
			break
	if idx >= 0:
		manager.engaged_enemies.remove_at(idx)
		manager.enemy_data_list.remove_at(idx)
		
		var enemy_path = "Enemies/Enemy%d" % (idx+1)
		if has_node(enemy_path):
			var enemy_sprite = get_node(enemy_path)
			enemy_sprite.queue_free()
		var hud_path = "UI/HUD_Enemy%d" % (idx+1)
		if has_node(hud_path):
			var hud = get_node(hud_path)
			hud.queue_free()
		defender.queue_free()
#	var enemy_index = -1
#	for i in range(BattleManager.enemy_data_list.size()):
#		if BattleManager.enemy_data_list[i]["node"] == defender:
#			enemy_index = i
#			break
#	if enemy_index >= 0:
#		var enemy_path = "Enemies/Enemy%d" % (enemy_index + 1)
#		if has_node(enemy_path):
#			var enemy_sprite = get_node(enemy_path)
#			enemy_sprite.queue_free()
	
	
func _init_participants():
	_participations.clear()
	for i in range(BattleManager.party.size()):
		var item = BattleManager.party[i]
		_participations.append({"inv_item": item, "node": get_node("Players/Player%d" % (i+1))as Sprite2D,"speed":item.speed,"charge":0.0, "is_player": true})
	for i in range(BattleManager.enemy_data_list.size()):
		var item = BattleManager.enemy_data_list[i]["item"] as InvItem
		_participations.append({"inv_item": item, "node":get_node("Enemies/Enemy%d" % (i+1)) as Sprite2D,"speed":item.speed,"charge":0.0, "is_player": false})
	_turn_queue.clear()
	_update_timeline_ui()

func _update_timeline_ui():
	for i in range(MAX_SLOTS):
		var slot_path = "UI/Timeline/TimelineSlot%d/TextureRect" % (i+1)
		var text_rect = get_node_or_null(slot_path) as TextureRect
		if not text_rect:
			continue
		if i < _turn_queue.size():
			text_rect.texture = _turn_queue[i].inv_item.texture
		else:
			text_rect.texture = null
				
func _process(delta: float) -> void:
	if _battle_state == BattleState.BATTLE_OVER:
		return
	var turns_added = 0
	for p in _participations:
		if p.inv_item.health > 0:
			p.charge += p.speed * delta
			while p.charge >= CHARGE_THRESHOLD && turns_added < MAX_SLOTS:
				p.charge -= CHARGE_THRESHOLD
				_turn_queue.append(p)
				turns_added += 1
	for p in _participations:
		p.charge += p.speed * delta
		while p.charge >= CHARGE_THRESHOLD:
			p.charge -= CHARGE_THRESHOLD
			_turn_queue.append(p)
		if _turn_queue.size() > MAX_SLOTS * 2:
			_turn_queue = _turn_queue.slice(0,MAX_SLOTS*2)
		_update_timeline_ui()
		_update_all_huds()
	
	match _battle_state:
		BattleState.READY_FOR_TURN:
			if _turn_queue.size() > 0:
				_start_next_turn()
		BattleState.CHECK_END:
			_handle_end_of_move()

func _start_next_turn():
	_processing_actor = _turn_queue.pop_front()
	if _processing_actor["is_player"]:
		attack_btn.show()
		_battle_state = BattleState.PLAYER_DECIDING
	else:
		_battle_state = BattleState.PROCESSING_MOVE
		_enemy_take_turn()

func _show_message(text:String):
	message_label.text = text

func _type_effectiveness(atk_type:int, def_types:Array) -> float:
	var super_eff = {
		1: [13,14],    # Bug→Normal/Poison
		4: [18,7],     # Electric→Water/Fire
		7: [1,12],     # Fire→Bug/Ice
		8: [1,7],      # Flying→Bug/Fire
		9: [15],       # Ghost→Psychic
		11: [7,12,18], # Ground→Fire/Ice/Water
		12: [4],       # Ice→Electric
		14: [13],      # Poison→Normal
		15: [6,17],    # Psychic→Fighting/Steel
		16: [8,9],     # Rock→Flying/Ghost
		18: [7,16]     # Water→Fire/Rock
	}
	var not_eff = {
		1: [4,7,11],   # Bug resists Electric/Fire/Ground
		4: [16],       # Electric resists Rock
		7: [15,18],    # Fire resists Psychic/Water
		8: [1,16],     # Flying resists Bug/Rock
		9: [15],       # Ghost resists Psychic
		11:[1,16],     # Ground resists Bug/Rock
		12:[12],       # Ice resists itself
		14:[13,17],    # Poison resists Normal/Steel
		15:[15],       # Psychic resists itself
		16:[4,11],     # Rock resists Electric/Ground
		18:[7,16]      # Water resists Fire/Rock
	}
	var mult = 1.0
	for dt in def_types:
		if super_eff.get(atk_type, []).has(dt):
			mult *= 2.0
		elif not_eff.get(atk_type, []).has(dt):
			mult *= 0.5
	return mult
	

func _world_to_ui_pos(world_pos: Vector2) -> Vector2:
	return get_viewport_transform().basis_xform(world_pos)

func _update_all_huds():
	for i in BattleManager.party.size():
		var sprite = get_node("Players/Player%d" % (i+1)) as Sprite2D
		var inv    = BattleManager.party[i]
		_update_hud(sprite, ui_layer.get_node("HUD_Player%d" % (i+1)) as Control, inv)
	for i in BattleManager.enemy_data_list.size():
		var sprite = get_node("Enemies/Enemy%d" % (i+1)) as Sprite2D
		var inv    = BattleManager.enemy_data_list[i]["item"] as InvItem
		_update_hud(sprite, ui_layer.get_node("HUD_Enemy%d" % (i+1)) as Control, inv)


func _update_hud(sprite: Sprite2D, hud: Control, inv: InvItem) -> void:
	var bar = hud.get_node("HealthBar") as TextureProgressBar
	var label = hud.get_node("HealthLabel") as Label
	
	# Get screen position
	var screen_pos = sprite.get_screen_transform().origin
	
	# Position healthbar above the sprite
	hud.position = Vector2(
		screen_pos.x - HEALTHBAR_SIZE.x / 2,
		screen_pos.y - HEALTHBAR_MARGIN
	)
	

	bar.max_value = inv.max_health
	bar.value = inv.health
	label.text = "%d/%d" % [inv.health, inv.max_health]
	
	hud.visible = true
func _grant_item_drops():
	print("should give items now")
	pass


#Debug Stuff
func _create_debug_marker(position: Vector2, color: Color) -> Sprite2D:
	var marker =Sprite2D.new()
	marker.texture = _create_debug_texture(color)
	marker.position = position
	marker.scale = Vector2(0.2,0.2)
	marker.z_index =  1000
	return marker
func _create_debug_texture(color: Color) -> Texture2D:
	var image = Image.create(16,16,false,Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
	
