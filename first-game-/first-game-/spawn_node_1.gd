extends Node2D
class_name SpawnNode1
var spawned_enemies: Array[BaseEnemy] = []

@export var ready_for_battle: bool = true 
@export var enemynumber: int

@onready var timer: Timer = $Timer
@export var SpawnScene1: PackedScene = preload("res://Scenes/ant_enemy.tscn")
@export var SpawnScene2: PackedScene = preload("res://Scenes/bat.tscn")
@export var SpawnScene3: PackedScene = preload("res://Scenes/bear.tscn")
@export var SpawnScene4: PackedScene = preload("res://Assets/bettle_enemy.tscn")
@export var SpawnScene5: PackedScene = preload("res://Scenes/dino.tscn")
@export var SpawnScene6: PackedScene = preload("res://Scenes/Dog_enemy.tscn")
@export var SpawnScene7: PackedScene = preload("res://Scenes/eagle.tscn")
@export var SpawnScene8: PackedScene = preload("res://Scenes/ghost.tscn")
@export var SpawnScene9: PackedScene = preload("res://Scenes/bird.tscn")
@export var SpawnScene10: PackedScene = preload("res://Scenes/frog.tscn")
@export var SpawnScene11: PackedScene = preload("res://Scenes/gator.tscn")
@export var SpawnScene12: PackedScene = preload("res://Scenes/grasshopper.tscn")
@export var SpawnScene13: PackedScene = preload("res://Scenes/bossdragon.tscn")
@export var SpawnScene14: PackedScene = preload("res://Scenes/lizzard.tscn")
@export var SpawnScene15: PackedScene = preload("res://Scenes/snake.tscn")
@export var SpawnScene16: PackedScene = preload("res://Scenes/opossum.tscn")
@export var SpawnScene17: PackedScene = preload("res://Scenes/owl.tscn")
@export var SpawnScene18: PackedScene = preload("res://Scenes/pig.tscn")
@export var SpawnScene19: PackedScene = preload("res://Scenes/slimer.tscn")
@export var SpawnScene20: PackedScene = preload("res://Scenes/dragon.tscn")
@export var SpawnScene21: PackedScene = preload("res://Scenes/froggy.tscn")
@export var SpawnScene22: PackedScene = preload("res://Scenes/mushroom.tscn")
@export var SpawnScene23: PackedScene = preload("res://Scenes/vulture.tscn")
@export var SpawnScene24: PackedScene = preload("res://Scenes/winterfox.tscn")
@export var SpawnScene25: PackedScene = preload("res://Scenes/yeti.tscn")

func _ready() -> void:
	print(" → [frame 0] spawner.global_position (immediately): ", global_position)
	await get_tree().process_frame
	print(" → [frame 1] spawner.global_position (after one frame): ", global_position)
	timer.timeout.connect(Callable(self,"_on_timer_timeout"))
	print("Spawner global position: ", global_position)
	print("SpawnerNodePositions", self.position)
	print("Spawner editor pos (approx):", self.position)
	print("Spawner runtime global pos:", self.global_position)
	print("Spawner parent node:", get_parent())
	print("Spawner _ready position:", position)
	print("Spawner global position:", global_position)
	_spawn_next() 

func _on_timer_timeout() -> void:
	_spawn_next()

func _spawn_next() -> void:
	if not ready_for_battle:
		return
		
	ready_for_battle = false
	enemynumber = randi_range(1,25)
	
	match enemynumber:
		1:
			_instance(SpawnScene1)
			print("SpawnNode1: spawned ant")
		2: 
			_instance(SpawnScene2)
			print("SpawnNode1: spawned bat")
		3: 
			_instance(SpawnScene3)
			print("SpawnNode1: spawned bear")
		4: 
			_instance(SpawnScene4)
			print("SpawnNode1: spawned bettle")
		5: 
			_instance(SpawnScene5)
			print("SpawnNode1: spawned dino")
		6: 
			_instance(SpawnScene6)
			print("SpawnNode1: spawned dog")
		7: 
			_instance(SpawnScene7)
			print("SpawnNode1: spawned eagle")
		8: 
			_instance(SpawnScene8)
			print("SpawnNode1: spawned ghost")
		9: 
			_instance(SpawnScene9)
			print("SpawnNode1: spawned bird")
		10: 
			_instance(SpawnScene10)
			print("SpawnNode1: spawned frog")
		11: 
			_instance(SpawnScene11)
			print("SpawnNode1: spawned gator")
		12: 
			_instance(SpawnScene12)
			print("SpawnNode1: spawned grasshopper")
		13: 
			_instance(SpawnScene13)
			print("SpawnNode1: spawned bossdragon")
		14: 
			_instance(SpawnScene14)
			print("SpawnNode1: spawned lizzard")
		15: 
			_instance(SpawnScene15)
			print("SpawnNode1: spawned snake")
		16: 
			_instance(SpawnScene16)
			print("SpawnNode1: spawned opossum")
		17: 
			_instance(SpawnScene17)
			print("SpawnNode1: spawned owl")
		18: 
			_instance(SpawnScene18)
			print("SpawnNode1: spawned pig")
		19: 
			_instance(SpawnScene19)
			print("SpawnNode1: spawned slimer")
		20: 
			_instance(SpawnScene20)
			print("SpawnNode1: spawned dragon")
		21: 
			_instance(SpawnScene21)
			print("SpawnNode1: spawned froggy")
		22: 
			_instance(SpawnScene22)
			print("SpawnNode1: spawned mushroom")
		23: 
			_instance(SpawnScene23)
			print("SpawnNode1: spawned vulture")
		24: 
			_instance(SpawnScene24)
			print("SpawnNode1: spawned winterfox")
		25: 
			_instance(SpawnScene25)
			print("SpawnNode1: spawned yeti")
		_:
			return
			


func _instance(scene: PackedScene):
	var new_enemy = scene.instantiate()
	print(">>> Instanced a", new_enemy, 
		" — new_enemy is BaseEnemy? ", new_enemy is BaseEnemy)
	print("Instanced enemy scene:", new_enemy)
	print("Enemy class name: %s | script path: %s" % [
		new_enemy.get_class(), new_enemy.get_script().resource_path
	])
	print("SpawnNode1: spawned", new_enemy.name, "at", new_enemy.global_position)
	
	if new_enemy.has_method("_give_unique_item"):
		new_enemy.randomized_item = new_enemy._give_unique_item()
	else:
		push_warning("Enemy %s has no _give_unique_item()" % new_enemy)
	var area = new_enemy.get_node_or_null("Area2D")
	if "spawner" in new_enemy:
		new_enemy.spawner = self
		new_enemy.add_to_group("enemies")
	if area != null:
		area.spawner = self
	else: print("Error: Could not find Area2D in spawned enemy")
	add_child.call_deferred(new_enemy)
	new_enemy.global_position = global_position
	print("SpawnNode1: moved", new_enemy.name, "to", new_enemy.global_position)
	spawned_enemies.append(new_enemy)
	
func get_spawned_enemies() -> Array:
	return spawned_enemies
