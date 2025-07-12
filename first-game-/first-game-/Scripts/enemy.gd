extends Area2D
var inv = Inv
signal battle_started_with_group(enemy_group)
var spawner: SpawnNode1 = null
#If a body enters the enemy area, in_battle would be set to 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player and BattleManager.state == 0:
		var group: Array = []
		var group_parent := spawner.get_parent()
		for s in group_parent.get_children():
			if s is SpawnNode1:
				var spawned_arr : Array[BaseEnemy] = s.get_spawned_enemies()
				if spawned_arr.size() > 0:
					group.append(spawned_arr[0])
			
		print("Group from spawner:", group)
		BattleManager.engage_enemy_group(group)
		print("Enemies engaged:")
		for data in BattleManager.enemy_data_list:
			print(data)
		print("Battle.in_battle = 1")


#Sets a button for battle to be won instantly: set in_battle to 2
#Remove after combat system is completed
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("battle_win"):
		BattleManager.state = 2
		BattleManager.state = 0
		print("Battle.in_battle = 2 enemy")
		
