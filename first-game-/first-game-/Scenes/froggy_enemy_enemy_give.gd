extends BaseEnemy
class_name Froggy
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(300, 450)
	ui.attack  = randi_range(50, 80)
	ui.defense = randi_range(30, 50)
	ui.speed   = randi_range(80, 110)
	ui.type    = [18, 13] # Water / Normal
	ui.moves = MovesFactory.get_moves("froggy")
