extends Node2D
func _ready() -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	get_tree().root.size = Vector2i(1152, 648)
	print("Player global_position at start: ", $CharacterBody2D.global_position)
	print("SpawnerNodePositions ", $TeamA/SpawnerA1.position)
	print("SpawnerNodePositions ", $TeamA/SpawnerA2.position)
	print("SpawnerNodePositions ", $TeamA/SpawnerA3.position)
	print("Spawner's location in editor", $Label2.position)
	print("World Root: ", get_tree().get_current_scene().name)
	_check_all_enemy_scenes()
	


func _check_all_enemy_scenes():
	print("=== STARTING ENEMY SCENE VALIDATION ===")
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
	
	# Track issues per scene
	var scene_issues = {}
	
	for path in enemy_paths:
		if not ResourceLoader.exists(path):
			push_error("SCENE NOT FOUND: " + path)
			scene_issues[path] = ["Scene file not found"]
			continue
			
		var scene = load(path)
		var instance = scene.instantiate()
		print("\n--- Checking: ", path, " ---")
		
		var issues = []
		
		# 1. Verify BaseEnemy inheritance
		if not instance is BaseEnemy:
			issues.append("❌ DOES NOT EXTEND BaseEnemy")
			push_error("Critical: " + path + " does not extend BaseEnemy")
			instance.queue_free()
			scene_issues[path] = issues
			continue
		
		# 2. Check item property
		if "item" in instance and instance.item:
			var item = instance.item
			
			# Only validate static properties that should be set
			if not item.texture:
				issues.append("⚠️ Item missing texture")
			
			if not item.type or item.type.size() == 0:
				issues.append("⚠️ Item missing type")
		else:
			issues.append("❌ MISSING 'item' PROPERTY")
			push_error("Critical: " + path + " is missing item property")
		
		# 3. Check critical methods (only report missing ones)
		if not instance.has_method("_randomize_stats"):
			issues.append("❌ MISSING _randomize_stats METHOD")
			push_error("Critical: " + path + " missing _randomize_stats")
		
		# 4. Verify moves assignment
		if instance.has_method("_randomize_stats"):
			var test_item = InvItem.new()
			instance._randomize_stats(test_item)
			
			if not test_item.moves or test_item.moves.size() == 0:
				issues.append("❌ NO MOVES ASSIGNED")
				push_error("Critical: " + path + " has no moves after _randomize_stats")
			else:
				for move in test_item.moves:
					if not move.get("name", ""):
						issues.append("⚠️ Move missing name")
					if not move.get("type", 0):
						issues.append("⚠️ Move missing type: " + str(move.get("name", "Unknown")))
		
		# 5. Check randomized_item initialization
		if instance.has_method("_ready"):
			# Add to scene tree to allow _ready to work properly
			get_tree().root.add_child.call_deferred(instance)
			instance._ready()
			
			if not instance.randomized_item:
				issues.append("❌ randomized_item NOT INITIALIZED")
				#push_error("Critical: " + path + " failed to initialize randomized_item")
			else:
				# Check for obviously invalid values
				if instance.randomized_item.health <= 0:
					issues.append("⚠️ Invalid health: " + str(instance.randomized_item.health))
				if instance.randomized_item.attack <= 0:
					issues.append("⚠️ Invalid attack: " + str(instance.randomized_item.attack))
				if instance.randomized_item.defense <= 0:
					issues.append("⚠️ Invalid defense: " + str(instance.randomized_item.defense))
				if instance.randomized_item.speed <= 0:
					issues.append("⚠️ Invalid speed: " + str(instance.randomized_item.speed))
			
			# Clean up
			instance.queue_free()
		else:
			issues.append("❌ MISSING _ready METHOD")
			push_error("Critical: " + path + " missing _ready method")
			instance.queue_free()
		
		# Store issues for final report
		if issues.size() > 0:
			scene_issues[path] = issues
		else:
			print("✔ Scene passed all checks")
	
	# Print final summary
	print("\n=== VALIDATION SUMMARY ===")
	if scene_issues.size() == 0:
		print("✔ ALL ENEMY SCENES PASSED VALIDATION")
	else:
		print("❌ FOUND ISSUES IN ", scene_issues.size(), " SCENES:")
		for path in scene_issues:
			print("\n--- ", path, " ---")
			for issue in scene_issues[path]:
				print("  - ", issue)
	
	print("=== VALIDATION COMPLETE ===")
